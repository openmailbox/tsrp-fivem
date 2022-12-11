Maudes = {}

-- Forward delcarations
local show_marker,
      show_offer,
      show_prompt

local BLIP_LOC   = vector3(2728.3601, 4142.1143, 44.2880)
local PROMPT_KEY = 'MaudesBountyPrompt'

local blip_id      = nil
local is_active    = false
local is_prompting = false
local marker_id    = nil

function Maudes.initialize()
    AddTextEntry(PROMPT_KEY, "Press ~INPUT_CONTEXT~ to request a ~y~bounty~s~.")

    blip_id = exports.map:AddBlip(BLIP_LOC, {
        icon    = 78,
        display = 2,
        color   = 13,
        label   = "Maude's Trailer"
    })
end

function Maudes.cleanup()
    exports.map:RemoveBlip(blip_id)
    exports.markers:RemoveMarker(marker_id)
end

function Maudes.reset()
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
        on_enter       = show_prompt,
        on_interact    = show_offer,
        on_exit        = function()
            is_prompting = false
        end
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

-- @local
function show_offer()
    is_active = false

    exports.markers:RemoveMarker(marker_id)

    local progress = exports.progress:ShowProgressBar(2000, "Requesting Job")
    local history  = exports.map:GetPlayerHistory()

    if #history < 1 then
        exports.progress:CancelProgressBar(progress)

        TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
            message = "No jobs available right now. Check back later.",
            sender  = {
                image   = "CHAR_MAUDE",
                name    = "Maude",
                subject = "Bounty Hunting"
            }
        })

        Maudes.reset()

        return
    end

    local target = history[math.random(#history)].location

    TriggerServerEvent(Events.CREATE_BOUNTY_MISSION_OFFER, {
        location  = target,
        ui_target = GetCloudTimeAsInt() + 2000
    })
end
