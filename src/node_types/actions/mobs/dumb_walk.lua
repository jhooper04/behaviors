--- The dumb_walk node inherits from the @{action} base node class and applies a velocity toward a target position
-- and setting a walking animation. The action will either succeed on timeout or when the mob reaches
-- the target position.
-- @action dumb_walk

local action = behaviors.action
local dumb_walk = behaviors.class("dumb_walk", action)
behaviors.dumb_walk = dumb_walk

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield string walk_animation The walking animation to apply to the mob while walking.
-- @tfield number speed_factor How fast the mob should walk.
-- @tfield number timeout How long should this node should attempt to walk toward the position before it gives up.

--- Required properties set on the node's set object
-- @table object
-- @tfield vector target_pos The position vector to walk to in the form {x,y,z} or an actual vector type.

--- Constructs a @{dumb_walk} node class instance.
-- @tparam config config The configuration options for this @{dumb_walk} node
function dumb_walk:constructor(config)
    action.constructor(self)
    self.walk_animation = config.walk_animation or "walk"
    self.speed_factor = config.speed_factor or 1
    self.timeout = config.timeout or 3
    self.timer = self.timeout   -- fail safe
end

--- Resets the @{dumb_walk} node's state and stateful properties.
function dumb_walk:reset()
    action.reset(self)
    self.timer = self.timeout
end

--- The main method that handles the processing for this @{dumb_walk} node. This node will cause the mob to
-- walk towards the set target position vector without regard to any obstacles or height changes. returns success
-- when the mob reaches the target position or the operation times out.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", or "success".
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
