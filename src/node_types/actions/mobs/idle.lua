
local action = behaviors.action
local idle = behaviors.class("idle", action)
behaviors.idle = idle

function idle:constructor(config)
    action.constructor(self)
    self.duration = config.duration
    self.animation = config.animation
    self.time = self.duration
    self.first_run = true
end

function idle:reset()
    action.reset(self)
    self.time = self.duration
    self.first_run = true
end

function idle:on_step(...)
    
    if self.animation and self.first_run then
        bt_mobs.animate(self.object, self.animation)
        self.first_run = false
    end

    self.time = self.time-self.object.dtime

    if self.time <= 0 then
        return self:succeed()
    end
    return self:running()
end

-- Object requirements
----------------------------------

-- dtime - (number) entity step delta time

-- Properties
-----------------------------------

-- duration - (number) amount of time to remain idle


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