--- The execute node inherits from the @{action} base node class and will execute a function on the node's
-- associated set object. The configured function can return a @{behaviors.states} enum value,
-- nil (succeeds), true for success, or false for failure.
-- @action execute

local action = behaviors.action
local execute = behaviors.class("execute", action)
behaviors.execute = execute

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield string function_name The name of the function to execute on the node's set object.

--- Constructs a @{execute} node class instance.
-- @tparam config config The configuration options for this @{execute} node
function execute:constructor(config)
    action.constructor(self)
    self.function_name = config.function_name
end

--- The main method that handles the processing for this @{execute} node. This node will execute the named
-- function on the associated set object of this node passing the object as the self parameter to the function
-- and any other parameters from the node's run call as well. If the function returns an actual @{behaviors.states}
-- enum string, then that state value will be this node's result. If the function returns nil or truthy value then
-- this node succeeds. If the function returns false, then this node fails.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", "success", or "failed".
function execute:on_step(...)
    local ret = self.object[self.function_name](self.object, ...)

    if ret == behaviors.states.SUCCESS then
        return self:succeed()
    elseif ret == behaviors.states.FAILED then
        return self:fail()
    elseif ret == behaviors.states.RUNNING then
        return self:running()
    elseif ret == nil then
        return self:succeed()
    elseif ret then
        return self:succeed()
    else
        return self:fail()
    end
end
