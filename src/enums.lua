---
-- @module behaviors


--- Enum table of possible node states
-- @table states
-- @field RUNNING The node state when it is not done running
-- @field FAILED The node state when it fails
-- @field SUCCESS The node state when it succeeds
local states = setmetatable({
    RUNNING = "running",
    FAILED = "failed",
    SUCCESS = "success",
}, {
    __index = function(_, key)
        error("Invalid behaviour state: " .. key)
    end,
    __newindex = function()
        error("Attempt to assign to immutable enum 'states'")
    end,
    __metatable = false,
})
behaviors.states = states

--- Enum table of possible parallel strategies for use with the parallel node class
-- @table parallel_strategy
-- @field FAIL_CERTAIN This makes @{parallel} nodes fail when the number of failures reaches the target count.
-- @field PASS_CERTAIN This makes @{parallel} nodes succeed when the number of success reaches the target count.
local parallel_strategy = setmetatable({
    FAIL_CERTAIN = "fail_certain",
    PASS_CERTAIN = "pass_certain",
}, {
    __index = function(_, key)
        error("Invalid parallel strategy: " .. key)
    end,
    __newindex = function()
        error("Attempt to assign to immutable enum 'parallel_strategy'")
    end,
    __metatable = false,
})
behaviors.parallel_strategy = parallel_strategy