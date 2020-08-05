--- The dumb-step node inherits from the @{action} base node class and moves one minetest node 'step'
-- toward the target position.
-- @action dumb_step

local action = behaviors.action
local dumb_step = behaviors.class("dumb_step", action)
behaviors.dumb_step = dumb_step

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield string walk_animation The walking animation to apply to the mob while walking.
-- @tfield string jump_animation The jump animation to apply to the mob while jumping.
-- @tfield number speed_factor How fast the mob should walk.
-- @tfield number timeout How long should this node should attempt to walk toward the position before it gives up.

--- Required properties set on the node's set object
-- @table object
-- @tfield vector target_pos The position vector to walk to in the form {x,y,z} or an actual vector type.
-- @tfield number target_height The height of the jump operation.

--- Constructs a @{dumb_step} node class instance.
-- @tparam config config The configuration options for this @{dumb_step} node
function dumb_step:constructor(config)
    action.constructor(self)
    self.walk_animation = config.walk_animation or "walk"
    self.jump_animation = config.jump_animation
    self.speed_factor = config.speed_factor or 1
    self.jump = true
    self.timeout = config.timeout or 3
    self.timer = self.timeout   -- fail safe
end

--- Resets the @{dumb_step} node's state and stateful properties.
function dumb_step:reset()
    action.reset(self)
    self.timer = self.timeout
    self.jump = true
end

--- The main method that handles the processing for this @{dumb_step} node. This node will cause the mob to
-- take a one minetest node step towards the set target position vector jumping or walking as needed. The node
-- returns success after the jump or walk a step operation completes; otherwise, it returns running.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", or "success".
function dumb_step:on_step(...)

    if self.object.target_height <= 0.001 then

        -- do a dumb_walk operation
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

        if self.object.is_on_ground then
            local dir = vector.normalize(vector.direction({ x=pos.x, y=0, z=pos.z },
                                                { x=self.object.target_pos.x, y=0, z=self.object.target_pos.z }))
            dir = vector.multiply(dir, self.object.max_speed * self.speed_factor)

            bt_mobs.turn2yaw(self.object, minetest.dir_to_yaw(dir))
            dir.y = y
            self.object.object:set_velocity(dir)
        end
    else

        -- do a dumb_jump operation
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
    end
    return self:running()
end
