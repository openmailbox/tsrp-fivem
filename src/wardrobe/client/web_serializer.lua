WebSerializer = {}

function WebSerializer:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

-- Serialize a ped into a format that can be used by the web UI.
function WebSerializer:serialize()
    return {
    }
end
