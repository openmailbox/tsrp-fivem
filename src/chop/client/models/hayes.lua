Hayes = {}

-- Used to store last mission offer details from server.
Hayes.last_offer = {}

-- Forward declarations
local show_marker,
      show_offer,
      show_prompt

local BLIP_LOC   = vector3(472.1760, -1308.8689, 29.2353)
local PROMPT_KEY = 'HayesChopPrompt'

local blip_id      = nil   -- current map blip
local is_active    = false -- true when the Hayes blip/marker is active on map
local is_prompting = false -- true when player is close enough for marker prompt
local marker_id    = nil

function Hayes.initialize()
    AddTextEntry(PROMPT_KEY, "Press ~INPUT_CONTEXT~ to check the list.")

    blip_id = exports.map:AddBlip(BLIP_LOC, {
        icon    = 80,
        display = 2,
        color   = 6,
        label   = "Hayes Autos"
    })
end

function Hayes.cleanup()
    exports.map:RemoveBlip(blip_id)
    exports.markers:RemoveMarker(marker_id)
end

function Hayes.reset()
    if is_active then return end
    is_active = true
    show_marker()
end

-- @local
function show_marker()
    marker_id = exports.markers:AddMarker({
        icon           = 32,
        coords         = BLIP_LOC,
        red            = 255,
        green          = 255,
        face_camera    = true,
        scale          = vector3(0.2, 0.2, 0.2),
        blue           = 0,
        interact_range = 1.0,
        draw_range     = 12.0,
        on_interact    = show_offer,
        on_enter       = show_prompt,
        on_exit        = function()
            is_prompting = false
        end
    })
end

-- @local
function show_offer()
    is_active = false

    exports.markers:RemoveMarker(marker_id)
    exports.progress:ShowProgressBar(2000, "Checking List")

    local vehicles   = exports.map:GetVehicleDistribution()
    local candidates = {}

    for _, v in ipairs(vehicles) do
        if v.count < 10 then
            break
        end

        table.insert(candidates, v)
    end

    -- TODO: Edge case where we can't get any candidates.
    local model    = candidates[math.random(#candidates)].model
    local _, spawn = exports.map:GetVehicleSpawn(model)

    TriggerServerEvent(Events.CREATE_CHOP_MISSION_OFFER, {
        ui_target = GetCloudTimeAsInt() + 2000,
        model     = model,
        spawn     = spawn
    })
end

-- @local
function show_prompt()
    if is_prompting then return end
    is_prompting = true

    Citizen.CreateThread(function()
        while is_prompting do
            DisplayHelpTextThisFrame(PROMPT_KEY, 0)
            Citizen.Wait(0)
        end
    end)
end
