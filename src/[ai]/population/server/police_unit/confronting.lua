Confronting = {}

PoliceUnit.States[PoliceStates.CONFRONTING] = Confronting

function Confronting:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Confronting:enter()
end

function Confronting:exit()
end

function Confronting:update()
    if not DoesEntityExist(self.unit.current_target) then
        self.unit:move_to(PoliceStates.SEARCHING)
        return
    end

    if GetPedScriptTaskCommand(self.unit.entity) ~= 1630799643 then
        local owner = NetworkGetEntityOwner(self.unit.entity)

        TriggerClientEvent(Events.CREATE_POPULATION_TASK, owner, {
            net_id  = NetworkGetNetworkIdFromEntity(self.unit.entity),
            target  = NetworkGetNetworkIdFromEntity(self.unit.current_target),
            task_id = Tasks.AIM_AT_ENTITY
        })
    end
end
