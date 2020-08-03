--- The until-success node inherits from the @{decorator} base node class and will only return success
-- when the child node succeeds; otherwise, it will reset the child and run it again on the next run of this node.
-- @decorator until_success

local decorator = behaviors.decorator
local until_success = behaviors.class("until_success", decorator)
behaviors.until_success = until_success

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield tab children The instantiated child nodes of the @{until_success} node. @{decorator}s only have one child.

--- Constructs a @{until_success} node class instance.
-- @tparam config config The configuration options for this @{until_success} node
function until_success:constructor(config)
    decorator.constructor(self, config)
end

--- The main method that handles the processing for this @{until_success} node. The child node is run on each
-- call to this node's run function and resets the child if it failed. This node returns success when the child
-- node succeeds. If the child node fails or returns running then this node returns running.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", or "success".
function until_success:on_step(...)

    local child = self:get_child()
    local ret = child:run(...)

    if ret == behaviors.states.SUCCESS then
        return self:succeed()
    elseif ret == behaviors.states.FAILED then
        child:reset()
    end
    return self:running()
end
