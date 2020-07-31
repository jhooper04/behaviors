
local action = behaviors.action
local dumb_walk = behaviors.class("dumb_walk", action)
behaviors.dumb_walk = dumb_walk

function dumb_walk:constructor(config)
    action.constructor(self)
    self.walk_animation = config.walk_animation
    self.speed_factor = config.speed_factor
    self.timer = 3   -- fail safe
end

function dumb_walk:reset()
    action.reset(self)
    self.timer = 3
end

function dumb_walk:on_step(...)

    bt_mobs.animate(self.object, self.walk_animation)

    self.timer = self.timer - self.object.dtime
    
    if self.timer < 0 then return self:succeed() end
    
    local pos = bt_mobs.get_stand_pos(self.object)
    local y = self.object.object:get_velocity().y

    if bt_mobs.is_there_yet2d(pos, minetest.yaw_to_dir(self.object.object:get_yaw()), self.object.target_pos) then

        -- prevent uncontrolled fall when velocity too high and is_on_ground too slow for speeds > 4
        if not self.object.is_on_ground or math.abs(self.object.target_pos.y - pos.y) > 0.1 then
            self.object.object:set_velocity({ x=0, y=y, z=0 })
        end
        return self:succeed()
    end

    if self.is_on_ground then
        local dir = vector.normalize(vector.direction({ x=pos.x, y=0, z=pos.z },
                                                    { x=self.object.target_pos.x, y=0, z=self.object.target_pos.z }))
        dir = vector.multiply(dir, self.max_speed * self.speed_factor)

        bt_mobs.turn2yaw(self.object, minetest.dir_to_yaw(dir))
        dir.y = y
        self.object.object:set_velocity(dir)
    end

    return self:running()
end

-- Object requirements
----------------------------------

-- target_pos - (vector) the position vector target to walk to


-- Properties
-----------------------------------

-- function bt_mobs.lq_dumbwalk(self,dest,speed_factor)
-- 	local timer = 3			-- failsafe
-- 	speed_factor = speed_factor or 1
-- 	local func=function(self)
-- 		bt_mobs.animate(self,'walk')
-- 		timer = timer - self.dtime
-- 		if timer < 0 then return true end
		
-- 		local pos = bt_mobs.get_stand_pos(self)
-- 		local y = self.object:get_velocity().y

-- 		if bt_mobs.is_there_yet2d(pos,minetest.yaw_to_dir(self.object:get_yaw()),dest) then
-- --		if bt_mobs.isnear2d(pos,dest,0.25) then
-- 			if not self.isonground or abs(dest.y-pos.y) > 0.1 then		-- prevent uncontrolled fall when velocity too high
-- --			if abs(dest.y-pos.y) > 0.1 then	-- isonground too slow for speeds > 4
-- 				self.object:set_velocity({x=0,y=y,z=0})
-- 			end
-- 			return true
-- 		end

-- 		if self.isonground then
-- 			local dir = vector.normalize(vector.direction({x=pos.x,y=0,z=pos.z},
-- 														{x=dest.x,y=0,z=dest.z}))
-- 			dir = vector.multiply(dir,self.max_speed*speed_factor)
-- --			self.object:set_yaw(minetest.dir_to_yaw(dir))
-- 			bt_mobs.turn2yaw(self,minetest.dir_to_yaw(dir))
-- 			dir.y = y
-- 			self.object:set_velocity(dir)
-- 		end
-- 	end
-- 	bt_mobs.queue_low(self,func)
-- end
