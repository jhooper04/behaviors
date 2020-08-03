--- Base abstract condition class that inherits properties and methods from the @{node} class. Derived classes
-- are meant to check some condition and always either succeeds or fails without altering the set object
-- or shared object. Condition nodes should not have any child nodes.
-- @base condition

local node = behaviors.node
local condition = behaviors.class("condition", node, true)
behaviors.condition = condition

--- Constructs a base @{condition} class instance (not called directly as it is an abstract class that
-- requires methods to be overriden).
function condition:constructor()
    node.constructor(self)
end

--- The main method that handles the processing for this @{condition}. Subclasses will implement
-- the @{check_condition} method instead of the normal on_step function
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", "success", or "failed".
function condition:on_step(...)
    if self:check_condition(...) then
        return self:succeed()
    else
        return self:fail()
    end
end

--function condition:check_condition() end

--- Optionally overidden and called when the node begins processing.
-- @function on_start
-- @param ... Any parameters passed to parent node's run call
-- @abstract

--- The main method that handles the condition checking for this @{condition}. Subclasses will implement this
-- method to perform specific checks relevant to the @{condition}'s individual subclass node type.
-- @function check_condition
-- @param ... Any parameters passed to the node's run method
-- @treturn bool True if the node should succeed or false if the node should fail.
-- @abstract

--- Optionally overidden and called when the node finishes processing.
-- @function on_finish
-- @param ... Any parameters passed to the node's run method
-- @abstract

