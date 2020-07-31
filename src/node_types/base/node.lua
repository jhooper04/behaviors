

-- local function readonly_table(tbl)
--     return setmetatable({}, {
--       __index = tbl,
--       __newindex = function(table, key, value)
--                      error("Attempt to modify read-only table")
--                    end,
--       __metatable = false
--     });
--  end

local states = setmetatable({
    RUNNING = "running",
    FAILED = "failed",
    SUCCESS = "success",
}, {
    __index = function(_, key)
        error("Invalid behaviour state: " .. key)
    end,
    __newindex = function()
        error("Attempt to assign to immutable enum 'states'")
    end,
    __metatable = false,
})
behaviors.states = states

local node = behaviors.class("node", nil, true)
behaviors.node = node

function node:constructor()
    self.state = states.RUNNING
    self.is_started = false
end

function node:run(...)
    if not self.is_started then
        if self.on_start then self:on_start() end
        self.is_started = true
    end
    return self:on_step(...)
end

function node:get_state()
    return self.state
end

function node:set_object(object)
	self.object = object
end

function node:set_shared_object(object)
	self.shared_object = object
end

function node:is_running()
    return self.state == states.RUNNING
end

function node:has_succeeded()
    return self.state == states.SUCCESS
end

function node:has_failed()
    return self.state == states.FAILED
end

function node:running()
    self.state = states.RUNNING
    return self.state
end

function node:succeed()
    self.state = states.SUCCESS
    if self.on_finish then self:on_finish() end
    return self.state
end

function node:fail()
    self.state = states.FAILED
    if self.on_finish then self:on_finish() end
    return self.state
end

function node:reset()
    self.state = states.RUNNING
    self.is_started = false
end

function node:on_step() end

--abstract methods to override
-----------------------------------

--function condition:on_start(...) --returns nil (optional)
--function condition:on_step(...) --returns state enum
--function condition:on_finish(...) --returns nil (optional)

--function node:on_step() return self:fail() end
