
local composite = behaviors.composite
local decorator = behaviors.class("decorator", composite, true)
behaviors.decorator = decorator

function decorator:constructor(config)
    composite.constructor(self, config)
end

function decorator:get_child()
    return self.children[1]
end

--abstract methods to override
-----------------------------------

--function condition:on_start(...) --returns nil (optional)
--function condition:on_step(...) --returns state enum
--function condition:on_finish(...) --returns nil (optional)
