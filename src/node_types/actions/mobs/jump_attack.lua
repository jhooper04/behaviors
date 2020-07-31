
local action = behaviors.action
local jump_attack = behaviors.class("jump_attack", action)
behaviors.jump_attack = jump_attack

function jump_attack:constructor(config)
    action.constructor(self)
    self.idle_animation = config.idle_animation
    self.charge_animation = config.charge_animation
    self.charge_sound = config.charge_sound
    self.attack_animation = config.attack_animation
    self.attack_sound = config.attack_sound
    self.phase = 1
    --self.timer = 0.5
    self.idle_time = 0.3
    self.idle_first_run = true
end

function jump_attack:reset()
    action.reset(self)
    self.phase = 1
    --self.timer = 0.5
    self.idle_time = 0.3
    self.idle_first_run = true
end

function jump_attack:on_start()
    self.target_box = self.object.target_entity.object:get_properties().collisionbox
end

function jump_attack:on_step(...)

    if not bt_mobs.is_alive(self.object.target_entity) then return self:succeed() end

    if self.object.is_on_ground then
        if self.phase == 1 then	-- collision bug workaround
            local vel = self.object.object:get_velocity()
            vel.y = -bt_mobs.gravity * math.sqrt(self.object.target_height * 2 / -bt_mobs.gravity)
            self.object.object:set_velocity(vel)
            bt_mobs.make_sound(self,'charge')
            self.phase=2
        else
            if self.idle_animation and self.idle_first_run then
                bt_mobs.animate(self.object, self.idle_animation)
                self.idle_first_run = false
            end
        
            self.idle_time = self.idle_time-self.object.dtime
        
            if self.idle_time <= 0 then
                return self:succeed()
            end
            return self:running()
        end
    elseif self.phase == 2 then
        local dir = minetest.yaw_to_dir(self.object.object:get_yaw())
        local vy = self.object.object:get_velocity().y
        dir=vector.multiply(dir,6)
        dir.y=vy
        self.object.object:set_velocity(dir)
        self.phase = 3
    elseif self.phase == 3 then	-- in air
        local tgtpos = self.object.target_entity.object:get_pos()
        local pos = self.object.object:get_pos()
        -- calculate attack spot
        local yaw = self.object:get_yaw()
        local dir = minetest.yaw_to_dir(yaw)
        local apos = bt_mobs.pos_translate2d(pos, yaw, self.object.attack.range)

        if bt_mobs.is_pos_in_box(apos, tgtpos, self.target_box) then	--bite
            self.object.target_entity.object:punch(self.object.object, 1, self.object.attack)
                -- bounce off
            local vy = self.object.object:get_velocity().y
            self.object.object:set_velocity({ x=dir.x * -3, y=vy, z=dir.z * -3})
                -- play attack sound if defined
            bt_mobs.make_sound(self.object,'attack')
            self.phase = 4
        end
    end
    return self:running()
end

-- Object requirements
----------------------------------

-- target_entity - (table) the lua entity table of the target to attack
-- target_height - (number) the height target of the jump attack

-- Properties
-----------------------------------

-- idle_animation - (string) animation to show while idle
-- charge_animation - (string) animation to show when beginning attack
-- charge_sound - (string) sound to play when beginning attack
-- attack_animation - (string) animation to play during attack
-- attack_sound - (string) sound to play during attack


-- function mobkit.lq_jumpattack(self,height,target)
-- 	local phase=1
-- 	local timer=0.5
-- 	local tgtbox = target:get_properties().collisionbox
-- 	local func=function(self)
-- 		if not mobkit.is_alive(target) then return true end
-- 		if self.isonground then
-- 			if phase==1 then	-- collision bug workaround
-- 				local vel = self.object:get_velocity()
-- 				vel.y = -mobkit.gravity*sqrt(height*2/-mobkit.gravity)
-- 				self.object:set_velocity(vel)
-- 				mobkit.make_sound(self,'charge')
-- 				phase=2
-- 			else
-- 				mobkit.lq_idle(self,0.3)
-- 				return true
-- 			end
-- 		elseif phase==2 then
-- 			local dir = minetest.yaw_to_dir(self.object:get_yaw())
-- 			local vy = self.object:get_velocity().y
-- 			dir=vector.multiply(dir,6)
-- 			dir.y=vy
-- 			self.object:set_velocity(dir)
-- 			phase=3
-- 		elseif phase==3 then	-- in air
-- 			local tgtpos = target:get_pos()
-- 			local pos = self.object:get_pos()
-- 			-- calculate attack spot
-- 			local yaw = self.object:get_yaw()
-- 			local dir = minetest.yaw_to_dir(yaw)
-- 			local apos = mobkit.pos_translate2d(pos,yaw,self.attack.range)

-- 			if mobkit.is_pos_in_box(apos,tgtpos,tgtbox) then	--bite
-- 				target:punch(self.object,1,self.attack)
-- 					-- bounce off
-- 				local vy = self.object:get_velocity().y
-- 				self.object:set_velocity({x=dir.x*-3,y=vy,z=dir.z*-3})
-- 					-- play attack sound if defined
-- 				mobkit.make_sound(self,'attack')
-- 				phase=4
-- 			end
-- 		end
-- 	end
-- 	mobkit.queue_low(self,func)
-- end