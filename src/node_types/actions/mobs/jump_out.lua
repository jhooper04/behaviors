--- The jump-out node inherits from the @{action} base node class and applies a vertical jump velocity
-- to the mob and succeeds when the mob's vertical velocity returns to 0 implying it has landed.
-- @action jump_out

local action = behaviors.action
local jump_out = behaviors.class("jump_out", action)
behaviors.jump_out = jump_out

--- Constructs a @{jump_out} node class instance.
-- @tparam config config The configuration options for this @{jump_out} node (currently no configuration options).
function jump_out:constructor(config)
    action.constructor(self)
    self.phase = 1
end

--- Resets the @{jump_out} node's state and stateful properties.
function jump_out:reset()
    action.reset(self)
    self.phase = 1
end

--- The main method that handles the processing for this @{jump_out} node. This node will cause the mob to
-- jump in the direction it is currently facing and succeeds when it returns to the ground.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", or "success".
function jump_out:on_step(...)

    local vel=self.object.object:get_velocity()
    if self.phase == 1 then
        vel.y=vel.y+5
        self.object.object:set_velocity(vel)
        self.phase = 2
    else
        if vel.y < 0 then return self:succeed() end
        local dir = minetest.yaw_to_dir(self.object.object:get_yaw())
        dir.y=vel.y
        self.object.object:set_velocity(dir)
    end

    return self:running()
end


-- function mobkit.lq_jumpout(self)
-- 	local phase = 1
-- 	local func=function(self)
-- 		local vel=self.object:get_velocity()
-- 		if phase == 1 then
-- 			vel.y=vel.y+5
-- 			self.object:set_velocity(vel)
-- 			phase = 2
-- 		else
-- 			if vel.y < 0 then return true end
-- 			local dir = minetest.yaw_to_dir(self.object:get_yaw())
-- 			dir.y=vel.y
-- 			self.object:set_velocity(dir)
-- 		end
-- 	end
-- 	mobkit.queue_low(self,func)
-- end