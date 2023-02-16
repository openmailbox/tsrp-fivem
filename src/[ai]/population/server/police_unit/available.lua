Available = {}

PoliceUnit.States[PoliceStates.AVAILABLE] = Available

function Available:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Available:enter()
    SetPedConfigFlag(self.unit.entity, 17, false)

    local owner = NetworkGetEntityOwner(self.unit.entity)

    TriggerClientEvent(Events.DELETE_POPULATION_TASK, owner, {
        net_id = NetworkGetNetworkIdFromEntity(self.unit.entity)
    })
end

function Available:exit()
end

function Available:update()
    local location = GetEntityCoords(self.unit.entity)

    -- TODO: Don't bother checking for calls unless we've moved more than some min distance
    if not self.unit.assigned_call and self.last_location ~= location then
        Dispatcher.available(self.unit)
        return
    end

    self.last_location = location
end
