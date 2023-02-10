Searching = {}

PoliceUnit.States[PoliceStates.SEARCHING] = Searching

function Searching:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Searching:enter()
end

function Searching:exit()
end

function Searching:update()
    if GetPedScriptTaskCommand(self.unit.entity) == -2128726980 then
        local owner = NetworkGetEntityOwner(self.unit.entity)

        TriggerClientEvent(Events.CREATE_POPULATION_TASK_SEARCH_HATED, owner, {
            net_id   = NetworkGetNetworkIdFromEntity(self.unit.entity),
            location = self.unit.assigned_call.location,
        })
    end
end
