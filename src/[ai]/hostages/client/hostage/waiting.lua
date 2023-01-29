Waiting = {}

Hostage.States[HostageStates.WAITING] = Waiting

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
    PlayPedAmbientSpeechNative(self.hostage.entity, "GENERIC_FRIGHTENED_HIGH", "SPEECH_PARAMS_FORCE_SHOUTED")

    SetPedConfigFlag(self.hostage.entity, 225, true) -- DisablePotentialToBeWalkedIntoResponse
    SetPedConfigFlag(self.hostage.entity, 226, true) -- DisablePedAvoidance

    self.timeout = GetGameTimer() + 7000

    local behavior = self.hostage.behavior

    exports.interactions:RegisterInteraction({
        entity = self.hostage.entity,
        name   = behavior.name,
        prompt = behavior.prompt,
    }, function(_)
        self.hostage:move_to(HostageStates.ACTING)
    end)
end

function Waiting:exit()
    exports.interactions:UnregisterInteraction(nil, self.hostage.behavior.name, self.hostage.entity)
end

function Waiting:update()
    if GetGameTimer() > self.timeout then
        self.hostage:move_to(HostageStates.FLEEING)
    end

    if not GetIsTaskActive(self.hostage.entity, 0) then
        TaskHandsUp(self.hostage.entity, -1, PlayerPedId(), -1, 1)
    end
end
