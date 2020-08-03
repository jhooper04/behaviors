---Compare nodes inherit from the @{condition} base node class and will check a property of the node's set object.
-- It is essentially a node that represents an if statement that will either succeed or fail if the
-- configured expression is true or false.
-- @condition compare

local condition = behaviors.condition
local compare = behaviors.class("compare", condition)
behaviors.compare = compare

--- Configuration table passed into the constructor function.
-- @table config
-- @tfield string key The key on the node's associated set object to read for comparison.
-- @tfield string data_type The data type of the keyed property and value. Currently supports 'bool','string','number'.
-- @tfield string value The value to compare with the keyed property. if starts with '$' then value is another key.
-- @tfield string predicate The comparison operator. Can be '~=','==','>=','<=','>', or '<'

--- Constructs a @{compare} node class instance.
-- @tparam config config The configuration options for this @{compare} node
function compare:constructor(config)
    condition.constructor(self)

    self.key = config.key
    self.data_type = config.data_type
    self.value = config.value
    self.predicate = config.predicate
end

--- Gets the configured value on the node's object and converts the data type.
-- @treturn string|number|bool value to be used in the comparison check condition.
function compare:get_value()
    if self.value:sub(1, 1) == "$" then
        return self.object[self.value:sub(2)]
    end
    if self.data_type == "string" then
        return tostring(self.value)
    elseif self.data_type == "number" then
        return tonumber(self.value)
    elseif self.data_type == "bool" then
        return not not self.value
    end
end

--- The main method that handles the conditional comparison checking for this @{compare} node.
-- @param ... Any parameters passed to the node's run method
-- @treturn bool True if the comparison succeeded or false if the comparison failed.
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
end
