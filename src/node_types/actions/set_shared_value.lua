
local action = behaviors.action
local set_shared_value = behaviors.class("set_shared_value", action)
behaviors.set_shared_value = set_shared_value

function set_shared_value:constructor(config)
    action.constructor(self)
    self.key = config.key
    self.value = config.value
    self.data_type = config.data_type
end

function set_shared_value:on_step(...)
    self.shared_object[self.key] = self.value
    return self:succeed()
end

-- Properties
-----------------------------------

-- key - (string) key on node's object to set
-- value - (string) string value to deserialize
-- data_type - (string) the data type to convert the value to
