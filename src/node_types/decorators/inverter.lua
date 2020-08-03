--- The inverter node inherits from the @{decorator} base node class and will invert
-- failures into successes as well as successes into failures. A status of running will be passed along unchanged.
-- @decorator inverter

local decorator = behaviors.decorator
local inverter = behaviors.class("inverter", decorator)
behaviors.inverter = inverter

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield tab children The instantiated child nodes of this @{inverter} node. @{decorator}s may have only one child.

--- Constructs a @{inverter} node class instance.
-- @tparam config config The configuration options for this @{inverter} node
function inverter:constructor(config)
    decorator.constructor(self, config)
end

--- The main method that handles the processing for this @{inverter} node. The child node is run and this node
-- returns a status of failed if the child succeeds. If the child fails, then this node succeeds. A status of
-- running is returned if the child returns a status of running.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", "success", or "failed".
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

--- Helper method to invert the returned success or failed state from the child. A status of running is passed
-- through unchanged.
-- @param state A string representing the enum @{behaviors.states} of "running", "success", or "failed".
-- @return A string representing the enum @{behaviors.states} of "running", "success", or "failed".
function inverter:invert(state)
    if state == behaviors.states.FAILED then
        return behaviors.states.SUCCESS
    elseif state == behaviors.states.SUCCESS then
        return behaviors.states.FAILED
    else
        return behaviors.states.RUNNING
    end
end
