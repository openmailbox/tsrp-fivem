Confronting = {}

PoliceUnit.States[PoliceStates.CONFRONTING] = Confronting

-- Forward declarations
local sync_task

function Confronting:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Confronting:enter()
    self.last_target_vehicle = GetVehiclePedIsIn(self.unit.current_target, false)
    sync_task(self)
end

function Confronting:exit()
end

function Confronting:process_input(data)
    if data.surrendering then
        self.unit.current_target_offset = data.offset
        self.unit:move_to(PoliceStates.DETAINING)
    end
end

function Confronting:update()
    if not self.unit.assigned_call then
        self.unit:move_to(PoliceStates.AVAILABLE)
        return
    end

    if not DoesEntityExist(self.unit.current_target) then
        self.unit:move_to(PoliceStates.SEARCHING)
        return
    end

    local distance = Dist2d(GetEntityCoords(self.unit.entity), GetEntityCoords(self.unit.current_target))
    local vehicle  = GetVehiclePedIsIn(self.unit.current_target, false)

    if distance > 15.0 or (self.unit.vehicle_driver and vehicle ~= self.last_target_vehicle and vehicle > 0) then
        self.unit:move_to(PoliceStates.CHASING)
    elseif GetPedScriptTaskCommand(self.unit.entity) == Tasks.NO_TASK then
        sync_task(self)
    end

    self.last_target_vehicle = vehicle
end

-- @local
function sync_task(state)
    local owner    = NetworkGetEntityOwner(state.unit.entity)
    local location = GetEntityCoords(state.unit.current_target)

    TriggerClientEvent(Events.CREATE_POPULATION_TASK, owner, {
        task_id  = Tasks.AIM_AT_ENTITY,
        net_id   = NetworkGetNetworkIdFromEntity(state.unit.entity),
        target   = NetworkGetNetworkIdFromEntity(state.unit.current_target),
        location = location
    })
end
