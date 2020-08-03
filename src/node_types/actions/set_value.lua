--- The set-value node inherits from the @{action} base node class and will assign a configured value
-- on the node's associated set object based on a key, value, and data type configuration.
-- @action set_value

local action = behaviors.action
local set_value = behaviors.class("set_value", action)
behaviors.set_value = set_value

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield string key The key to set on the node's set object.
-- @tfield string data_type The data type of the value to set. Currently supports "string", "number", or "bool"
-- @tfield string value The value to apply to the key of the node's set object.

--- Constructs a @{set_value} node class instance.
-- @tparam config config The configuration options for this @{set_value} node
function set_value:constructor(config)
    action.constructor(self)
    self.key = config.key
    self.value = config.value
    self.data_type = config.data_type
end

--- Gets the configured value on the node's object and converts the data type.
-- @treturn string|number|bool value to be used in the comparison check condition.
function set_value:get_value()
    if self.value:sub(1, 1) == "$" then
        return self.object[self.value:sub(2)]
    end
    if self.data_type == "string" then
        return tostring(self.value)
    elseif self.data_type == "number" then
        return tonumber(self.value)
    elseif self.data_type == "bool" then
        return not not self.value
    end
end

--- The main method that handles the processing for this @{set_value} node. This node will set the node's
-- set object's configured key to the value specified. Currently sets the key and succeeds.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "success", or "failed".
function set_value:on_step(...)
    self.object[self.key] = self:get_value()
    return self:succeed()
end
