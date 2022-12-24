local POSITION = vector3(-802.5900, 172.6235, 72.8446) -- Michael's house living room
local HEADING  = 90.0

local function create(_, cb)
    local ped     = PlayerPedId()
    local x, y, z = table.unpack(POSITION)

    DoScreenFadeOut(1500)
    repeat
        Citizen.Wait(100)
    until IsScreenFadedOut()

    Roster.hide()

    SetEntityCollision(ped, true)
    FreezeEntityPosition(ped, false)
    SetEntityCoordsNoOffset(ped, x, y, z)
    SetEntityHeading(ped, HEADING)
    SetEntityVisible(ped, true)
    SetNuiFocus(false, false)

    Citizen.Wait(500)
    DoScreenFadeIn(1500)

    TriggerEvent(Events.CREATE_WARDROBE_SESSION)
    cb({})
end
RegisterNUICallback(Events.CREATE_NEW_CHARACTER, create)

-- Triggered when the player cancelled out of submitting new character details
local function delete(_, cb)
    SelectSession.set_new_character(nil)
    SelectSession.resolve()
    cb({})
end
RegisterNUICallback(Events.DELETE_NEW_CHARACTER, delete)
