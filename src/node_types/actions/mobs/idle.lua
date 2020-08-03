--- The idle node inherits from the @{action} base node class and plays a configurable animation for a specified
-- amount of time. It succeeds when the duration time has elapsed.
-- @action idle

local action = behaviors.action
local idle = behaviors.class("idle", action)
behaviors.idle = idle

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield number duration The amount of time to remain idle.
-- @tfield string idle_animation The animation to play while the mob is idle.

--- Constructs a @{idle} node class instance.
-- @tparam config config The configuration options for this @{idle} node
function idle:constructor(config)
    action.constructor(self)
    self.duration = config.duration
    self.idle_animation = config.idle_animation or "stand"
    self.time = self.duration
end

--- Resets the @{idle} node's state and stateful properties.
function idle:reset()
    action.reset(self)
    self.time = self.duration
end

--- Called when the node first runs to set initial values, and idle animation.
-- @function on_start
-- @param any Any parameters passed to parent node's run call
function idle:on_start()
    if self.idle_animation then
        bt_mobs.animate(self.object, self.idle_animation)
    end
end

--- The main method that handles the processing for this @{idle} node. This node will cause the mob to
-- set an idle animation and simply wait for the idle duration amount of time and then succeeds.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", or "success".
function idle:on_step(...)
    
    self.time = self.time-self.object.dtime

    if self.time <= 0 then
        return self:succeed()
    end
    return self:running()
end



-- function mobkit.lq_idle(self,duration,anim)
-- 	anim = anim or 'stand'
-- 	local init = true
-- 	local func=function(self)
-- 		if init then
-- 			mobkit.animate(self,anim)
-- 			init=false
-- 		end
-- 		duration = duration-self.dtime
-- 		if duration <= 0 then return true end
-- 	end
-- 	mobkit.queue_low(self,func)
-- end