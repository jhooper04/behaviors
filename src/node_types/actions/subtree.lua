
local action = behaviors.action
local subtree = behaviors.class("subtree", action)
behaviors.subtree = subtree

function subtree:constructor(config)
    action.constructor(self)
    self.module_name = config.module_name
    self.root_node = behaviors.build_module(self.module_name)
end

function subtree:reset()
    action.reset(self)
    self.root_node:reset()
end

function subtree:set_object(object)
    action.set_object(self, object)
    self.root_node:set_object(object)
end

function subtree:set_shared_object(object)
    action.set_shared_object(self, object)
    self.root_node:set_shared_object(object)
end

function subtree:on_step(...)
    local ret = self.root_node:run(...)

    if ret == behaviors.states.SUCCESS then
        return self:succeed()
    elseif ret == behaviors.states.FAILED then
        return self:fail()
    else
        return self:running()
    end
end

-- Properties
-----------------------------------

-- module_name - registered subtree module that this node represents
