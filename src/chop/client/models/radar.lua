Radar = {}

-- Forward declarations
local update

local HELP_KEY = 'ChopRadarHelp'

local contacts  = {}
local is_active = false

function Radar.activate(model_hash)
    if is_active then return end
    is_active = true

    BeginTextCommandDisplayHelp(HELP_KEY)
    EndTextCommandDisplayHelp(0, false, true, -1)

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.DEBUG,
        message = "Enabled radar for tracking target vehicles."
    })

    Citizen.CreateThread(function()
        while is_active do
            update(model_hash)
            Citizen.Wait(3000)
        end

        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.DEBUG,
            message = "Disabled vehicle tracking radar."
        })
    end)
end

function Radar.deactivate()
    is_active = false
end

function Radar.initialize()
    AddTextEntry(HELP_KEY, "Nearby ~y~target vehicles ~HUD_COLOR_REDLIGHT~~BLIP_GUNCAR~~s~ are shown on your map.")
end

-- @local
function update(model_hash)
    local pool = GetGamePool("CVehicle")

    for entity, contact in pairs(contacts) do
        if not DoesEntityExist(entity) then
            exports.map:RemoveBlip(contact.blip_id)
            contacts[entity] = nil
        end
    end

    for _, v in ipairs(pool) do
        if not contacts[v] and GetEntityModel(v) == model_hash then
            local blip_id = exports.map:StartEntityTracking(v, {
                icon    = 229,
                color   = 6,
                display = 2,
                label   = "Target Vehicle"
            })

            contacts[v] = {
                blip_id = blip_id,
            }
        end
    end
end
