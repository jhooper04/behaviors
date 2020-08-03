--- The subtree node inherits from the @{action} base node class and will retrieve a registered subtree module
-- and instantiate it so this single action node represents executing an entire subtree of behavior nodes for modularity
-- and simplified complex trees. Subtree modules need to be previously registered with @{behaviors.register_module}.
-- @action subtree

local action = behaviors.action
local subtree = behaviors.class("subtree", action)
behaviors.subtree = subtree

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield string module_name The registered subtree module that this node should instantiate.

--- Constructs a @{subtree} node class instance.
-- @tparam config config The configuration options for this @{subtree} node
function subtree:constructor(config)
    action.constructor(self)
    self.module_name = config.module_name
    self.root_node = behaviors.build_module(self.module_name)
end

--- Resets the @{subtree} node's state and the state of the subtree's nodes.
function subtree:reset()
    action.reset(self)
    self.root_node:reset()
end

--- Sets the object that this @{subtree} node will operate on as well as its subtree's nodes.
-- @tab object The object that the @{subtree} will operate on
function subtree:set_object(object)
    action.set_object(self, object)
    self.root_node:set_object(object)
end

--- Sets the shared object that that the @{subtree} instance will operate on as well as its subtree's nodes.
-- @tab object The shared object
function subtree:set_shared_object(object)
    action.set_shared_object(self, object)
    self.root_node:set_shared_object(object)
end

--- The main method that handles the processing for this @{subtree} node. This node will run the subtree module's
-- root node and pass along the state result as this node's state.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", "success", or "failed".
function subtree:on_step(...)
    local ret = self.root_node:run(...)

    if ret == behaviors.states.SUCCESS then
        return self:succeed()
    elseif ret == behaviors.states.FAILED then
        return self:fail()
    else
        return self:running()
    end
end
