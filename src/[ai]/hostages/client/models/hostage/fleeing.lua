Fleeing = {}

Hostage.States[HostageStates.FLEEING] = Fleeing

function Fleeing:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Fleeing:enter()
    SetEntityAsNoLongerNeeded(self.hostage.entity)
    TaskReactAndFleePed(self.hostage.entity, PlayerPedId())
end

function Fleeing:update()
end
