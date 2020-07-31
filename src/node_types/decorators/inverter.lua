
local decorator = behaviors.decorator
local inverter = behaviors.class("inverter", decorator)
behaviors.inverter = inverter

function inverter:constructor(config)
    decorator.constructor(self, config)
end

function inverter:on_step(...)
    local ret = self:invert(self:get_child():run(...))
    if ret == behaviors.states.RUNNING then
        return self:running()
    elseif ret == behaviors.states.SUCCESS then
        return self:succeed()
    else
        return self:fail()
    end
end

function inverter:invert(state)
    if state == behaviors.states.FAILED then
        return behaviors.states.SUCCESS
    elseif state == behaviors.states.SUCCESS then
        return behaviors.states.FAILED
    else
        return behaviors.states.RUNNING
    end
end

-- Properties
-----------------------------------

-- children - (array of nodes) list of child nodes (must be one child for decorators)
