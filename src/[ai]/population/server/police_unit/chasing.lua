Chasing = {}

PoliceUnit.States[PoliceStates.CHASING] = Chasing

-- Forward declarations
local is_driving,
      sync_enter_vehicle,
      sync_vehicle_drive,
      sync_follow_entity

function Chasing:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Chasing:enter()
    self.last_move_at = GetGameTimer()
    self.last_move    = GetEntityCoords(self.unit.current_target)

    local vehicle = GetVehiclePedIsIn(self.unit.entity, false)

    if vehicle > 0 and self.unit.vehicle_driver then
        sync_vehicle_drive(self)
    elseif self.unit.vehicle_driver then
        sync_enter_vehicle(self)
    elseif vehicle == 0 then
        sync_follow_entity(self)
    end
end

function Chasing:exit()
end

function Chasing:update()
    local target_loc = GetEntityCoords(self.unit.current_target)
    local distance   = Dist2d(GetEntityCoords(self.unit.entity), target_loc)
    local time       = GetGameTimer()
    local vehicle    = GetVehiclePedIsIn(self.unit.entity, false)

    if distance > 150.0 and vehicle == 0 then
        self.unit:clear()
        return
    end

    if distance < 15.0 and (vehicle == 0 or (time - self.last_move_at) > 7000) then
        self.unit:move_to(PoliceStates.CONFRONTING)
        return
    end

    if Dist2d(self.last_move, target_loc) > 1.0 then
        self.last_move    = target_loc
        self.last_move_at = time
    end

    local task = GetPedScriptTaskCommand(self.unit.entity)

    if task == Tasks.NO_TASK and is_driving(self.unit.entity) then
        sync_vehicle_drive(self)
    elseif vehicle == 0 and not self.unit.vehicle_driver and task ~= Tasks.FOLLOW_TO_OFFSET_OF_ENTITY then
        sync_follow_entity(self)
    end
end

-- @local
function is_driving(entity)
    local vehicle = GetVehiclePedIsIn(entity, false)
    return vehicle > 0 and GetPedInVehicleSeat(vehicle, -1) == entity
end

-- @local
function sync_enter_vehicle(state)
    local owner = NetworkGetEntityOwner(state.unit.entity)

    TriggerClientEvent(Events.DELETE_POPULATION_TASK, owner, {
        net_id = NetworkGetNetworkIdFromEntity(state.unit.entity)
    })

    Citizen.Wait(GetPlayerPing(owner) + 100)

    Logging.log(Logging.TRACE, "Tasking " .. state.unit.entity .. " to enter vehicle " .. state.unit.vehicle .. ".")

    -- TODO: Ped seems to lose task after entering vehicle if update to chase doesn't hit fast enough
    TaskEnterVehicle(state.unit.entity, state.unit.vehicle, -1, -1, 2.0, 8, 0)
end

-- @local
function sync_follow_entity(state)
    local owner = NetworkGetEntityOwner(state.unit.entity)

    TriggerClientEvent(Events.CREATE_POPULATION_TASK, owner, {
        task_id  = Tasks.FOLLOW_TO_OFFSET_OF_ENTITY,
        net_id   = NetworkGetNetworkIdFromEntity(state.unit.entity),
        target   = NetworkGetNetworkIdFromEntity(state.unit.current_target)
    })
end

-- @local
function sync_vehicle_drive(state)
    local owner   = NetworkGetEntityOwner(state.unit.entity)
    local task_id = Tasks.DRIVE_TO_COORD

    if state.unit.vehicle_type == "heli" then
        task_id = Tasks.HELI_MISSION
    elseif GetVehiclePedIsIn(state.unit.current_target, false) > 0 then
        task_id = Tasks.VEHICLE_CHASE
    end

    TriggerClientEvent(Events.CREATE_POPULATION_TASK, owner, {
        net_id   = NetworkGetNetworkIdFromEntity(state.unit.entity),
        target   = NetworkGetNetworkIdFromEntity(state.unit.current_target),
        location = GetEntityCoords(state.unit.current_target),
        task_id  = task_id
    })
end
