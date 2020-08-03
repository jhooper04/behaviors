--luacheck:ignore
-- ldoc configuration file
file = {
    "../src/node_types/base",
    "../src/node_types/composites",
    "../src/node_types/conditions",
    "../src/node_types/decorators",
    "../src/node_types/actions",
    "../src/enums.lua",
    "../src/class.lua",
    "../src/builder.lua",
    "../src/mobs.lua",
    "../src/registry.lua",
    "../src/tree.lua"
}
dir = "html"
title = "Behaviors API Documentation"
description = [[
Behavior tree system API mod for Minetest for easy, flexible, and complex mob AI or generic uses beyond mobs. 
]]
project = "Behaviors API"
--examples = {"examples"}
topics = {"guides"}
merge = true
format = 'markdown'
template = '.'
use_markdown_titles = true
not_luadoc = true
no_lua_ref = true
sort_modules = true
kind_names = { topic='Guides' }
custom_tags = { { 'abstract', hidden = true }, { "inherits", hidden=true } } -- , { 'base', hidden = true}
custom_display_name_handler = function(item, default_handler)
    if item.type == 'function' and item.tags.abstract then
        if item.tags.abstract then
            return item.name .. ' [abstract]'
        --elseif item.tags.base then
        --    return 
        end
    end
    -- if item.type == "base" then
    --     if item.tags.inherits then
    --         return item.name .. ' inherits from '..item.tags.inherits[1]
    --     end
    --     --print(item.tags.inherits)
    -- end
    --print(item.name)
    return default_handler(item)
end
new_type("base", "Base", true)
new_type("action", "Actions", true)
new_type("composite", "Composites", true)
new_type("condition", "Conditions", true)
new_type("decorator", "Decorators", true)