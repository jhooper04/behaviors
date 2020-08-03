--- Base abstract composite class that inherits properties and methods from the @{node} class. Derived classes
-- are meant to have one or more child nodes as the composite node represents a branch in the tree.
-- @base composite

local node = behaviors.node
local composite = behaviors.class("composite", node, true)
behaviors.composite = composite

--- Configuration table passed into the constructor function.
-- @table config
-- @field children The instantiated child nodes of this @{composite} node.

--- Constructs a base @{composite} class instance (not called directly as it is an abstract class that
-- requires methods to be overriden).
-- @tparam config config The configuration options for this @{composite} node
function composite:constructor(config)
    node.constructor(self)

    assert(config and config.children and #config.children > 0, "Composite nodes require at least one child node")

    self.children = {}
    for _,child in ipairs(config.children) do
        table.insert(self.children, child)
    end
end

--- Sets the object that this @{composite} node will operate on where every child @{node} under this one will
-- have access to it.
-- @tab object The object that the @{composite} node will operate on as well as all of it's children
function composite:set_object(object)
    node.set_object(self, object)
	for _,child in ipairs(self.children) do
        child:set_object(object)
    end
end

--- Sets the shared object that this @{composite} node will operate on where every child @{node} under this one will
-- have access to it.
-- @tab object The shared object that all the nodes will operate on
function composite:set_shared_object(object)
    node.set_shared_object(self, object)
	for _,child in ipairs(self.children) do
        child:set_shared_object(object)
    end
end

--- Resets the @{composite}'s state and other stateful properties for itself and all of it's children.
function composite:reset()
    node.reset(self)
    for _,child in ipairs(self.children) do
        child:reset()
    end
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
