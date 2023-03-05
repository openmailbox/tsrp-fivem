Radar = {}

-- Forward declarations
local update

local HELP_KEY = 'ChopRadarHelp'
local RADIUS   = 225.0

local blip      = nil
local contacts  = {}
local is_active = false

function Radar.activate(options)
    if is_active then return end
    is_active = true

    BeginTextCommandDisplayHelp(HELP_KEY)
    EndTextCommandDisplayHelp(0, false, true, -1)

    Logging.log(Logging.DEBUG, "Enabled radar for tracking target vehicles.")

    blip = exports.map:AddBlip(options.spawn, {
        color   = 6,
        alpha   = 125,
        display = 2,
        radius  = RADIUS
    })

    local x, y, _ = table.unpack(options.spawn)
    SetNewWaypoint(x, y)

    Citizen.CreateThread(function()
        while is_active do
            update(options.model)
            Citizen.Wait(2000)
        end

        Logging.log(Logging.DEBUG, "Disabled vehicle tracking radar.")
    end)
end

function Radar.deactivate()
    is_active = false
    exports.map:RemoveBlip(blip)

    for entity, contact in pairs(contacts) do
        exports.map:RemoveBlip(contact.blip_id)
        contacts[entity] = nil
    end
end

function Radar.initialize()
    AddTextEntry(HELP_KEY, "Look for ~HUD_COLOUR_REDLIGHT~target vehicles ~BLIP_GUNCAR~~s~ nearby. The ~HUD_COLOUR_REDLIGHT~highlighted area~s~ on your map is where you last saw the model.")
end

-- @local
function update(model_hash)
    for entity, contact in pairs(contacts) do
        if not DoesEntityExist(entity) then
            exports.map:RemoveBlip(contact.blip_id)
            contacts[entity] = nil
        end
    end

    local pool       = GetGamePool("CVehicle")
    local model_name = GetDisplayNameFromVehicleModel(model_hash)

    for _, v in ipairs(pool) do
        local vmodel = GetEntityModel(v)
        local vname  = GetDisplayNameFromVehicleModel(vmodel)

        if not contacts[v] and vname == model_name then
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
