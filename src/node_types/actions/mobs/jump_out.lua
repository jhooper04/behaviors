

local action = behaviors.action
local jump_out = behaviors.class("jump_out", action)
behaviors.jump_out = jump_out

function jump_out:constructor(config)
    action.constructor(self)
    self.phase = 1
end

function jump_out:reset()
    action.reset(self)
    self.phase = 1
end

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

-- Properties
-----------------------------------



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