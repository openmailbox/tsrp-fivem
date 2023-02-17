Confronting = {}

PoliceUnit.States[PoliceStates.CONFRONTING] = Confronting

function Confronting:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Confronting:enter()
    self:update()
end

function Confronting:exit()
end

function Confronting:update()
    if not DoesEntityExist(self.unit.current_target) or Dist2d(GetEntityCoords(self.unit.current_target), GetEntityCoords(self.unit.entity)) > 20.0 then
        self.unit:move_to(PoliceStates.SEARCHING)
        return
    end

    if not self.unit.assigned_call then
        self.unit:move_to(PoliceStates.AVAILABLE)
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
