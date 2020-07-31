
local composite = behaviors.composite
local sequence = behaviors.class("sequence", composite)
behaviors.sequence = sequence

-- Sequence nodes execute their children from left to right. They stop executing when one
-- of their children fails. If a child fails, then the Sequence fails. If all the Sequence's
-- children succeed, then the Sequence succeeds.

function sequence:constructor(config)
    composite.constructor(self, config)
    self.current_index = 1
end

function sequence:reset()
    composite.reset(self)
    self.current_index = 1
end

function sequence:on_step(...)

    while self.current_index <= #self.children do
        local child = self.children[self.current_index]
        local ret = child:run(...)
        if ret == behaviors.states.FAILED then
            return self:fail()
        elseif ret == behaviors.states.RUNNING then
            return self:running()
        end
        self.current_index = self.current_index+1
    end
    return self:succeed()
end

-- Properties
-----------------------------------

-- children - (array of nodes) list of child nodes