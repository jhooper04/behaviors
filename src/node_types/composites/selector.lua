
local composite = behaviors.composite
local selector = behaviors.class("selector", composite)
behaviors.selector = selector

-- Selector Nodes execute their children from left to right. They stop executing
-- when one of their children succeeds. If a Selector's child succeeds, the Selector succeeds.
-- If all the Selector's children fail, the Selector fails.

function selector:constructor(config)
    composite.constructor(self, config)
    self.current_index = 1
end

function selector:reset()
    composite.reset(self)
    self.current_index = 1
end

function selector:on_step(...)

    while self.current_index <= #self.children do
        local child = self.children[self.current_index]
        local ret = child:run(...)
        if ret == behaviors.states.SUCCESS then
            return self:succeed()
        elseif ret == behaviors.states.RUNNING then
            return self:running()
        end
        self.current_index = self.current_index+1
    end
    return self:fail()
end

-- Properties
-----------------------------------

-- children - (array of nodes) list of child nodes