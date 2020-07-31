
local action = behaviors.action
local execute_shared = behaviors.class("execute_shared", action)
behaviors.execute_shared = execute_shared

function execute_shared:constructor(config)
    action.constructor(self)
    self.function_name = config.function_name
end

function execute_shared:on_step(...)
    local ret = self.shared_object[self.function_name](self.object, ...)

    if ret == behaviors.states.SUCCESS then
        return self:succeed()
    elseif ret == behaviors.states.FAILED then
        return self:fail()
    elseif ret == behaviors.states.RUNNING then
        return self:running()
    elseif ret == nil then
        return self:succeed()
    elseif ret then
        return self:succeed()
    else
        return self:fail()
    end
end

-- Properties
-----------------------------------

-- function_name - (string) name of the function on the node's shared object to execute
