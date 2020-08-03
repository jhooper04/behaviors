--- Parallel nodes inherit from the @{composite} base node class. Parallel nodes execute each of their
-- children in order from left to right every time they are run. Parallel nodes can be configured to
-- succeed when a certain number of children succeed or fail when a certain number of children fail.
-- @composite parallel

local composite = behaviors.composite
local parallel = behaviors.class("parallel", composite)
behaviors.parallel = parallel

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield tab children The instantiated child nodes of this @{parallel} node.
-- @tfield enum strategy The @{behaviors.parallel_strategy} enum for pass certain or fail certain.
-- @tfield number target_count The target number of successes or fails of child nodes.

--- Constructs a @{parallel} node class instance.
-- @tparam config config The configuration options for this @{parallel} node
function parallel:constructor(config)
    composite.constructor(self, config)
    self.strategy = config.strategy or behaviors.parallel_strategy.PASS_CERTAIN
    self.target_count = config.target_count
    self.node_states = {}
end

--- Resets the @{parallel} node's state and other stateful properties for itself and all of it's children.
function parallel:reset()
    composite.reset(self)
    self.node_states = {}
end

--- The main method that handles the processing for this @{parallel} node. Each child is executed in order until the
-- pass or fail target count is reached.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", "success", or "failed".
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

--- Counts the number of child nodes that succeeded, failed, or currently running still. If strategy is
-- PASS_CERTAIN then when the number of successes is equal to or greater than the target count, this @{parallel}
-- node succeeds. If all children have finished and the target count has not been reached, this @{parallel}
-- node will fail. If strategy is FAIL_CERTAIN then when the number of failed child nodes is equal to or
-- greater than the target count, then this @{parallel} node fails. if all the children have
-- finished and the target count has not been reached, this @{parallel} node will succeed.
-- @return A string representing the enum @{behaviors.states} of "running", "success", or "failed".
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

-- Optionally overidden and called when the node begins processing.
-- @function on_start
-- @param ... Any parameters passed to parent node's run call
-- @abstract

--- Optionally overidden and called when the node finishes processing.
-- @function on_finish
-- @param ... Any parameters passed to the node's run method
-- @abstract