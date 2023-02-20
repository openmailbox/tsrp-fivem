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
    if self.unit.vehicle_driver then
        sync_enter_vehicle(self)
    else
        sync_follow_entity(self)
    end
end

function Chasing:exit()
end

function Chasing:update()
    if Dist2d(GetEntityCoords(self.unit.entity), GetEntityCoords(self.unit.current_target)) < 15.0 then
        self.unit:move_to(PoliceStates.CONFRONTING)
        return
    end

    if GetPedScriptTaskCommand(self.unit.entity) == Tasks.NO_TASK and is_driving(self.unit.entity) then
        sync_vehicle_drive(self)
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

    Citizen.Wait(GetPlayerPing(owner) + 50)

    Logging.log(Logging.TRACE, "Tasking " .. state.unit.entity .. " to enter vehicle " .. state.unit.vehicle .. ".")
    TaskEnterVehicle(state.unit.entity, state.unit.vehicle, -1, -1, 2.0, 0, 0)
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
    local owner = NetworkGetEntityOwner(state.unit.entity)

    TriggerClientEvent(Events.CREATE_POPULATION_TASK, owner, {
        net_id   = NetworkGetNetworkIdFromEntity(state.unit.entity),
        location = GetEntityCoords(state.unit.current_target),
        task_id  = Tasks.DRIVE_TO_COORD
    })
end
