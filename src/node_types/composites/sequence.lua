--- Sequence nodes inherit from the @{composite} base node class and execute their children
-- from left to right. They stop executing when one of their children fails.
-- If a child fails, then the Sequence fails. If all the Sequence's children succeed, then the Sequence succeeds.
-- @composite sequence

local composite = behaviors.composite
local sequence = behaviors.class("sequence", composite)
behaviors.sequence = sequence

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield tab children The instantiated child nodes of this @{sequence} node.

--- Constructs a @{sequence} node class instance.
-- @tparam config config The configuration options for this @{sequence} node
function sequence:constructor(config)
    composite.constructor(self, config)
    self.current_index = 1
end

--- Resets the @{sequence} node's state and other stateful properties for itself and all of it's children.
function sequence:reset()
    composite.reset(self)
    self.current_index = 1
end

--- The main method that handles the processing for this @{sequence} node. Each child is executed in order until
-- one of them fails.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", "success", or "failed".
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
