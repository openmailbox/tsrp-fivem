-- Use this as an example for registering hostage behaviors from other resources.
Following = {}

-- Forward declarations
local apply_animation,
      enter_vehicle,
      on_enter,
      on_exit,
      on_update

local Animation = { DICTIONARY = "mp_arresting", NAME = "idle" }

local INTERACTION_NAME    = "Release Hostage"
local MAX_FOLLOW_DISTANCE = 3.0

local followers = {}

function Following.initialize()
    Behaviors.register("following", {
        name      = "Take Hostage",
        prompt    = "take a hostage",
        on_enter  = on_enter,
        on_exit   = on_exit,
        on_update = on_update,
    })
end

-- @local
function on_enter(entity)
    followers[entity] = true

    if not HasAnimDictLoaded(Animation.DICTIONARY) then
        RequestAnimDict(Animation.DICTIONARY)

        repeat
            Citizen.Wait(25)
        until HasAnimDictLoaded(Animation.DICTIONARY)
    end

    exports.progress:ShowProgressBar(2000, "Detaining")

    exports.interactions:AddExclusion(entity)
    Citizen.Wait(1800)
    exports.interactions:RemoveExclusion(entity)

    exports.interactions:RegisterInteraction({
        entity = entity,
        name   = INTERACTION_NAME,
        prompt = "release the hostage",
    }, function(_)
        exports.progress:ShowProgressBar(2000, "Releasing")

        exports.interactions:AddExclusion(entity)
        Citizen.Wait(1800)
        exports.interactions:RemoveExclusion(entity)

        followers[entity] = nil
    end)
end

-- @local
function on_exit(entity)
    followers[entity] = nil
    exports.interactions:UnregisterInteraction(nil, INTERACTION_NAME, entity)
    ClearPedTasks(entity)
end

-- Called every second during update loop
-- @local
function on_update(entity)
    if not IsEntityPlayingAnim(entity, Animation.DICTIONARY, Animation.NAME, 3) then
        apply_animation(entity)
    end

    -- TODO: Make them follow the closest player with a gun out; not always the entity owner
    local leader = PlayerPedId()
    local ped    = entity

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

    return followers[entity]
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
