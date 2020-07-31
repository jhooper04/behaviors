
local decorator = behaviors.decorator
local until_failure = behaviors.class("until_failure", decorator)
behaviors.until_failure = until_failure

function until_failure:constructor(config)
    decorator.constructor(self, config)
end

function until_failure:on_step(...)

    local child = self:get_child()
    local ret = child:run(...)

    if ret == behaviors.states.SUCCESS then
        child:reset()
    elseif ret == behaviors.states.FAILED then
        return self:succeed()
    end
    return self:running()
end

-- Properties
-----------------------------------

-- children - (array of nodes) list of child nodes (must be one child for decorators)
