
local condition = behaviors.condition
local has_shared_value = behaviors.class("has_shared_value", condition)
behaviors.has_shared_value = has_shared_value

function has_shared_value:constructor(config)
    condition.constructor(self, config)
    self.key = config.key
end

function has_shared_value:check_condition(...)
    return self.shared_object[self.key] ~= nil
end

-- Properties
-----------------------------------

-- key - (string) table key to check if set on the shared blackboard

