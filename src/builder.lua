---
-- @module behaviors


local function convert_owlbt_source(owlbt_source, decorator_child)
    local source = {}

    source.type = owlbt_source.type

    for _, child in pairs(owlbt_source.childNodes or {}) do
        if not source.children then
            source.children = {}
        end
        table.insert(source.children, convert_owlbt_source(child))
    end

    local decorators = owlbt_source.decorators or {}
    for i = #decorators, 1, -1 do
        source = convert_owlbt_source(owlbt_source.decorators[i], source)
    end

    if decorator_child then
        if not source.children then
            source.children = {}
        end
        table.insert(source.children, decorator_child)
        if owlbt_source.periodic then
            source.periodic = owlbt_source.periodic
        end
        if owlbt_source.inverseCheckCondition then
            source.invert_condition = owlbt_source.inverseCheckCondition
        end
    end

    for _, property in pairs(owlbt_source.properties or {}) do
        source[property.name] = property.value
    end

    return source
end

--- Loads an owlbt format json file, parses it into a table, and converts it into the behaviors mod format.
-- @string path The file path of the owlbt json file to load.
-- @treturn tab The parsed and converted behavior tree definition table.
function behaviors.load_json_file(path)
    local file = io.open(path, "r")
    local owlbt_source_str = file:read("*a")
    file:close()
    local res = convert_owlbt_source(minetest.parse_json(owlbt_source_str))
    return res
end

--- Instantiates nodes from a behavior tree definition table using the registered @{node} types.
-- @tab source The behavior tree defnition table.
-- @treturn node The root node of the instantiated node tree.
function behaviors.construct_nodes(source)
    local node_class = behaviors.get_node(source.type)
    assert(node_class, "No node type registered for " .. source.type)

    local config = {}
    for key,value in pairs(source) do
        if key == "children" then
            config.children = {}
            for _,child in ipairs(value) do
                table.insert(config.children, behaviors.construct_nodes(child))
            end
        else
            config[key] = value
        end
    end

    return node_class(config)
end

--- Loads a behavior tree definition table, converts it to behavior mod format, and registers it as a module subtree.
-- @string name The name to register the subtree module as.
-- @string path The file path to the owlbt json file defining the behavior tree.
function behaviors.load_module(name, path)
    behaviors.register_module(name, behaviors.load_json_file(path))
end

--- Instantiates a registered module subtree definition table (already converted from owlbt definition).
-- @string name The name of the registered subtree module.
-- @treturn node The root node of the instantiated node tree.
function behaviors.build_module(name)
    assert(type(name) == 'string' and behaviors._registered_modules[name])
	return behaviors.construct_nodes(behaviors._registered_modules[name])
end

--- Instantiates behavior @{tree} from an owl bt tree definition.
-- @tparam tab|string owlbt_source unconverted owl bt tree definition table or the string to parse into a table.
-- @treturn tree The instantiated behavior tree.
function behaviors.build_owl_tree(owlbt_source)
    if type(owlbt_source) == "string" then
        owlbt_source = minetest.parse_json(owlbt_source)
    end
    return behaviors.tree(
        behaviors.construct_nodes(
            convert_owlbt_source(owlbt_source)
        )
    )
end

--- Loads owlbt json file, converts it to behaviors mod format, and instantiates it all at once from a file path.
-- @string path The owlbt json file path to load and instantiate.
function behaviors.load_and_build_owl_tree(path)
    local file = io.open(path, "r")
    local owlbt_source_str = file:read("*a")
    file:close()
    local owlbt_source = minetest.parse_json(owlbt_source_str)
    return behaviors.build_owl_tree(owlbt_source)
end

