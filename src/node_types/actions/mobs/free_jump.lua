--- The free-jump node inherits from the @{action} base node class and applies a vertical jump velocity
-- to the mob and succeeds when the mob's vertical velocity returns to 0 implying it has landed.
-- @action free_jump

local action = behaviors.action
local free_jump = behaviors.class("free_jump", action)
behaviors.free_jump = free_jump

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield string jump_animation The animation to apply to the mob while jumping.
-- @tfield number jump_velocity The height of the mob's jump operation.

--- Constructs a @{free_jump} node class instance.
-- @tparam config config The configuration options for this @{free_jump} node
function free_jump:constructor(config)
    action.constructor(self)
    self.jump_animation = config.jump_animation
    self.jump_velocity = config.jump_velocity
    self.phase = 1
end

--- Resets the @{free_jump} node's state and stateful properties.
function free_jump:reset()
    action.reset(self)
    self.phase = 1
end

--- Called when the node first runs to set initial values, animations, and play the fall sound (if configured).
-- @function on_start
-- @param any Any parameters passed to parent node's run call
function free_jump:on_start()
    if self.jump_animation then
        bt_mobs.animate(self.object, self.jump_animation)
    end
end

--- The main method that handles the processing for this @{free_jump} node. This node will cause the mob to
-- jump in the direction it is currently facing with a configurable jump y velocity. This node succeeds when
-- the mobs returns to the ground.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", or "success".
function free_jump:on_step(...)
    local vel=self.object.object:get_velocity()
    if self.phase == 1 then
        vel.y = vel.y + self.jump_velocity
        self.object.object:set_velocity(vel)
        self.phase = 2
    else
        if vel.y <= 0.01 then return self:succeed() end
        local dir = minetest.yaw_to_dir(self.object.object:get_yaw())
        dir.y=vel.y
        self.object.object:set_velocity(dir)
    end
    return self:running()
end



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