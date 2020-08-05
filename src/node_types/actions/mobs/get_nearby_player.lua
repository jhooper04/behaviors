--- The get_nearby_player node inherits from the @{action} base node class and gets a nearby player
-- within the mob's view range. If the player is in range then set the target_entity property.
-- @action get_nearby_player

local action = behaviors.action
local get_nearby_player = behaviors.class("get_nearby_player", action)
behaviors.get_nearby_player = get_nearby_player

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield string range The view range to override or it defaults to the mod's view range.

--- Properties that get set on the node's object
-- @table object
-- @tfield vector target_entity Player entity to target.

--- Constructs a @{get_nearby_player} node class instance.
-- @tparam config config The configuration options for this @{get_nearby_player} node
function get_nearby_player:constructor(config)
    action.constructor(self)
    self.range = config.range
end

--- The main method that handles the processing for this @{get_nearby_player} node. This node try to find a player
-- within range. If the player is in range then it sets the target_entity property on the node's set object and
-- this node succeeds. If a player is not in range, then this node fails.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of success", or "failed".
function get_nearby_player:on_step(...)
    local player = bt_mobs.get_nearby_player(self.object)
    
    if player then
        local pos = self.object.object:get_pos()
        local ppos = player:get_pos()
        local range = self.range or self.object.view_range

        if vector.distance(pos, ppos) < range then
            self.object.target_entity = player
            return self:succeed()
        end
    end
    return self:fail()
end
