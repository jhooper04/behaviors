local path = minetest.get_modpath("behaviors")

behaviors = {}

dofile(path .. "/src/registry.lua")
dofile(path .. "/src/builder.lua")
dofile(path .. "/src/class.lua")
dofile(path .. "/src/enums.lua")
dofile(path .. "/src/tree.lua")

bt_mobs = {}
dofile(path .. "/src/mobs.lua")

local node_types = {
    "base/node",
    "base/action",
    "base/composite",
    "base/condition",
    "base/decorator",
    "base/precondition",

    "actions/execute",
    "actions/execute_shared",
    "actions/set_shared_value",
    "actions/set_value",
    "actions/subtree",

    "actions/mobs/dumb_jump",
    "actions/mobs/dumb_step",
    "actions/mobs/dumb_walk",
    "actions/mobs/fall_over",
    "actions/mobs/free_jump",
    "actions/mobs/idle",
    "actions/mobs/jump_attack",
    "actions/mobs/jump_out",
    "actions/mobs/turn_to_pos",
    "actions/mobs/get_nearby_entity",
    "actions/mobs/get_nearby_player",
    "actions/mobs/get_random_pos",
    "actions/mobs/get_target_pos",

    "composites/parallel",
    "composites/selector",
    "composites/sequence",
    
    "conditions/compare",
    "conditions/has_shared_value",
    "conditions/has_value",
    "conditions/random",

    "decorators/failure",
    "decorators/inverter",
    "decorators/repeater",
    "decorators/success",
    "decorators/until_failure",
    "decorators/until_success",
}
for _,v in ipairs(node_types) do
    dofile(path .. "/src/node_types/" .. v .. ".lua")
end

