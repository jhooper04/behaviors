--- Base abstract precondition class that inherits properties and methods from the @{decorator} class.
-- Derived classes are meant to check a precondition before running its child or fail if the precondition is false.
-- @base precondition

local decorator = behaviors.decorator
local precondition = behaviors.class("precondition", decorator, true)
behaviors.precondition = precondition

--- Configuration table passed into the constructor function.
-- @table config
-- @field children The instantiated child nodes of this @{precondition} node.

--- Constructs a base @{precondition} class instance (not called directly as it is an abstract class that
-- requires methods to be overriden).
-- @tparam config config The configuration options for this @{precondition} node
function precondition:constructor(config)
    decorator.constructor(self, config)
end

--- The main method that handles the processing for this @{precondition}. Subclasses will implement
-- the @{check_precondition} method instead of the normal on_step function. If the precondition check
-- returns false, then this node fails; otherwise, it will run it's child.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", "success", or "failed".
function precondition:on_step(...)
    if self:check_precondition(...) then
        return self:get_child():run(...)
    else
        return self:fail()
    end
end

--- Optionally overidden and called when the node begins processing.
-- @function on_start
-- @param ... Any parameters passed to parent node's run call
-- @abstract

--- The main method that handles the condition checking for this @{condition}. Subclasses will implement this
-- method to perform specific checks relevant to the @{condition}'s individual subclass node type.
-- @function check_precondition
-- @param ... Any parameters passed to the node's run method
-- @treturn bool True if the child node should be ran or false if the node should fail.
-- @abstract

--- Optionally overidden and called when the node finishes processing.
-- @function on_finish
-- @param ... Any parameters passed to the node's run method
-- @abstract
