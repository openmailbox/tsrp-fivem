Detaining = {}

PoliceUnit.States[PoliceStates.DETAINING] = Detaining

function Detaining:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Detaining:enter()
    TaskGoToEntity(self.unit.entity, self.unit.current_target, -1, 1.2, 1.0, 0, 0)
end

function Detaining:exit()
end

function Detaining:update()
    local distance = Dist2d(GetEntityCoords(self.unit.entity), GetEntityCoords(self.unit.current_target))
    local task     = GetPedScriptTaskCommand(self.unit.entity)

    if distance < 1.4 and not self.is_arresting then
        self.is_arresting = true

        local enactor_owner = NetworkGetEntityOwner(self.unit.entity)
        local target_owner  = NetworkGetEntityOwner(self.unit.current_target)
        local target_net_id = NetworkGetNetworkIdFromEntity(self.unit.current_target)

        TriggerClientEvent(Events.CREATE_POPULATION_TASK, enactor_owner, {
            task_id = Tasks.DETAIN,
            net_id  = NetworkGetNetworkIdFromEntity(self.unit.entity),
            target  = target_net_id,
            ping    = GetPlayerPing(enactor_owner)
        })

        TriggerClientEvent(Events.CREATE_CUFFED_HOSTAGE, target_owner, {
            target = target_net_id,
            ping   = GetPlayerPing(target_owner)
        })
    elseif task == Tasks.NO_TASK then
        if self.is_arresting then
            self.unit:move_to(PoliceStates.CONFRONTING)
        else
            self:enter()
        end
    end
end
