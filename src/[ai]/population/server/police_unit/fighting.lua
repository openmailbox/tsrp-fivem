Fighting = {}

PoliceUnit.States[PoliceStates.FIGHTING] = Fighting

function Fighting:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Fighting:enter()
    TaskCombatPed(self.unit.entity, self.unit.current_target, 0, 16)
end

function Fighting:exit()
end

function Fighting:update()
    local target = self.unit.current_target

    if not target or not DoesEntityExist(target) or GetPedScriptTaskCommand(self.unit.entity) ~= Tasks.COMBAT then
        self.unit:move_to(PoliceStates.AVAILABLE)
        return
    end
end
