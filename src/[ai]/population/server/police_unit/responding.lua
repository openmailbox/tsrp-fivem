Responding = {}

PoliceUnit.States[PoliceStates.RESPONDING] = Responding

-- Forward declarations
local find_best_destination,
      is_driving,
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

    self.unit.vehicle = GetVehiclePedIsIn(self.unit.entity, false)

    if is_driving(self.unit.entity) then
        self.unit.vehicle_driver = true
        sync_task(self, find_best_destination(self))
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

    if not is_driving(self.unit.entity) then return end

    local location = find_best_destination(self)

    if location ~= self.last_location or GetPedScriptTaskCommand(self.unit.entity) == Tasks.NO_TASK then
        sync_task(self, location)
    end
end

-- @local
function find_best_destination(state)
    if state.unit.current_target then
        return GetEntityCoords(state.unit.current_target)
    else
        return state.unit.assigned_call.location
    end
end

-- @local
function is_driving(entity)
    local vehicle = GetVehiclePedIsIn(entity, false)
    return vehicle > 0 and GetPedInVehicleSeat(vehicle, -1) == entity
end

-- @local
function sync_task(state, location)
    local owner = NetworkGetEntityOwner(state.unit.entity)

    TriggerClientEvent(Events.CREATE_POPULATION_TASK, owner, {
        net_id   = NetworkGetNetworkIdFromEntity(state.unit.entity),
        location = location,
        task_id  = Tasks.DRIVE_TO_COORD
    })

    state.last_location = location
end
