--- The turn-to-pos node inherits from the @{action} base node class and will turn the mob incrementally toward
-- the target position on each run of the node and returns success when the mob is facing the target position.
-- @action turn_to_pos

local action = behaviors.action
local turn_to_pos = behaviors.class("turn_to_pos", action)
behaviors.turn_to_pos = turn_to_pos

--- Required properties set on the node's set object
-- @table object
-- @tfield vector target_pos The vector position the mob should turn to face.

--- Constructs a @{turn_to_pos} node class instance.
-- @tparam config config The configuration options for this @{turn_to_pos} node (currently no config options).
function turn_to_pos:constructor(config)
    action.constructor(self)
end

--- The main method that handles the processing for this @{turn_to_pos} node. This node will cause the mob to
-- gradually turn to face the target position and succeeds when completely facing the position.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of "running", or "success".
function turn_to_pos:on_step(...)
    local pos = self.object.object:get_pos()

	if bt_mobs.turn2yaw(self,
            minetest.dir_to_yaw(vector.direction(pos,self.object.target_pos))) then
        return self:succeed()
    else
        return self:running()
    end
end



-- function mobkit.lq_turn2pos(self,tpos)
-- 	local func=function(self)
-- 		local pos = self.object:get_pos()
-- 		return mobkit.turn2yaw(self,
-- 			minetest.dir_to_yaw(vector.direction(pos,tpos)))
-- 	end
-- 	mobkit.queue_low(self,func)
-- end