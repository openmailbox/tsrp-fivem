Waiting = {}

Hostage.States[HostageStates.WAITING] = Waiting

function Waiting:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Waiting:enter()
    self.timeout = GetGameTimer() + 5000

    ClearPedTasks(self.hostage.entity)
    TaskHandsUp(self.hostage.entity, -1, PlayerPedId(), -1, 1)
end

function Waiting:update()
    if not GetIsTaskActive(self.hostage.entity, 0) then
        TaskHandsUp(self.hostage.entity, -1, PlayerPedId(), -1, 1)
    end

    if GetGameTimer() > self.timeout then
        self.hostage:move_to(HostageStates.FLEEING)
    end
end
