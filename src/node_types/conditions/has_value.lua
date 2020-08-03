--- The has-value node inherits from the @{condition} base node class and will check if the
-- associated node's set object has a property defined (checks if a key is nil on the object).
-- @condition has_value

local condition = behaviors.condition
local has_value = behaviors.class("has_value", condition)
behaviors.has_value = has_value

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield string key The key on the node's associated set object to check if it is nil.

--- Constructs a @{has_value} node class instance.
-- @tparam config config The configuration options for this @{has_value} node
function has_value:constructor(config)
    condition.constructor(self)
    self.key = config.key
end

--- The main method that handles the check for this @{has_value} node's object key is not nil.
-- @param ... Any parameters passed to the node's run method
-- @treturn bool True if the key exists on the node's object or false otherwise.
function has_value:check_condition(...)
    return self.object[self.key] ~= nil
end
