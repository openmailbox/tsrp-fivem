LestersHouse = {}

-- Forward declarations
local find_stash,
      hide_marker,
      show_marker,
      show_prompt

local BLIP_LABEL = "Lester's House"
local BLIP_LOC   = vector3(1275.7319, -1710.5321, 54.7714)
local HELP_KEY   = 'LestersStashHelp'
local PROMPT_KEY = 'LestersStashPrompt'

local is_active    = false
local is_prompting = false

function LestersHouse.cleanup()
    exports.map:RemoveBlip(BLIP_LABEL)
    exports.markers:RemoveMarker(BLIP_LOC)
end

function LestersHouse.initialize()
    AddTextEntry(HELP_KEY, "Lester hid several ~y~supply stashes ~HUD_COLOUR_YELLOW~~BLIP_NHP_CHEST~~s~ around the state. Stop by his house when you need help finding one.")
    AddTextEntry(PROMPT_KEY, "Press ~INPUT_CONTEXT~ to locate a hidden stash.")

    exports.map:AddBlip(BLIP_LABEL, BLIP_LOC, {
        icon  = 77,
        color = 47
    })
end

function LestersHouse.reset()
    if is_active then return end
    is_active = true
    show_marker()
end

-- @local
function find_stash()
    is_prompting = false

    hide_marker()

    exports.progress:ShowProgressBar(2000, "Downloading")

    Citizen.CreateThread(function()
        Citizen.Wait(1800)

        BeginTextCommandDisplayHelp(HELP_KEY)
        EndTextCommandDisplayHelp(0, false, true, -1)

        local stash = Stash.random()
        stash:show()

        SetNewWaypoint(stash.location.x, stash.location.y)
    end)
end

-- @local
function hide_marker()
    exports.markers:RemoveMarker(BLIP_LOC)
    is_active = false
end

-- @local
function show_marker()
    exports.markers:AddMarker({
        icon           = 32,
        coords         = BLIP_LOC,
        red            = 255,
        green          = 255,
        face_camera    = true,
        scale          = vector3(0.2, 0.2, 0.2),
        blue           = 0,
        interact_range = 1.0,
        on_enter       = show_prompt,
        on_interact    = find_stash,
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
