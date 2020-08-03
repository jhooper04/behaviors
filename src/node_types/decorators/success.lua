--- The success node inherits from the @{decorator} base node class and will always return a success status
-- unless the child node is still running.
-- @decorator success

local decorator = behaviors.decorator
local success = behaviors.class("success", decorator)
behaviors.success = success

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield tab children The instantiated child nodes of this @{success} node. @{decorator}s may have only one child.

--- Constructs a @{success} node class instance.
-- @tparam config config The configuration options for this @{success} node
function success:constructor(config)
    decorator.constructor(self, config)
end

--- The main method that handles the processing for this @{success} node. The child node is run and this node
-- returns a status of success unless the child node returns a status of running.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", or "success".
function success:on_step(...)
    local ret = self:get_child():run(...)
    if ret == behaviors.states.RUNNING then
        return self:running()
    end
    return self:succeed()
end

