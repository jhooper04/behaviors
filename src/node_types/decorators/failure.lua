--- The failure node inherits from the @{decorator} base node class and will always return a failed status
-- unless the decorated (child) node is still running.
-- @decorator failure

local decorator = behaviors.decorator
local failure = behaviors.class("failure", decorator)
behaviors.failure = failure

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield tab children The instantiated child nodes of this @{failure} node. @{decorator}s may have only one child.

--- Constructs a @{failure} node class instance.
-- @tparam config config The configuration options for this @{failure} node
function failure:constructor(config)
    decorator.constructor(self, config)
end

--- The main method that handles the processing for this @{failure} node. The child node is run and this node
-- returns a status of failed unless the child node returns a status of running.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", or "failed".
function failure:on_step(...)
    local ret = self:get_child():run(...)
    if ret == behaviors.states.RUNNING then
        return self:running()
    end
    return self:fail()
end
