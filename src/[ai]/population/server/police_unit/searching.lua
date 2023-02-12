Searching = {}

PoliceUnit.States[PoliceStates.SEARCHING] = Searching

function Searching:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Searching:enter()
    self:update()
end

function Searching:exit()
end

function Searching:update()
    if GetPedScriptTaskCommand(self.unit.entity) == Tasks.NO_TASK then
        local owner = NetworkGetEntityOwner(self.unit.entity)

        TriggerClientEvent(Events.CREATE_POPULATION_TASK, owner, {
            net_id   = NetworkGetNetworkIdFromEntity(self.unit.entity),
            location = self.unit.assigned_call.location,
            task_id  = Tasks.SEARCH_FOR_HATED_IN_AREA
        })
    end
end
