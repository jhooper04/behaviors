
local node = behaviors.node
local composite = behaviors.class("composite", node, true)
behaviors.composite = composite

function composite:constructor(config)
    node.constructor(self)

    assert(config and config.children and #config.children > 0, "Composite nodes require at least one child node")

    self.children = {}
    for _,child in ipairs(config.children) do
        table.insert(self.children, child)
    end
end

function composite:set_object(object)
    node.set_object(self, object)
	for _,child in ipairs(self.children) do
        child:set_object(object)
    end
end

function composite:set_shared_object(object)
    node.set_shared_object(self, object)
	for _,child in ipairs(self.children) do
        child:set_shared_object(object)
    end
end

function composite:reset()
    node.reset(self)
    for _,child in ipairs(self.children) do
        child:reset()
    end
end

--abstract methods to override
-----------------------------------

--function condition:on_start(...) --returns nil (optional)
--function condition:on_step(...) --returns state enum
--function condition:on_finish(...) --returns nil (optional)
