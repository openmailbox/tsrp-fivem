Following = {}

Hostage.States[HostageStates.FOLLOWING] = Following

-- Forward declarations
local apply_animation,
      follow_leader

local Animation = { DICTIONARY = "mp_arresting", NAME = "idle" }

local INTERACTION_NAME    = "Release Hostage"
local MAX_FOLLOW_DISTANCE = 7.0

function Following:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Following:enter()
    if not HasAnimDictLoaded(Animation.DICTIONARY) then
        RequestAnimDict(Animation.DICTIONARY)

        repeat
            Citizen.Wait(25)
        until HasAnimDictLoaded(Animation.DICTIONARY)
    end

    apply_animation(self.hostage.entity)
    follow_leader(self.hostage.entity)

    exports.interactions:RegisterInteraction({
        entity = self.hostage.entity,
        name   = INTERACTION_NAME,
        prompt = "release the hostage",
    }, function(_)
        exports.interactions:AddExclusion(self.hostage.entity)
        exports.progress:ShowProgressBar(2000, "Releasing")
        Citizen.Wait(1800)
        self.hostage:move_to(HostageStates.FLEEING)
        exports.interactions:RemoveExclusion(self.hostage.entity)
    end)
end

function Following:exit()
    exports.interactions:UnregisterInteraction(nil, INTERACTION_NAME, self.hostage.entity)
    ClearPedTasks(self.hostage.entity)
end

function Following:update()
    if not IsEntityPlayingAnim(self.hostage.entity, Animation.DICTIONARY, Animation.NAME, 3) then
        apply_animation(self.hostage.entity)
    end

    if not GetIsTaskActive(self.hostage.entity, 259) then
        follow_leader(self.hostage.entity)
    end
end

-- @local
function apply_animation(entity)
    TaskPlayAnim(entity, Animation.DICTIONARY, Animation.NAME, 3.0, -3.0, -1, 49, 0, 0, 0, 0)
end

-- @local
function follow_leader(entity)
    -- TODO: Make them follow the closest player with a gun out; not always the entity owner
    if Vdist(GetEntityCoords(entity), GetEntityCoords(PlayerPedId())) > MAX_FOLLOW_DISTANCE then
        TaskFollowToOffsetOfEntity(entity, PlayerPedId(), 1.0, 1.0, 1.0, 0.5, -1, 3.0, false)
    end
end
