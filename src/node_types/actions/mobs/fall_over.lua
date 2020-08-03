--- The fall-over node inherits from the @{action} base node class and rotates the mob on it's side while
-- optionally playing a fall sound and animation. Typically used to represent death of the mob.
-- @action fall_over

local action = behaviors.action
local fall_over = behaviors.class("fall_over", action)
behaviors.fall_over = fall_over

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield string fall_animation The fall animation to apply to the mob while falling over.
-- @tfield string fall_sound The sound to play when the falling over operation begins.

--- Constructs a @{fall_over} node class instance.
-- @tparam config config The configuration options for this @{fall_over} node
function fall_over:constructor(config)
    action.constructor(self)
    self.fall_animation = config.fall_animation or "stand"
    self.fall_sound = config.fall_sound
    self.z_rot = 0
end

--- Resets the @{fall_over} node's state and stateful properties.
function fall_over:reset()
    action.reset(self)
    self.z_rot = 0
end

--- Called when the node first runs to set initial values, animations, and play the fall sound (if configured).
-- @function on_start
-- @param any Any parameters passed to parent node's run call
function fall_over:on_start()
    local vel = self.object.object:get_velocity()
    self.object.object:set_velocity(bt_mobs.pos_shift(vel,{y=1}))
    bt_mobs.animate(self.object, self.fall_animation)
    if self.fall_sound then
        bt_mobs.make_sound(self.object, self.fall_sound)
    end
end

--- The main method that handles the processing for this @{fall_over} node. This node will cause the mob to
-- fall over on its side and succeeds when fully on its side.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", or "success".
function fall_over:on_step(...)

    self.z_rot = self.z_rot + math.pi * 0.05
    local rot = self.object.object:get_rotation()
    self.object.object:set_rotation({ x=rot.x, y=rot.y, z=self.z_rot })

    if self.z_rot >= math.pi * 0.5 then
        return self:succeed()
    end

    return self:running()
end

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