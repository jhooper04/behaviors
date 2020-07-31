
local action = behaviors.action
local turn_to_pos = behaviors.class("turn_to_pos", action)
behaviors.turn_to_pos = turn_to_pos

function turn_to_pos:constructor(config)
    action.constructor(self)
end

function turn_to_pos:on_step(...)
    local pos = self.object.object:get_pos()

	if bt_mobs.turn2yaw(self,
            minetest.dir_to_yaw(vector.direction(pos,self.object.target_pos))) then
        return self:succeed()
    else
        return self:running()
    end
end

-- Object requirements
----------------------------------

-- target_pos - (vector) position for the entity to turn to


-- Properties
-----------------------------------


-- function mobkit.lq_turn2pos(self,tpos)
-- 	local func=function(self)
-- 		local pos = self.object:get_pos()
-- 		return mobkit.turn2yaw(self,
-- 			minetest.dir_to_yaw(vector.direction(pos,tpos)))
-- 	end
-- 	mobkit.queue_low(self,func)
-- end