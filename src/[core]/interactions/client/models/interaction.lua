Interaction = {}

local INTERACT_RANGE = 1.0

-- forward declarations
local raycast_camera,
      rotation_to_dir,
      show_target

local closest_object      = 0
local exclusions          = {}
local looking_for_targets = false
local registrations       = {}
local showing             = false
local showing_object      = 0

-- Add a specific entity to the exclusion list. Excluded entities will NOT generate an interaction prompt.
-- @tparam number entity
function Interaction.add_exclusion(entity)
    exclusions[entity] = true
end
exports("AddExclusion", Interaction.add_exclusion)

-- Drop the player into a target-selection mode where they see a crosshair and select a target
-- @tparam table options
-- @tparam string options.name a descriptive verb for the interaction
-- @tparam number options.entity_type the integer type of raycast target we want
-- @tparam function options.callback behavior to pass the target to on select
function Interaction.find_target(options)
    Interaction.stop_looking()

    if showing then
        showing_object = 0

        while showing do
            Citizen.Wait(50)
        end
    end

    SendNUIMessage({ type = Events.CREATE_INTERACTIVE_OBJECT, item = {} })

    Citizen.CreateThread(function()
        local waiting   = true
        --local scaleform = exports.utility:CreateInstructionalDisplay(options.name, 51, "Cancel", 20)

        --exports.utility:DrawSubtitle("Select a target.", 3000)

        while waiting do
            DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)

            if IsControlJustPressed(0, 51) then
                local target = raycast_camera(PlayerPedId(), options.entity_type or 12)

                if target.hit and target.result == 2 and target.entity > 0 then
                    waiting = false
                    options.callback(target.entity, target.location, target.distance)
                else
                    --exports.utility:ShowNotification("No target found.", true)
                end
            elseif IsControlJustPressed(0, 20) then
                waiting = false
                options.callback(nil)
            end

            Citizen.Wait(0)
        end

        SendNUIMessage({ type = Events.DELETE_INTERACTIVE_OBJECT })

        Interaction.look_for_targets()
    end)
end
exports("FindTarget", Interaction.find_target)

function Interaction.interact()
    if not showing_object or
        showing_object == 0 or
        IsPlayerDead(PlayerId()) or
        IsPedDeadOrDying(PlayerPedId(), true) then

        return
    end

    local model    = GetEntityModel(showing_object)
    local behaviors = registrations[model]

    if not behaviors then return end

    for name, beh in pairs(behaviors) do
        local succ, error = pcall(beh.callback, showing_object)

        if not succ then
            Citizen.Trace("Error while running interaction '" .. name .. "' with object " .. showing_object .. ": " ..
                          error .. "\n")
        end
    end
end
RegisterCommand("interact", Interaction.interact, false)
RegisterKeyMapping("interact", "Interact with the current targetted object", "keyboard", "E")

function Interaction.look_for_targets()
    if looking_for_targets then return end
    looking_for_targets = true

    local behaviors, ped, target

    Citizen.CreateThread(function()
        while looking_for_targets do
            closest_object = 0
            ped            = PlayerPedId()

            if not IsPlayerFreeAiming(PlayerId()) and not IsPedInAnyVehicle(ped, true) then
                target = raycast_camera(ped)
            else
                target = {}
            end

            behaviors = registrations[GetEntityModel(target.entity)]

            if target.result == 2 and target.hit and behaviors and not exclusions[target.entity] then
                closest_object = target.entity
            end

            if closest_object > 0 and closest_object ~= showing_object then
                local prompt = nil

                for name, beh in pairs(behaviors) do
                    prompt = prompt or beh.options.prompt

                    if beh.options.on_target then
                        local succ, error = pcall(beh.options.on_target, closest_object, target.distance)

                        if not succ then
                            Citizen.Trace("WARNING: Error running on_target for interaction '" .. name .. "': " ..
                                          error .. "\n")
                        end
                    end
                end

                show_target(closest_object, target.distance, prompt)
            elseif closest_object == 0 and showing_object > 0 then
                showing_object = 0
            end

            Citizen.Wait(250)
        end
    end)
end

-- Used to register a new interaction with a game object. When player looks at the model type, they will get a
-- crosshair and prompt to interact.
-- @tparam table options
-- @tparam number options.model the object model hash
-- @tparam string options.name a descriptive verb for this interaction
-- @tparam function options.on_target an optional callback triggered once when the player initially targets this object.
-- @tparam function callback behavior to execute when the player interacts with the target.
function Interaction.register(options, callback)
    local model_hash = tonumber(options.model)
    local behaviors  = registrations[model_hash]

    if not behaviors then
        behaviors = {}
        registrations[model_hash] = behaviors
    end

    Citizen.Trace("Registering new interaction for " .. options.model .. ": " .. options.name .. "\n")

    -- An object can have multiple behaviors as long as they have unique names
    behaviors[options.name] = {
        options  = options,
        callback = callback
    }
end
exports("RegisterInteraction", Interaction.register)

function Interaction.remove_exclusion(entity)
    exclusions[entity] = nil
end
exports("RemoveExclusion", Interaction.remove_exclusion)

--- Show details about a nearby item that's available for pickup if it's the current target.
-- @tparam number object_id the game object ID
-- @tparam table item the serialized item data
function Interaction.set_details(object_id, item)
    if object_id ~= showing_object then return end
    SendNUIMessage({ type = Events.CREATE_INTERACTIVE_OBJECT, item = item })
end
exports("SetTargetDetails", Interaction.set_details)

function Interaction.stop_looking()
    looking_for_targets = false
end

function Interaction.unregister(model, name)
    local model_hash = tonumber(model)
    local behaviors  = registrations[model_hash]

    if not behaviors then return end

    behaviors[name] = nil
end
exports("UnregisterInteraction", Interaction.unregister)

-- @local
function show_target(object_id, distance, prompt)
    if showing_object > 0 then
        SendNUIMessage({ type = Events.DELETE_INTERACTIVE_OBJECT })
    end

    -- TODO: Show prompt

    SendNUIMessage({ type = Events.CREATE_INTERACTIVE_OBJECT, item = {} })
    showing_object = object_id

    if showing then return end
    showing = true

    Citizen.CreateThread(function()
        while showing_object > 0 do
            Citizen.Wait(100)
        end

        showing = false
        SendNUIMessage({ type = Events.DELETE_INTERACTIVE_OBJECT })
    end)
end

-- @local
function raycast_camera(ped, target_type)
    target_type = target_type or 16

    local crot      = GetGameplayCamRot()
    local cloc      = GetGameplayCamCoord()
    local direction = rotation_to_dir(crot)
    local distance  = INTERACT_RANGE + Vdist(cloc, GetEntityCoords(ped))

    local dest = {
        x = cloc.x + direction.x * distance,
        y = cloc.y + direction.y * distance,
        z = cloc.z + direction.z * distance
    }

    local ray = StartShapeTestCapsule(cloc.x, cloc.y, cloc.z, dest.x, dest.y, dest.z, 0.2, target_type, ped, 7)
    local result, hit, pos, _, entity = GetShapeTestResult(ray)

    while result == 1 do
        Citizen.Wait(0)
    end

    return {
        result   = result,
        distance = distance,
        hit      = hit,
        location = pos,
        entity   = entity
    }
end

-- @local
function rotation_to_dir(rotation)
    local adjustedRotation = {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }

    local direction = {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }

    return direction
end
