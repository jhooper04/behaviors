
local condition = behaviors.condition
local random = behaviors.class("random", condition)
behaviors.random = random

function random:constructor(config)
    condition.constructor(self)
    self.probability = config.probability
end

function random:check_condition(...)
    return math.random() < self.probability
end

-- Properties
-----------------------------------

-- probability - (float) chance between 0 and 1 where 0 never succeeds and 1 always succeeds
