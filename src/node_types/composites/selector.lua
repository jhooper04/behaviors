--- Selector Nodes inherit from the @{composite} base node class and execute their children
-- from left to right. They stop executing when one of their children succeeds. If a Selector's
-- child succeeds, the Selector succeeds. If all the Selector's children fail, the Selector fails.
-- @composite selector

local composite = behaviors.composite
local selector = behaviors.class("selector", composite)
behaviors.selector = selector

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield tab children The instantiated child nodes of this @{selector} node.

--- Constructs a @{selector} node class instance.
-- @tparam config config The configuration options for this @{selector} node
function selector:constructor(config)
    composite.constructor(self, config)
    self.current_index = 1
end

--- Resets the @{selector} node's state and other stateful properties for itself and all of it's children.
function selector:reset()
    composite.reset(self)
    self.current_index = 1
end

--- The main method that handles the processing for this @{selector} node. Each child is executed in order until
-- one of them succeeds.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", "success", or "failed".
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
