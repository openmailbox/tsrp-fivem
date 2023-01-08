EntityRadar = {}

-- forward declarations
local raycast_camera,
      rotation_to_dir,
      show_target

local INTERACT_RANGE = 1.1

local closest_entity = 0    -- Current closest entity player could interact with.
local showing_entity = 0    -- Same as closest_entity if player is close enough to interact.
local is_active      = true
local is_showing     = false

function EntityRadar.cleanup()
    is_active = false
end

function EntityRadar.get_current_target()
    return showing_entity
end

function EntityRadar.look_for_targets()
    Citizen.CreateThread(function()
        local interactions, ped, target

        while is_active do
            closest_entity = 0
            ped            = PlayerPedId()

            if not IsPlayerFreeAiming(PlayerId()) and not IsPedInAnyVehicle(ped, true) then
                target = raycast_camera(ped)
            else
                target = {}
            end

            interactions = Interaction.for_entity(target.entity)

            if target.result == 2 and target.hit and #interactions > 0 then
                closest_entity = target.entity
            end

            if closest_entity > 0 and closest_entity ~= showing_entity then
                local prompt = nil

                for _, interaction in ipairs(interactions) do
                    prompt = prompt or interaction.prompt_label

                    if interaction.on_target then
                        local succ, error = pcall(interaction.on_target, closest_entity, target.distance)

                        if not succ then
                            Citizen.Trace("WARNING: Error running on_target for interaction '" .. interaction.name .. "': " .. error .. "\n")
                        end
                    end
                end

                show_target(closest_entity, target.distance, prompt)
            elseif closest_entity == 0 and showing_entity > 0 then
                showing_entity = 0
            end

            Citizen.Wait(250)
        end
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

-- @local
function show_target(entity_id, _, prompt)
    if showing_entity > 0 then
        SendNUIMessage({ type = Events.DELETE_INTERACTIVE_OBJECT })
    end

    SendNUIMessage({ type = Events.CREATE_INTERACTIVE_OBJECT, item = {} })
    showing_entity = entity_id

    if is_showing then return end
    is_showing = true

    if GetEntityType(showing_entity) == 3 then
        SetEntityDrawOutline(showing_entity, true)
    end

    Citizen.CreateThread(function()
        while is_active and showing_entity > 0 do
            if DoesTextLabelExist(prompt) then
                DisplayHelpTextThisFrame(prompt, 0)
            end

            Citizen.Wait(0)
        end

        if GetEntityType(entity_id) == 3 then
            SetEntityDrawOutline(entity_id, false)
        end

        is_showing = false
        SendNUIMessage({ type = Events.DELETE_INTERACTIVE_OBJECT })
    end)
end
