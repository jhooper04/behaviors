--- The repeater node inherits from the @{decorator} base node class and will run and rerun its child node a configured
-- number of times. It can be configured to ignore failures or fail itself if its child fails. It can also be configured
-- to run its child node the specified amount of times everytime itself is run instead of once per step.
-- @decorator repeater

local decorator = behaviors.decorator
local repeater = behaviors.class("repeater", decorator)
behaviors.repeater = repeater

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield number repeat_times The number of times to repeat running of the child node.
-- @tfield bool ignore_failure Set to true if the @{repeater} should continue repeating after a failed child result.
-- @tfield bool once_per_step Set to true if the @{repeater} node should only run the child once per run call.
-- @tfield tab children The instantiated child nodes of this @{repeater} node. @{decorator}s may have only one child.

--- Constructs a @{repeater} node class instance.
-- @tparam config config The configuration options for this @{repeater} node
function repeater:constructor(config)
    decorator.constructor(self, config)
    self.repeat_times = config.repeat_times
    self.ignore_failure = config.ignore_failure or false
    self.once_per_step = config.once_per_step or true
    self.finished_times = 0
end

--- Resets the @{repeater}'s state and other stateful properties for itself and its child.
function repeater:reset()
    decorator.reset(self)
    self.finished_times = 0
end

--- The main method that handles the processing for this @{repeater} node. The child node is run in a loop
-- reseting the child on each iteration until the repeat times configuration is reached. If once-per-step
-- is true, then the child will only be ran once per call of this node's run function and returning a status
-- of running until the repeat count is reached if failures are ignored. When failures are not ignored, when
-- child fails, this node will fail. This node succeeds when the repeat count is reached.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", "success", or "failed".
function repeater:on_step(...)

    if self.finished_times >= self.repeat_times then
        return self:succeed()
    end

    local first_loop_run = true
    local child = self:get_child()

    while self.finished_times < self.repeat_times do
        if first_loop_run then
            first_loop_run = false
        else
            child:reset()
            if self.once_per_step then
                return self:running()
            end
        end
    
        local ret = child:run(...)

        if ret == behaviors.states.RUNNING then
            return self:running()
        elseif not self.ignore_failure then
            return self:fail()
        end

        self.finished_times = self.finished_times + 1
    end

    return self:succeed()
end
