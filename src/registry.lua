---
-- @module behaviors

behaviors._registered_nodes = {}
behaviors._registered_modules = {}

--- Registers a @{node} type to be used with the tree builder and owlbt json files.
-- @string name The name of the node type to register
-- @tparam node node The node type class to register
function behaviors.register_node(name, node)
    behaviors._registered_nodes[name] = node
end

--- Registers a subtree module that can be used as a single subtree action node for modularity and simpler trees
-- with complex behaviors.
-- @string name The name of the subtree module to register
-- @tab source The parsed (and already converted from owlbt) subtree definition table.
function behaviors.register_module(name, source)
	behaviors._registered_modules[name] = source
end

--- Gets a registered node class type by name.
-- @string name The name of the registered node type to get
-- @treturn node Registered node type class
function behaviors.get_node(name)
    assert(type(name) == 'string' and behaviors._registered_nodes[name])
    return behaviors._registered_nodes[name]
end

--- Gets a registered subtree module definition by name.
-- @string name The name of the registered module definition to get.
-- @treturn tab Returns the subtree definition table.
function behaviors.get_module(name)
    assert(type(name) == 'string' and behaviors._registered_modules[name])
    return behaviors._registered_modules[name]
end
