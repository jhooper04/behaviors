
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

function behaviors.load_json_file(path)
    local file = io.open(path, "r")
    local owlbt_source_str = file:read("*a")
    file:close()
    local res = convert_owlbt_source(minetest.parse_json(owlbt_source_str))
    return res
end

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

function behaviors.load_module(name, path)
    behaviors.register_module(name, behaviors.load_json_file(path))
end

-- returns instantiated node object from registered modules (already converted source)
function behaviors.build_module(name)
    assert(type(name) == 'string' and behaviors._registered_modules[name])
	return behaviors.construct_nodes(behaviors._registered_modules[name])
end

-- returns instantiated tree object from owl bt soure (raw string or parsed json)
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

function behaviors.load_and_build_owl_tree(path)
    local file = io.open(path, "r")
    local owlbt_source_str = file:read("*a")
    file:close()
    local owlbt_source = minetest.parse_json(owlbt_source_str)
    return behaviors.build_owl_tree(owlbt_source)
end

