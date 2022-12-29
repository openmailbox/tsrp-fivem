Interaction = {}

local DEFAULT_PROMPT       = "Press ~INPUT_CONTEXT~ to interact."
local DEFAULT_PROMPT_LABEL = "interactions:default_prompt"
local INTERACT_RANGE       = 1.0

-- forward declarations
local look_for_targets,
      raycast_camera,
      rotation_to_dir,
      show_target

local closest_entity      = 0
local exclusions          = {}
local looking_for_targets = false
local registrations       = {}
local showing             = false
local showing_entity      = 0

-- Add a specific entity to the exclusion list. Excluded entities will NOT generate an interaction prompt.
-- @tparam number entity
function Interaction.add_exclusion(entity)
    exclusions[entity] = true
end
exports("AddExclusion", Interaction.add_exclusion)

function Interaction.check_exclusion(entity)
    return not not exclusions[entity]
end
exports("IsExcluded", Interaction.check_exclusion)

function Interaction.clear_exclusions()
    exclusions = {}
end

function Interaction.initialize()
    AddTextEntry(DEFAULT_PROMPT_LABEL, DEFAULT_PROMPT)
    SetEntityDrawOutlineColor(0, 200, 0, 100)
    look_for_targets()
end

function Interaction.interact()
    if not showing_entity or
        showing_entity == 0 or
        IsPlayerDead(PlayerId()) or
        IsPedDeadOrDying(PlayerPedId(), true) then

        return
    end

    local model     = GetEntityModel(showing_entity)
    local behaviors = registrations[model]

    if not behaviors then return end

    for name, beh in pairs(behaviors) do
        local succ, error = pcall(beh.callback, showing_entity)

        if not succ then
            error = error or "unspecified error"

            Citizen.Trace("Error while running interaction '" .. name .. "' with entity " .. showing_entity .. ": " ..
                          error .. "\n")
        end
    end
end
RegisterCommand("interact", Interaction.interact, false)
RegisterKeyMapping("interact", "Interact with the current targetted entity", "keyboard", "E")

-- Used to register a new interaction with a game entity. When player looks at the model type, they will get a
-- crosshair and prompt to interact.
-- @tparam table options
-- @tparam number options.model the entity model hash
-- @tparam string options.name a descriptive verb for this interaction
-- @tparam string options.prompt a descriptive phrase shown to the user as a prompt i.e. "open the crate"
-- @tparam function options.on_target an optional callback triggered once when the player initially targets this entity.
-- @tparam function callback behavior to execute when the player interacts with the target.
-- @treturn boolean success or failure
function Interaction.register(options, callback)
    local model_hash   = tonumber(options.model)
    local behaviors    = registrations[model_hash]
    local prompt_label = options.prompt and ("interactions:" .. model_hash .. "_" .. string.lower(options.name))

    if not model_hash then
        return false
    end

    if not behaviors then
        behaviors = {}
        registrations[model_hash] = behaviors
    end

    if prompt_label then
        AddTextEntry(prompt_label, "Press ~INPUT_CONTEXT~ to " .. options.prompt .. ".")
    end

    -- An entity can have multiple behaviors as long as they have unique names
    behaviors[options.name] = {
        options      = options,
        callback     = callback,
        prompt_label = prompt_label
    }

    return true
end
exports("RegisterInteraction", Interaction.register)

function Interaction.remove_exclusion(entity)
    exclusions[entity] = nil
end
exports("RemoveExclusion", Interaction.remove_exclusion)

--- Show details about a nearby item that's available for pickup if it's the current target.
-- @tparam number entity_id the game entity ID
-- @tparam table item the serialized item data
function Interaction.set_details(entity_id, item)
    if entity_id ~= showing_entity then return end
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

    local empty = true

    for _, _ in pairs(behaviors) do
        empty = false
        break
    end

    if empty and model_hash then
        registrations[model_hash] = nil
    end
end
exports("UnregisterInteraction", Interaction.unregister)

-- @local
function look_for_targets()
    if looking_for_targets then return end
    looking_for_targets = true

    local behaviors, ped, target

    Citizen.CreateThread(function()
        while looking_for_targets do
            closest_entity = 0
            ped            = PlayerPedId()

            if not IsPlayerFreeAiming(PlayerId()) and not IsPedInAnyVehicle(ped, true) then
                target = raycast_camera(ped)
            else
                target = {}
            end

            behaviors = registrations[GetEntityModel(target.entity)]

            if target.result == 2 and target.hit and behaviors and not exclusions[target.entity] then
                closest_entity = target.entity
            end

            if closest_entity > 0 and closest_entity ~= showing_entity then
                local prompt = nil

                for name, beh in pairs(behaviors) do
                    prompt = prompt or beh.prompt_label

                    if beh.options.on_target then
                        local succ, error = pcall(beh.options.on_target, closest_entity, target.distance)

                        if not succ then
                            Citizen.Trace("WARNING: Error running on_target for interaction '" .. name .. "': " ..
                                          error .. "\n")
                        end
                    end
                end

                show_target(closest_entity, target.distance, prompt or DEFAULT_PROMPT_LABEL)
            elseif closest_entity == 0 and showing_entity > 0 then
                showing_entity = 0
            end

            Citizen.Wait(250)
        end
    end)
end


-- @local
function show_target(entity_id, _, prompt)
    if showing_entity > 0 then
        SendNUIMessage({ type = Events.DELETE_INTERACTIVE_OBJECT })
    end

    SendNUIMessage({ type = Events.CREATE_INTERACTIVE_OBJECT, item = {} })
    showing_entity = entity_id

    if showing then return end
    showing = true

    SetEntityDrawOutline(showing_entity, true)

    Citizen.CreateThread(function()
        while showing_entity > 0 do
            DisplayHelpTextThisFrame(prompt, 0)
            Citizen.Wait(0)
        end

        SetEntityDrawOutline(entity_id, false)

        showing = false
        SendNUIMessage({ type = Events.DELETE_INTERACTIVE_OBJECT })
    end)
end

-- @local
function raycast_camera(ped, target_type)
    target_type = target_type or 24 -- Bitmask 16 (objects) + 8 (peds)

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
