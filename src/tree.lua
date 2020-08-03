---
-- @module behaviors

--- Encapsulate the root @{node} of a behavior tree
-- @type tree
local tree = behaviors.class('tree')
behaviors.tree = tree

--behaviors.shared_blackboard = {}

--- Constructs a tree class instance
-- @tparam node root_node The root @{node} of the tree class instance
function tree:constructor(root_node)
    self.root_node = root_node
end

--- Sets the object that this tree will operate on where every @{node} will have access to it
-- @tab object The object that the behavior tree will operate on
function tree:set_object(object)
    self.root_node:set_object(object)
end

--- Sets an object that many tree instances can share
-- @tab object The shared object
function tree:set_shared_object(object)
    self.root_node:set_shared_object(object)
end

--- Runs one step of the tree starting with the root @{node} which runs it's children
-- until the entire tree is processed.
-- @param any Any parameters are passed down the tree of nodes to each call of the child nodes' run methods.
-- @return A string representing the enum @{behaviors.states} of "running", "success", or "failed".
function tree:run(...)
    assert(self.root_node.object ~= nil, "No object set on tree before calling run")
    return self.root_node:run(...)
end

--- Checks if the tree is finished processing it's nodes. For most cases the tree is
-- reset and run again once it finishes.
-- @treturn bool Whether the tree is finished running or not
function tree:is_finished()
    return self.root_node:get_state() ~= behaviors.states.RUNNING
end

--- Checks if the tree has been ran since initialization or the last time it was reset
-- @treturn bool Whether the tree has been started or not
function tree:is_started()
    return self.root_node.is_started
end

--- Resets the entire @{node} tree structure so it may be rerun
function tree:reset()
    self.root_node:reset()
end

