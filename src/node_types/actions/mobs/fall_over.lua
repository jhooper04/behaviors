
local action = behaviors.action
local fall_over = behaviors.class("fall_over", action)
behaviors.fall_over = fall_over

function fall_over:constructor(config)
    action.constructor(self)
    self.fall_animation = config.fall_animation
    self.fall_sound = config.fall_sound
    self.z_rot = 0
end

function fall_over:reset()
    action.reset(self)
    self.z_rot = 0
end

function fall_over:on_start()
    local vel = self.object.object:get_velocity()
    self.object.object:set_velocity(bt_mobs.pos_shift(vel,{y=1}))
    bt_mobs.animate(self.object, self.fall_animation)
    bt_mobs.make_sound(self.object, self.fall_sound)
end

function fall_over:on_step(...)

    self.z_rot = self.z_rot + math.pi * 0.05
    local rot = self.object.object:get_rotation()
    self.object.object:set_rotation({ x=rot.x, y=rot.y, z=self.z_rot })

    if self.z_rot >= math.pi * 0.5 then
        return self:succeed()
    end
end

-- Properties
-----------------------------------

-- fall_animation - (string) animation to play when fall begins
-- fall_sound - (string) sound to play when fall begins


-- function mobkit.lq_fallover(self)
-- 	local zrot = 0
-- 	local init = true
-- 	local func=function(self)
-- 		if init then
-- 			local vel = self.object:get_velocity()
-- 			self.object:set_velocity(mobkit.pos_shift(vel,{y=1}))
-- 			mobkit.animate(self,'stand')
-- 			init = false
-- 		end
-- 		zrot=zrot+pi*0.05
-- 		local rot = self.object:get_rotation()
-- 		self.object:set_rotation({x=rot.x,y=rot.y,z=zrot})
-- 		if zrot >= pi*0.5 then return true end
-- 	end
-- 	mobkit.queue_low(self,func)
-- end