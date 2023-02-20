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
    SetPedConfigFlag(self.unit.entity, 17, true) -- BlockNonTemporaryEvents
    ClearPedTasks(self.unit.entity)

    self.unit.vehicle      = GetVehiclePedIsIn(self.unit.entity, false)
    self.unit.vehicle_type = GetVehicleType(self.unit.vehicle)

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

    local location       = find_best_destination(self)
    local target_vehicle = GetVehiclePedIsIn(self.unit.current_target, false)
    local max_distance   = (self.unit.vehicle_type == "heli" and 50.0) or 20.0

    if self.unit.current_target and target_vehicle > 0 then
        self.unit:move_to(PoliceStates.CHASING)
        return
    end

    if Dist2d(GetEntityCoords(self.unit.entity), location) < max_distance and not self.unit.current_target then
        self.unit:move_to(PoliceStates.SEARCHING)
        return
    end

    if not is_driving(self.unit.entity) then return end

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
    local owner   = NetworkGetEntityOwner(state.unit.entity)
    local task_id = Tasks.DRIVE_TO_COORD

    if GetVehiclePedIsIn(state.unit.current_target, false) > 0 then
        task_id = Tasks.VEHICLE_CHASE
    end

    TriggerClientEvent(Events.CREATE_POPULATION_TASK, owner, {
        net_id   = NetworkGetNetworkIdFromEntity(state.unit.entity),
        location = location,
        target   = state.unit.current_target,
        task_id  = task_id
    })

    state.last_location = location
end
