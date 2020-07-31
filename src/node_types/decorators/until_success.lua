
local decorator = behaviors.decorator
local until_success = behaviors.class("until_success", decorator)
behaviors.until_success = until_success

function until_success:constructor(config)
    decorator.constructor(self, config)
end

function until_success:on_step(...)

    local child = self:get_child()
    local ret = child:run(...)

    if ret == behaviors.states.SUCCESS then
        return self:succeed()
    elseif ret == behaviors.states.FAILED then
        child:reset()
    end
    return self:running()
end

-- Properties
-----------------------------------

-- children - (array of nodes) list of child nodes (must be one child for decorators)
