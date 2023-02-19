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
    sync_task(self)
end

function Confronting:exit()
end

function Confronting:process_input(data)
    if data.surrendering then
        self.unit.current_target_offset = data.offset
        self.unit:move_to(PoliceStates.DETAINING)
    elseif data.obscured then
        sync_task(self)
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

    if GetPedScriptTaskCommand(self.unit.entity) == Tasks.NO_TASK then
        sync_task(self)
    end
end

-- @local
function sync_task(state)
    local owner    = NetworkGetEntityOwner(state.unit.entity)
    local location = GetEntityCoords(state.unit.current_target)
    local distance = Dist2d(GetEntityCoords(state.unit.entity), location)
    local task     = Tasks.AIM_AT_ENTITY

    if distance > 15.0 then
        task = Tasks.GOTO_COORD_WHILE_AIMING
    end

    TriggerClientEvent(Events.CREATE_POPULATION_TASK, owner, {
        task_id  = task,
        net_id   = NetworkGetNetworkIdFromEntity(state.unit.entity),
        target   = NetworkGetNetworkIdFromEntity(state.unit.current_target),
        location = location
    })
end
