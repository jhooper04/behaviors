--- The until-failure node inherits from the @{decorator} base node class and will only return success
-- when the child node fails; otherwise, it will reset the child and run it again on the next run of this node.
-- @decorator until_failure

local decorator = behaviors.decorator
local until_failure = behaviors.class("until_failure", decorator)
behaviors.until_failure = until_failure

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield tab children The instantiated child nodes of the @{until_failure} node. @{decorator}s only have one child.

--- Constructs a @{until_failure} node class instance.
-- @tparam config config The configuration options for this @{until_failure} node
function until_failure:constructor(config)
    decorator.constructor(self, config)
end

--- The main method that handles the processing for this @{until_failure} node. The child node is run on each
-- call to this node's run function and resets the child if it succeeds. This node returns success when the child
-- node fails. If the child node succeeds or returns running then this node returns running.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", or "success".
function until_failure:on_step(...)

    local child = self:get_child()
    local ret = child:run(...)

    if ret == behaviors.states.SUCCESS then
        child:reset()
    elseif ret == behaviors.states.FAILED then
        return self:succeed()
    end
    return self:running()
end

