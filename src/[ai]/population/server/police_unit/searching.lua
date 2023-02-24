Searching = {}

PoliceUnit.States[PoliceStates.SEARCHING] = Searching

-- Forward declarations
local sync_task

function Searching:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Searching:enter()
    sync_task(self)
end

function Searching:exit()
end

function Searching:process_input(data)
    local target = NetworkGetEntityFromNetworkId(data.target)

    self.unit.current_target = target

    -- Only the unit who witnessed should make the report
    if data.entity == self.unit.entity then
        Dispatcher.report_suspect(self.unit.assigned_call.id, target, data.location)
    end

    self.unit:move_to(PoliceStates.CONFRONTING)
end

function Searching:update()
    if not self.unit.assigned_call then
        self.unit:move_to(PoliceStates.AVAILABLE)
        return
    end

    if self.unit.current_target and DoesEntityExist(self.unit.current_target) then
        self.unit:move_to(PoliceStates.CONFRONTING)
        return
    end

    if GetPedScriptTaskCommand(self.unit.entity) == Tasks.NO_TASK then
        sync_task(self)
    end
end

-- @local
function sync_task(search)
    local owner = NetworkGetEntityOwner(search.unit.entity)

    TriggerClientEvent(Events.CREATE_POPULATION_TASK, owner, {
        net_id   = NetworkGetNetworkIdFromEntity(search.unit.entity),
        location = search.unit.assigned_call.location,
        task_id  = Tasks.SEARCH_FOR_HATED_IN_AREA
    })
end