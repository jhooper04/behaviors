
local action = behaviors.action
local free_jump = behaviors.class("free_jump", action)
behaviors.free_jump = free_jump

function free_jump:constructor(config)
    action.constructor(self)
    self.jump_velocity = config.jump_velocity
    self.phase = 1
end

function free_jump:reset()
    action.reset(self)
    self.phase = 1
end

function free_jump:on_step(...)
    local vel=self.object.object:get_velocity()
    if self.phase == 1 then
        vel.y = vel.y + self.jump_velocity
        self.object.object:set_velocity(vel)
        self.phase = 2
    else
        if vel.y <= 0.01 then return true end
        local dir = minetest.yaw_to_dir(self.object.object:get_yaw())
        dir.y=vel.y
        self.object.object:set_velocity(dir)
    end
end

-- Properties
-----------------------------------

-- jump_velocity - (number) vertical velocity of jump



-- function mobkit.lq_freejump(self)
-- 	local phase = 1
-- 	local func=function(self)
-- 		local vel=self.object:get_velocity()
-- 		if phase == 1 then
-- 			vel.y=vel.y+6
-- 			self.object:set_velocity(vel)
-- 			phase = 2
-- 		else
-- 			if vel.y <= 0.01 then return true end
-- 			local dir = minetest.yaw_to_dir(self.object:get_yaw())
-- 			dir.y=vel.y
-- 			self.object:set_velocity(dir)
-- 		end
-- 	end
-- 	mobkit.queue_low(self,func)
-- end