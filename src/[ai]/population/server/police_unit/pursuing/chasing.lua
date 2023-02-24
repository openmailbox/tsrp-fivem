Chasing = {}

PoliceUnit.States[PoliceStates.CHASING] = Chasing

-- Forward declarations
local sync_enter_vehicle,
      sync_vehicle_drive,
      sync_follow_entity

function Chasing:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Chasing:enter()
    local in_vehicle = GetVehiclePedIsIn(self.unit.entity, false) > 0
    local im_driving = self.unit.vehicle_driver

    if im_driving and in_vehicle then
        sync_vehicle_drive(self)
    elseif im_driving or GetVehiclePedIsIn(self.unit.current_target, false) > 0 then
        sync_enter_vehicle(self)
    else
        sync_follow_entity(self)
    end
end

function Chasing:exit()
end

function Chasing:process_input(data)
    if data.fleeing then
        -- Only the unit who witnessed should make the report
        if data.entity == self.unit.entity then
            Dispatcher.report(self.unit.assigned_call.id, data)
        end
    end
end

function Chasing:update()
    if not DoesEntityExist(self.unit.current_target) then
        self.unit:move_to(PoliceStates.SEARCHING)
        return
    end

    local my_location = GetEntityCoords(self.unit.entity)
    local sus_vehicle = GetVehiclePedIsIn(self.unit.current_target, false)

    if self.unit:can_see(self.unit.current_target) and (sus_vehicle == 0 or my_location == self.last_location) then
        self.unit:move_to(PoliceStates.CONFRONTING)
        return
    end

    local my_vehicle = GetVehiclePedIsIn(self.unit.entity, false)
    local im_driving = my_vehicle > 0 and GetPedInVehicleSeat(my_vehicle, -1) == self.unit.entity
    local task       = GetPedScriptTaskCommand(self.unit.entity)

    if im_driving and task ~= Tasks.DRIVE_TO_COORD and not self.unit:can_see(self.unit.current_target) then
        sync_vehicle_drive(self)
        return
    end

    local foot_chase = sus_vehicle == 0 and not self.unit.vehicle_driver

    if foot_chase and task == Tasks.NO_TASK then
        sync_follow_entity(self)
        return
    end

    self.last_location = my_location
end

-- @local
function sync_enter_vehicle(state)
    local owner = NetworkGetEntityOwner(state.unit.entity)

    TriggerClientEvent(Events.DELETE_POPULATION_TASK, owner, {
        net_id = NetworkGetNetworkIdFromEntity(state.unit.entity)
    })

    Citizen.Wait(GetPlayerPing(owner) + 100)

    Logging.log(Logging.TRACE, "Tasking " .. state.unit.entity .. " to enter vehicle " .. state.unit.vehicle .. ".")

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
