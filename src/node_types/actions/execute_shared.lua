--- The execute-shared node inherits from the @{action} base node class and will execute a function on the node's
-- associated set shared object. The configured function can return a @{behaviors.states} enum value,
-- nil (succeeds), true for success, or false for failure.
-- @action execute_shared

local action = behaviors.action
local execute_shared = behaviors.class("execute_shared", action)
behaviors.execute_shared = execute_shared

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield string function_name The name of the function to execute on the node's set shared object.

--- Constructs a @{execute_shared} node class instance.
-- @tparam config config The configuration options for this @{execute_shared} node
function execute_shared:constructor(config)
    action.constructor(self)
    self.function_name = config.function_name
end

--- The main method that handles the processing for this @{execute_shared} node. This node will execute the named
-- function on the associated set shared object of this node passing the shared object as the self parameter to
-- the function as well as the node's set object as the second parameter and any other parameters from the node's
-- run call. If the function returns an actual @{behaviors.states} enum string, then that state value will be
-- this node's result. If the function returns nil or truthy value then this node succeeds. If the function
-- returns false, then this node fails.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", "success", or "failed".
function execute_shared:on_step(...)
    local ret = self.shared_object[self.function_name](self.shared_object, self.object, ...)

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
