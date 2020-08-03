--- Base abstract node class that all other node types inherit from.
-- @base node


-- Enum table of possible node states
-- @table states
-- @field RUNNING The node state when it is not done running
-- @field FAILED The node state when it fails
-- @field SUCCESS The node state when it succeeds
local states = setmetatable({
    RUNNING = "running",
    FAILED = "failed",
    SUCCESS = "success",
}, {
    __index = function(_, key)
        error("Invalid behaviour state: " .. key)
    end,
    __newindex = function()
        error("Attempt to assign to immutable enum 'states'")
    end,
    __metatable = false,
})
behaviors.states = states



local node = behaviors.class("node", nil, true)
behaviors.node = node

--- Constructs a base @{node} class instance (not called directly as it is an abstract class that
-- requires methods to be overriden).
function node:constructor()
    self.state = states.RUNNING
    self.is_started = false
end

--- Runs one step of this @{node} which may or may not have child nodes to also run.
-- Any parameters are passed down the hierarchy of nodes to each call of the child nodes' run functions.
-- @return A string representing the enum @{behaviors.states} of "running", "success", or "failed".
function node:run(...)
    if not self.is_started then
        if self.on_start then self:on_start() end
        self.is_started = true
    end
    return self:on_step(...)
end

--- Sets the object that this @{node} will operate on where every @{node} under this one will have access to it
-- @tab object The object that the @{node} will operate on
function node:set_object(object)
	self.object = object
end

--- Sets an object that many @{node} instances can share
-- @tab object The shared object
function node:set_shared_object(object)
	self.shared_object = object
end

--- Gets the current state of this @{node}
-- @return A string representing the enum @{behaviors.states} of "running", "success", or "failed".
function node:get_state()
    return self.state
end

--- Check if this @{node} is currently running.
-- @treturn bool True if running, false for any other state.
function node:is_running()
    return self.state == states.RUNNING
end

--- Check if this @{node} has succeeded.
-- @treturn bool True if succeeded, false for any other state.
function node:has_succeeded()
    return self.state == states.SUCCESS
end

--- Check if this @{node} has failed.
-- @treturn bool True if failed, false for any other state.
function node:has_failed()
    return self.state == states.FAILED
end

--- Sets the @{node}'s state to "running" implying that the node is not finished yet.
-- @return A string representing the enum @{behaviors.states} of "running".
function node:running()
    self.state = states.RUNNING
    return self.state
end

--- Sets the @{node}'s state to "success" implying that the node is done and it succeeded.
-- @return A string representing the enum @{behaviors.states} of "success".
function node:succeed()
    self.state = states.SUCCESS
    if self.on_finish then self:on_finish() end
    return self.state
end

--- Sets the @{node}'s state to "failed" implying that the node is done and it failed.
-- @return A string representing the enum @{behaviors.states} of "failed".
function node:fail()
    self.state = states.FAILED
    if self.on_finish then self:on_finish() end
    return self.state
end

--- Resets the @{node}'s state and other stateful properties so it may be ran again.
function node:reset()
    self.state = states.RUNNING
    self.is_started = false
end

--- Optionally overidden and called when the node begins processing.
-- @function on_start
-- @param any Any parameters passed to parent node's run call
-- @abstract

--- The main method that handles the processing for this @{node}. Subclasses will override this
-- method to perform specific tasks relevant to the @{node}'s individual types. The @{node} base class
-- only has an empty stub method that just throws a not implemented error.
-- @param any Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", "success", or "failed".
-- @abstract
function node:on_step(...) error("Base node on_step called but not implemented") end

--- Optionally overidden and called when the node finishes processing.
-- @function on_finish
-- @param any Any parameters passed to the node's run method
-- @abstract
