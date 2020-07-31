
local node = behaviors.node
local action = behaviors.class("action", node, true)
behaviors.action = action

function action:constructor(config)
    node.constructor(self)
end

--abstract methods to override
-----------------------------------

--function condition:on_start(...) --returns nil (optional)
--function condition:on_step(...) --returns state enum
--function condition:on_finish(...) --returns nil (optional)
