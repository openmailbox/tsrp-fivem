Searching = {}

PoliceUnit.States[PoliceStates.SEARCHING] = Searching

function Searching:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Searching:enter()
    local vehicle = GetVehiclePedIsIn(self.unit.entity, false)

    self.debounce = 0

    if vehicle > 0 then
        TaskLeaveVehicle(self.unit.entity, vehicle, 0)
    else
        self:update()
    end
end

function Searching:exit()
end

function Searching:update()
    if not self.unit.assigned_call then
        self.unit:move_to(PoliceStates.AVAILABLE)
        return
    end

    if GetGameTimer() > self.debounce and GetPedScriptTaskCommand(self.unit.entity) == Tasks.NO_TASK then
        self.debounce = GetGameTimer() + 2000

        local owner = NetworkGetEntityOwner(self.unit.entity)

        TriggerClientEvent(Events.CREATE_POPULATION_TASK, owner, {
            net_id   = NetworkGetNetworkIdFromEntity(self.unit.entity),
            location = self.unit.assigned_call.location,
            task_id  = Tasks.SEARCH_FOR_HATED_IN_AREA
        })
    end
end
