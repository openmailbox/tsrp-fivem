Responding = {}

PoliceUnit.States[PoliceStates.RESPONDING] = Responding

-- Forward declarations
local is_driving,
      sync_task

function Responding:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Responding:enter()
    ClearPedTasks(self.unit.entity)

    SetPedConfigFlag(self.unit.entity, 17, true) -- BlockNonTemporaryEvents

    if is_driving(self.unit.entity) then
        sync_task(self)
    end
end

function Responding:exit()
end

function Responding:update()
    if not self.unit.assigned_call then
        self.unit:move_to(PoliceStates.AVAILABLE)
        return
    end

    if Dist2d(GetEntityCoords(self.unit.entity), self.unit.assigned_call.location) < 20.0 then
        self.unit:move_to(PoliceStates.SEARCHING)
        return
    end

    if is_driving(self.unit.entity) and GetPedScriptTaskCommand(self.unit.entity) == Tasks.NO_TASK then
        sync_task(self)
    end
end

-- @local
function is_driving(entity)
    local vehicle = GetVehiclePedIsIn(entity, false)
    return vehicle > 0 and GetPedInVehicleSeat(vehicle, -1) == entity
end

-- @local
function sync_task(response)
    local owner = NetworkGetEntityOwner(response.unit.entity)

    TriggerClientEvent(Events.CREATE_POPULATION_TASK, owner, {
        net_id   = NetworkGetNetworkIdFromEntity(response.unit.entity),
        location = response.unit.assigned_call.location,
        task_id  = Tasks.DRIVE_TO_COORD
    })
end
