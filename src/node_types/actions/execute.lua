
local action = behaviors.action
local execute = behaviors.class("execute", action)
behaviors.execute = execute

function execute:constructor(config)
    action.constructor(self)
    self.function_name = config.function_name
end

function execute:on_step(...)
    local ret = self.object[self.function_name](self.object, ...)

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

-- function_name - (string) name of the function on the node's object to execute return value is state enum
