Available = {}

PoliceUnit.States[PoliceStates.AVAILABLE] = Available

function Available:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Available:enter()
end

function Available:exit()
end

function Available:update()
    local location = GetEntityCoords(self.unit.entity)

    if not self.unit.assigned_call and self.last_location ~= location then
        Dispatcher.available(self.unit)
        return
    end

    self.last_location = location
end
