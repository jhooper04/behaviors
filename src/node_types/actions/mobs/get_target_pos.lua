--- The get_target_pos node inherits from the @{action} base node class and gets the target pos of the currently
-- targeted entity.
-- @action get_target_pos

local action = behaviors.action
local get_target_pos = behaviors.class("get_target_pos", action)
behaviors.get_target_pos = get_target_pos

--- Properties that get set on the node's object
-- @table object
-- @tfield vector target_pos The target position that will be updated.
-- @tfield userdata target_entity The targeted entity to get the current position from.

--- Constructs a @{get_target_pos} node class instance.
-- @tparam config config The configuration options for this @{get_target_pos} node
function get_target_pos:constructor(config)
    action.constructor(self)
end

--- The main method that handles the processing for this @{get_target_pos} node. This node will set the target
-- position property on the object from the target entity's current position.
-- @param ... Any parameters passed to the node's run method
-- @return A string representing the enum @{behaviors.states} of success", or "failed".
function get_target_pos:on_step(...)

    self.object.target_pos = self.object.target_entity:get_pos()
    return self:succeed()
end
