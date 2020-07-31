
local tree = behaviors.class('tree')
behaviors.tree = tree

--behaviors.shared_blackboard = {}

function tree:constructor(root_node)
    self.root_node = root_node
end

function tree:set_object(object)
    self.root_node:set_object(object)
end

function tree:set_shared_object(object)
    self.root_node:set_shared_object(object)
end

function tree:run(...)
    assert(self.root_node.object ~= nil, "No object set on tree before calling run")
    return self.root_node:run(...)
end

function tree:is_finished()
    return self.root_node:get_state() ~= behaviors.states.RUNNING
end

function tree:reset()
    self.root_node:reset()
end

