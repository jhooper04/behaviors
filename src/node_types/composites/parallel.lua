
local composite = behaviors.composite
local parallel = behaviors.class("parallel", composite)
behaviors.parallel = parallel

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

-- Parallel nodes execute their children from left to right.

function parallel:constructor(config)
    composite.constructor(self, config)
    self.strategy = config.strategy or parallel_strategy.PASS_CERTAIN
    self.target_count = config.target_count
    self.node_states = {}
end

function parallel:reset()
    composite.reset(self)
    self.node_states = {}
end

function parallel:on_step(...)

    local node_count = #self.children

    for i=0, node_count do
        if self.node_states[i] == nil then
            local ret = self.children[i]:run(...)
            if ret ~= behaviors.states.RUNNING then
                self.node_states[i] = ret
            end
        end
    end

    return self:check_target()
end

function parallel:check_target()
    local pass, fail, rest = 0, 0, 0

    for _,node_state in pairs(self.node_states) do
        if node_state == behaviors.states.SUCCESS then
            pass = pass + 1
        elseif node_state == behaviors.states.FAILED then
            fail = fail + 1
        else
            rest = rest + 1
        end
    end

    if self.strategy == behaviors.parallel_strategy.PASS_CERTAIN then
        if pass >= self.target_count then
            return self:succeed()
        elseif rest == 0 then
            return self:fail()
        end
    elseif self.strategy == behaviors.parallel_strategy.FAIL_CERTAIN then
        if fail >= self.target_count then
            return self:fail()
        elseif rest == 0 then
            return self:succeed()
        end
    end

    return behaviors.states.RUNNING
end

-- Properties
-----------------------------------

-- children - (array of nodes) list of child nodes
-- strategy - (enum) PASS_CERTAIN will succeed when the number of child successes is equal to the target_count
--            FAIL_CERTAIN will succeed when the number of child failures is less than the target_count
-- target_count - (int) number of successes or failures to limit the parallel node to before itself succeeds or fails