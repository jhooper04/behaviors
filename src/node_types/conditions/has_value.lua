
local condition = behaviors.condition
local has_value = behaviors.class("has_value", condition)
behaviors.has_value = has_value

function has_value:constructor(config)
    condition.constructor(self)
    self.key = config.key
end

function has_value:check_condition(...)
    return self.object[self.key] ~= nil
end

-- Properties
-----------------------------------

-- key - (string) table key to check if set on the node's associated payload object

