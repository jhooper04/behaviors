
local decorator = behaviors.decorator
local failure = behaviors.class("failure", decorator)
behaviors.failure = failure

function failure:constructor(config)
    decorator.constructor(self, config)
end

function failure:on_step(...)
    local ret = self:get_child():run(...)
    if ret == behaviors.states.RUNNING then
        return self:running()
    end
    return self:fail()
end

-- Properties
-----------------------------------

-- children - (array of nodes) list of child nodes (must be one child for decorators)
