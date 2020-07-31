
local condition = behaviors.condition
local compare = behaviors.class("compare", condition)
behaviors.compare = compare

function compare:constructor(config)
    condition.constructor(self)

    self.key = config.key
    self.data_type = config.data_type
    self.value = config.value
    self.predicate = config.predicate

    --self.expression = config.expression
    --local msg

    -- self.func,msg = loadstring("return "..self.expression)
    -- print(dump("msg"))
    -- if not self.func then print(" ") error("Compare node expression invalid: "..msg) end
    --print("here3")

    -- local f = function(s)
    --     --print("here1")
    --     s.func,msg = loadstring("return "..self.expression)
    --     --print("here2")
    --     if not s.func then error("Compare node expression invalid: "..msg) end
    --     --print("here3")
    -- end
    -- local status, ret = pcall(f, self)
    -- if not status then assert(false, "Compare node expression failed: "..ret) end
end

-- function compare:set_object(object)
--     condition.set_object(self, object)
--     if self.func then
--         setfenv(self.func, object)
--     end
-- end

function compare:get_value()
    if self.value:sub(1, 1) == "$" then
        return self.object[self.value:sub(2)]
    end
    if self.data_type == "string" then
        return tostring(self.value)
    elseif self.data_type == "number" then
        return tonumber(self.value)
    end
end

function compare:check_condition(...)

    if self.predicate == "~=" then
        return self.object[self.key] ~= self:get_value()
    elseif self.predicate == "==" then
        return self.object[self.key] == self:get_value()
    elseif self.predicate == ">=" then
        return self.object[self.key] >= self:get_value()
    elseif self.predicate == "<=" then
        return self.object[self.key] <= self:get_value()
    elseif self.predicate == ">" then
        return self.object[self.key] > self:get_value()
    elseif self.predicate == "<" then
        return self.object[self.key] < self:get_value()
    end

    -- if self.func then
    --     local status, ret = pcall(self.func,...)
    --     if not status then error("Compare node expression failed: "..ret) end
    --     return ret
    -- else
    --     error("Compare node expression invalid")
    -- end
end

-- Properties
-----------------------------------

-- expression - (string) expression string to evaluate



