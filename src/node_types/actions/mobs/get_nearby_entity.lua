--- The get_nearby_entity node inherits from the @{action} base node class and gets a nearby entity
-- within the mob's view range. If the entity is in range then set the target_entity property.
-- @action get_nearby_entity

local action = behaviors.action
local get_nearby_entity = behaviors.class("get_nearby_entity", action)
behaviors.get_nearby_entity = get_nearby_entity

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield string entity_name The name of the nearby entity to look for.
-- @tfield string range The view range to override or it defaults to the mod's view range.

--- Properties that get set on the node's object
-- @table object
-- @tfield vector target_entity The entity to target.

--- Constructs a @{get_nearby_entity} node class instance.
-- @tparam config config The configuration options for this @{get_nearby_entity} node
function get_nearby_entity:constructor(config)
    action.constructor(self)
    self.entity_name = config.entity_name
    self.range = config.range
end

--- The main method that handles the processing for this @{get_nearby_entity} node. This node try to find a named entity
-- within range. If the entity is in range then it sets the target_entity property on the node's set object and
-- this node succeeds. If an entity is not in range, then this node fails.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of success", or "failed".
function get_nearby_entity:on_step(...)
    local entity = bt_mobs.get_nearby_entity(self.object, self.entity_name)
    
    if entity then
        local pos = self.object.object:get_pos()
        local epos = entity:get_pos()
        local range = self.range or self.object.view_range

        if vector.distance(pos, epos) < range then
            self.object.target_entity = entity
            return self:succeed()
        end
    end
    return self:fail()
end
