Waiting = {}

Hostage.States[HostageStates.WAITING] = Waiting

local INTERACTION_NAME = "Take Hostage"

function Waiting:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Waiting:enter()
    ClearPedTasksImmediately(self.hostage.entity)
    SetBlockingOfNonTemporaryEvents(self.hostage.entity, true)
    TaskSetBlockingOfNonTemporaryEvents(self.hostage.entity, true)
    TaskHandsUp(self.hostage.entity, -1, PlayerPedId(), -1, 1)

    self.timeout = GetGameTimer() + 7000

    exports.interactions:RegisterInteraction({
        entity = self.hostage.entity,
        name   = INTERACTION_NAME,
        prompt = "take a hostage",
    }, function(_)
        exports.interactions:AddExclusion(self.hostage.entity)
        exports.progress:ShowProgressBar(2000, "Detaining")
        Citizen.Wait(1800)
        self.hostage:move_to(HostageStates.FOLLOWING)
        exports.interactions:RemoveExclusion(self.hostage.entity)
    end)
end

-- TODO: Ensure this gets called even if the ped disappears unexpectedly
function Waiting:exit()
    exports.interactions:UnregisterInteraction(nil, INTERACTION_NAME, self.hostage.entity)
end

function Waiting:update()
    if GetGameTimer() > self.timeout then
        self.hostage:move_to(HostageStates.FLEEING)
    end

    if not GetIsTaskActive(self.hostage.entity, 0) then
        TaskHandsUp(self.hostage.entity, -1, PlayerPedId(), -1, 1)
    end
end
