--- The get_random_pos node inherits from the @{action} base node class and gets a random target position
-- one minetest node away.
-- @action get_random_pos

local action = behaviors.action
local get_random_pos = behaviors.class("get_random_pos", action)
behaviors.get_random_pos = get_random_pos

--- Properties that get set on the node's object
-- @table object
-- @tfield vector target_pos The random target position.
-- @tfield number target_height The terrain height change of the target_pos from the mob's current pos.

--- Constructs a @{get_random_pos} node class instance.
-- @tparam config config The configuration options for this @{get_random_pos} node
function get_random_pos:constructor(config)
    action.constructor(self)
    --print("get_random_pos")
end

--- The main method that handles the processing for this @{get_random_pos} node. This node attempt to get
-- a random position one minetest node away in any direction.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of success", or "failed".
function get_random_pos:on_step(...)
    --print(dump(self.object.is_on_ground))
    if self.object.is_on_ground then
        local neighbor = math.random(8)
        local height, tpos, is_liquid = bt_mobs.is_neighbor_node_reachable(self.object, neighbor)
        if height and not is_liquid then
            self.object.target_height = height
            self.object.target_pos = tpos
            --print("target pos: "..dump(self.object.target_pos))
            return self:succeed()
        end
    end
    return self:fail()
end
