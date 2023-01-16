Spawn = {}

function Spawn:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Spawn:update()
end
