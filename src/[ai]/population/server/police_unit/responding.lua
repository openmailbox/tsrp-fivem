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

    self.destination = find_best_destination(self)

    if is_driving(self.unit.entity) then
        self.unit.vehicle_driver = true
        sync_task(self, self.destination)
    end
end

function Responding:exit()
end

function Responding:update()
    if not self.unit.assigned_call then
        self.unit:move_to(PoliceStates.AVAILABLE)
        return
    end

    local target = self.unit.current_target

    if target and self.unit:can_see(target) then
        self.unit:move_to(PoliceStates.CONFRONTING)
        return
    elseif target then
        self.unit:move_to(PoliceStates.CHASING)
        return
    end

    if Dist2d(GetEntityCoords(self.unit.entity), self.destination) < 20 then
        self.unit:move_to(PoliceStates.SEARCHING)
        return
    end

    if not is_driving(self.unit.entity) then return end

    local doing_nothing = GetPedScriptTaskCommand(self.unit.entity) == Tasks.NO_TASK

    if not self.last_destination or doing_nothing or Dist2d(self.destination, self.last_destination) > 10.0 then
        sync_task(self, self.destination)
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
        target   = state.unit.current_target,
        task_id  = Tasks.DRIVE_TO_COORD
    })

    state.last_destination = location
end
