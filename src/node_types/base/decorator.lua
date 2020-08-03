--- Base abstract decorator class that inherits properties and methods from the @{composite} class.
-- Derived classes are meant to have a single child node that it decorates, altering the child node's result.
-- @base decorator

local composite = behaviors.composite
local decorator = behaviors.class("decorator", composite, true)
behaviors.decorator = decorator

--- Configuration table passed into the constructor function.
-- @table config
-- @field children The instantiated child nodes of this @{decorator} node.

--- Constructs a base @{composite} class instance (not called directly as it is an abstract class that
-- requires methods to be overriden).
-- @tparam config config The configuration options for this @{composite} node
function decorator:constructor(config)
    composite.constructor(self, config)
end

--- Gets the first child of the @{decorator} as decorators can only have one child node.
-- @treturn node The first child of the decorator.
function decorator:get_child()
    return self.children[1]
end

--- Optionally overidden and called when the node begins processing.
-- @function on_start
-- @param ... Any parameters passed to parent node's run call
-- @abstract

--- The main method that handles the processing for this @{decorator}. Subclasses will implement this
-- method to perform specific tasks relevant to the @{decorator} node's individual types.
-- @function on_step
-- @param ... Any parameters passed to the decorator's run method
-- @return A string representing the enum @{behaviors.states} of "running", "success", or "failed".
-- @abstract

--- Optionally overidden and called when the node finishes processing.
-- @function on_finish
-- @param ... Any parameters passed to the node's run method
-- @abstract
