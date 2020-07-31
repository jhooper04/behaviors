
-- class.lua
-- Compatible with Lua 5.1 (not 5.0).
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




-- local Object = {}
-- Object.__index = Object
-- function Object:new(...)
-- 	local obj = {}
-- 	setmetatable(obj, self)

-- 	obj:constructor(...)

-- 	return obj
-- end

-- function Object:constructor()
-- end

-- function behaviors.class(name, parent, is_abstract)
-- 	parent = parent or Object
-- 	assert(type(parent) == "table" and parent.new)

-- 	local class_object = {
-- 		type = name,
-- 		constructor = function(self, ...)
-- 			assert(#({...}) == 0, "Default constructor accepts no arguments. Define a constructor.")
-- 			parent.constructor(self)
-- 		end
-- 	}
-- 	class_object.__index = class_object

--     setmetatable(class_object, parent)
	
-- 	if not is_abstract then
-- 		register(name, class_object)
-- 	end

-- 	return class_object
-- end