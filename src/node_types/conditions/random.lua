--- The random node inherits from the @{condition} base node class and will randomly succeed or fail based on
-- the configured probability.
-- @condition random

local condition = behaviors.condition
local random = behaviors.class("random", condition)
behaviors.random = random

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield number probability The chance between 0 and 1 where 0 never succeeds and 1 always succeeds

--- Constructs a @{random} node class instance.
-- @tparam config config The configuration options for this @{random} node
function random:constructor(config)
    condition.constructor(self)
    self.probability = config.probability
end

--- The main method that handles the check for this @{random} node. Will randomly succeed or fail based on
-- the probability.
-- @param ... Any parameters passed to the node's run method
-- @treturn bool True if a random value is less than the probability or false otherwise.
function random:check_condition(...)
    return math.random() < self.probability
end

