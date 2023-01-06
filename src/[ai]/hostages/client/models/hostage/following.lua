Following = {}

Hostage.States[HostageStates.FOLLOWING] = Following

-- Forward declarations
local apply_animation,
      follow_leader,
      enter_vehicle

local Animation = { DICTIONARY = "mp_arresting", NAME = "idle" }

local INTERACTION_NAME    = "Release Hostage"
local MAX_FOLLOW_DISTANCE = 3.0

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

-- Called every second during update loop
function Following:update()
    if not IsEntityPlayingAnim(self.hostage.entity, Animation.DICTIONARY, Animation.NAME, 3) then
        apply_animation(self.hostage.entity)
    end

    -- TODO: Make them follow the closest player with a gun out; not always the entity owner
    local leader = PlayerPedId()
    local ped    = self.hostage.entity

    if IsPedInAnyVehicle(leader, false) and not IsPedInAnyVehicle(ped, false) then
        enter_vehicle(ped, GetVehiclePedIsIn(leader))
    elseif not IsPedInAnyVehicle(leader, false) and IsPedInAnyVehicle(ped, false) then
        TaskLeaveVehicle(ped, GetVehiclePedIsIn(ped, false), 0)
        TaskFollowToOffsetOfEntity(ped, leader, 1.0, 1.0, 1.0, 0.5, -1, 3.0, true)
    elseif Vdist(GetEntityCoords(ped), GetEntityCoords(leader)) > MAX_FOLLOW_DISTANCE then
        TaskFollowToOffsetOfEntity(ped, leader, 1.0, 1.0, 1.0, 0.5, -1, 3.0, true)
    elseif not IsPedInAnyVehicle(ped, false) then
        TaskStandStill(ped, -1)
    end
end

-- @local
function apply_animation(entity)
    TaskPlayAnim(entity, Animation.DICTIONARY, Animation.NAME, 3.0, -3.0, -1, 49, 0, 0, 0, 0)
end

-- @local
function enter_vehicle(entity, vehicle)
    local empty = nil

    for i = 1, GetVehicleMaxNumberOfPassengers(vehicle) do
        if IsVehicleSeatAccessible(entity, vehicle, i - 1, 0, true) then
            empty = i - 1
            break
        end
    end

    if empty then
        TaskEnterVehicle(entity, vehicle, -1, empty, 0.5, 1, 0)
    end
end
