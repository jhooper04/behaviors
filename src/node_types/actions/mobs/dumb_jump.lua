--- The dumb_jump node inherits from the @{action} base node class and performs a simple jump behavior for a mob
-- by applying a jump velocity in the direction it is facing and succeeds when the mob then contacts the ground again.
-- @action dumb_jump

local action = behaviors.action
local dumb_jump = behaviors.class("dumb_jump", action)
behaviors.dumb_jump = dumb_jump

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield string jump_animation The jump animation to apply to the mob while jumping.

--- Required properties set on the node's set object
-- @table object
-- @tfield number target_height The height of the jump operation.

--- Constructs a @{dumb_jump} node class instance.
-- @tparam config config The configuration options for this @{dumb_jump} node
function dumb_jump:constructor(config)
    action.constructor(self)
    self.jump_animation = config.jump_animation
    self.jump = true
end

--- Resets the @{dumb_jump} node's state and stateful properties.
function dumb_jump:reset()
    action.reset(self)
    self.jump = true
end

--- The main method that handles the processing for this @{dumb_jump} node. This node will cause the mob to
-- jump in the direction it is currently facing and succeeds when it touches back on the ground.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", or "success".
function dumb_jump:on_step(...)
    local yaw = self.object.object:get_yaw()
    if self.object.is_on_ground then
        if self.jump then
            bt_mobs.animate(self, self.jump_animation)
            local dir = minetest.yaw_to_dir(yaw)
            dir.y = -bt_mobs.gravity * math.sqrt( (self.object.target_height + 0.35) * 2 / - bt_mobs.gravity)
            self.object.object:set_velocity(dir)
            self.jump = false
        else				-- the eagle has landed
            return self:succeed()
        end
    else
        local dir = minetest.yaw_to_dir(yaw)
        local vel = self.object.object:get_velocity()
        if self.object.last_velocity.y < 0.9 then
            dir = vector.multiply(dir,3)
        end
        dir.y = vel.y
        self.object.object:set_velocity(dir)
    end

    return self:running()
end

-- Object requirements
----------------------------------

-- target_height - (number) the height target of the jump attack




-- -- initial velocity for jump height h, v= a*sqrt(h*2/a) ,add 20%
-- function mobkit.lq_dumbjump(self,height,anim)
-- 	anim = anim or 'stand'
-- 	local jump = true
-- 	local func=function(self)
-- 	    local yaw = self.object:get_yaw()
-- 		if self.isonground then
-- 			if jump then
-- 				mobkit.animate(self,anim)
-- 				local dir = minetest.yaw_to_dir(yaw)
-- 				dir.y = -mobkit.gravity*sqrt((height+0.35)*2/-mobkit.gravity)
-- 				self.object:set_velocity(dir)
-- 				jump = false
-- 			else				-- the eagle has landed
-- 				return true
-- 			end
-- 		else
-- 			local dir = minetest.yaw_to_dir(yaw)
-- 			local vel = self.object:get_velocity()
-- 			if self.lastvelocity.y < 0.9 then
-- 				dir = vector.multiply(dir,3)
-- 			end
-- 			dir.y = vel.y
-- 			self.object:set_velocity(dir)
-- 		end
-- 	end
-- 	mobkit.queue_low(self,func)
-- end