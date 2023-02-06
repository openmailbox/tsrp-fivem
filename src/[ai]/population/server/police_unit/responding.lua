Responding = {}

PoliceUnit.States[PoliceStates.RESPONDING] = Responding

function Responding:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Responding:enter()
end

function Responding:exit()
end

function Responding:update()
    if not self.assigned_call then
        self.unit:move_to(PoliceStates.AVAILABLE)
        return
    end

    if Dist2d(GetEntityCoords(self.entity), self.assigned_call.location) > 20.0 then
        return
    end

    if GetPedScriptTaskCommand(self.entity) == -2128726980 then
        local owner = NetworkGetEntityOwner(self.entity)

        TriggerClientEvent(Events.CREATE_POPULATION_PED_TASK, owner, {
            net_id   = NetworkGetNetworkIdFromEntity(self.entity),
            location = self.assigned_call.location
        })
    end
end
