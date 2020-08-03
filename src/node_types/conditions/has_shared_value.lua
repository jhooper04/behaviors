--- The has-shared-value node inherits from the @{condition} base node class and will check if the
-- associated node's set shared object has a property defined (checks if a key is nil on the shared object).
-- @condition has_shared_value

local condition = behaviors.condition
local has_shared_value = behaviors.class("has_shared_value", condition)
behaviors.has_shared_value = has_shared_value

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield string key The key on the node's associated set shared object to check if it is nil.

--- Constructs a @{has_shared_value} node class instance.
-- @tparam config config The configuration options for this @{has_shared_value} node
function has_shared_value:constructor(config)
    condition.constructor(self, config)
    self.key = config.key
end

--- The main method that handles the check for this @{has_shared_value} node's shared object key is not nil.
-- @param ... Any parameters passed to the node's run method
-- @treturn bool True if the key exists on the node's shared object or false otherwise.
function has_shared_value:check_condition(...)
    return self.shared_object[self.key] ~= nil
end


