---
-- @module behaviors

--- class utility for creating object oriented inheritance hierarchies of tree nodes
-- @string name The name of the new class to create
-- @tab[opt] base The Base class of the new class to inherit from
-- @bool[opt] is_abstract Defines whether or not this class should be directly used as a node type in a behavior tree
-- @treturn tab New class type
function behaviors.class(name, base, is_abstract)
    local c = {}    -- a new class instance
    if type(base) == 'table' then
        -- our new class is a shallow copy of the base class!
        for i,v in pairs(base) do
            c[i] = v
        end
        c._base = base
    end
    -- the class will be the metatable for all its objects,
    -- and they will look up their methods in it.
    c.__index = c

    -- expose a constructor which can be called by <classname>(<args>)
    local mt = {}
    mt.__call = function(class_tbl, ...)
        local obj = {}
        setmetatable(obj,c)
        if class_tbl.constructor then
            class_tbl.constructor(obj,...)
        else
            -- make sure that any stuff from the base class is initialized!
            if base and base.constructor then
                base.constructor(obj, ...)
            end
        end
        return obj
    end
    --c.init = init
    c.is_a = function(self, klass)
       local m = getmetatable(self)
       while m do
          if m == klass then return true end
          m = m._base
       end
       return false
    end
	setmetatable(c, mt)
	
	if not is_abstract then
		behaviors.register_node(name, c)
	end

    return c
end
