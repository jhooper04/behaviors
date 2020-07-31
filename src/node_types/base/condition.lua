
local node = behaviors.node
local condition = behaviors.class("condition", node, true)
behaviors.condition = condition

function condition:constructor()
    node.constructor(self)
end

function condition:on_step(...)
    if self:check_condition(...) then
        return self:succeed()
    else
        return self:fail()
    end
end

function condition:check_condition() print("wah") end

--abstract methods to override
-----------------------------------

--function condition:on_start(...) --returns nil (optional)
--function condition:check_condition(...) --returns bool
--function condition:on_finish(...) --returns nil (optional)

