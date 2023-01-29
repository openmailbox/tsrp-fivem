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

function Fleeing:exit()
end

function Fleeing:update()
    if not GetIsTaskActive(self.hostage.entity, 445) and not GetIsTaskActive(self.hostage.entity, 221) then
        -- TODO: We may maintain a reference to the hostage indefinitely server-side if the player goes out of scope.
        -- This would give us a "hostage pool" we might do something interesting with.
        TaskWanderStandard(self.hostage.entity, 10.0, 10)
        SetCurrentPedWeapon(self.hostage.entity, Weapons.UNARMED, true)
    end
end
