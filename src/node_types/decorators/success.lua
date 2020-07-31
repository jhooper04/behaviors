
local decorator = behaviors.decorator
local success = behaviors.class("success", decorator)
behaviors.success = success

function success:constructor(config)
    decorator.constructor(self, config)
end

function success:on_step(...)
    local ret = self:get_child():run(...)
    if ret == behaviors.states.RUNNING then
        return self:running()
    end
    return self:succeed()
end

-- Properties
-----------------------------------

-- children - (array of nodes) list of child nodes (must be one child for decorators)
