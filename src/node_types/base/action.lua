--- Base abstract action class that inherits properties and methods from the @{node} class. Derived classes are meant to
-- perform some type of operation on the associated node's object or its shared object and has no
-- child nodes of its own.
-- @base action

local node = behaviors.node
local action = behaviors.class("action", node, true)
behaviors.action = action

--- Constructs a base @{action} class instance (not called directly as it is an abstract class that
-- requires methods to be overriden).
function action:constructor()
    node.constructor(self)
end

--- Optionally overidden and called when the node begins processing.
-- @function on_start
-- @param ... Any parameters passed to parent node's run call
-- @abstract

--- The main method that handles the processing for this @{node}. Subclasses will override this
-- method to perform specific tasks relevant to the @{node}'s individual types.
-- @function on_step
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", "success", or "failed".
-- @abstract

--- Optionally overidden and called when the node finishes processing.
-- @function on_finish
-- @param ... Any parameters passed to the node's run method
-- @abstract
