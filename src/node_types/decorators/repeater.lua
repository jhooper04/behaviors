
local decorator = behaviors.decorator
local repeater = behaviors.class("repeater", decorator)
behaviors.repeater = repeater

function repeater:constructor(config)
    decorator.constructor(self, config)
    self.repeat_times = config.repeat_times
    self.ignore_failure = config.ignore_failure or false
    self.once_per_step = config.once_per_step or true
    self.finished_times = 0
end

function repeater:reset()
    decorator.reset(self)
    self.finished_times = 0
end

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

-- Properties
-----------------------------------

-- children - (array of nodes) list of child nodes (must be one child for decorators)
-- repeat_times - (int) number of times to repeat running of child node
-- ignore_failure - (bool) true if repeater should continue repeating after a fail result
-- once_per_step - (bool) true if repeater should only do one run of the child per run call of the repeater
