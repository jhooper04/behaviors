
local action = behaviors.action
local set_value = behaviors.class("set_value", action)
behaviors.set_value = set_value

function set_value:constructor(config)
    action.constructor(self)
    self.key = config.key
    self.value = config.value
    self.data_type = config.data_type
end

function set_value:on_step(...)
    self.object[self.key] = self.value
    return self:succeed()
end

-- Properties
-----------------------------------

-- key - (string) key on node's object to set
-- value - (string) string value to deserialize
-- data_type - (string) the data type to convert the value to

