Responding = {}

PoliceUnit.States[PoliceStates.RESPONDING] = Responding

function Responding:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Responding:enter()
    SetPedConfigFlag(self.unit.entity, 17, true)
end

function Responding:exit()
end

function Responding:update()
    if Dist2d(GetEntityCoords(self.unit.entity), self.unit.assigned_call.location) < 12.0 then
        self.unit:move_to(PoliceStates.SEARCHING)
        return
    end

    local vehicle = GetVehiclePedIsIn(self.unit.entity, false)

    if vehicle > 0 and GetPedInVehicleSeat(self.unit.entity, -1) == self.unit.entity then
        local owner = NetworkGetEntityOwner(self.unit.entity)

        TriggerClientEvent(Events.CREATE_POPULATION_TASK, owner, {
            net_id   = NetworkGetNetworkIdFromEntity(self.unit.entity),
            location = self.unit.assigned_call.location,
            task_id  = Tasks.DRIVE_TO_COORD
        })
    end
end
