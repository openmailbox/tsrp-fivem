Chasing = {}

PoliceUnit.States[PoliceStates.CHASING] = Chasing

-- Forward declarations
local sync_task

function Chasing:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Chasing:enter()
    sync_task(self)
end

function Chasing:exit()
end

function Chasing:update()
    if Dist2d(GetEntityCoords(self.unit.entity), GetEntityCoords(self.unit.current_target)) < 15.0 then
        self.unit:move_to(PoliceStates.CONFRONTING)
    end
end

-- @local
function sync_task(state)
    local owner = NetworkGetEntityOwner(state.unit.entity)

    TriggerClientEvent(Events.CREATE_POPULATION_TASK, owner, {
        task_id  = Tasks.FOLLOW_TO_OFFSET_OF_ENTITY,
        net_id   = NetworkGetNetworkIdFromEntity(state.unit.entity),
        target   = NetworkGetNetworkIdFromEntity(state.unit.current_target)
    })
end