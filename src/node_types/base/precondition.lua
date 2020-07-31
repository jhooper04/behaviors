
local decorator = behaviors.decorator
local precondition = behaviors.class("precondition", decorator, true)
behaviors.precondition = precondition

function precondition:constructor(config)
    decorator.constructor(self, config)
end

function precondition:on_step(...)
    if self:check_precondition(...) then
        return self:get_child():run(...)
    else
        return self:fail()
    end
end

--abstract methods to override
-----------------------------------

--function condition:on_start(...) --returns nil (optional)
--function condition:check_precondition(...) --returns bool
--function condition:on_finish(...) --returns nil (optional)

