
behaviors._registered_nodes = {}
behaviors._registered_modules = {}

function behaviors.register_node(name, node)
    behaviors._registered_nodes[name] = node
end

function behaviors.register_module(name, source)
	behaviors._registered_modules[name] = source
end

function behaviors.get_node(name)
    assert(type(name) == 'string' and behaviors._registered_nodes[name])
    return behaviors._registered_nodes[name]
end

function behaviors.get_module(name)
    assert(type(name) == 'string' and behaviors._registered_modules[name])
    return behaviors._registered_modules[name]
end
