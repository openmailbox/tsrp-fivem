local POSITION = vector3(-802.5900, 172.6235, 72.8446) -- Michael's house living room
local HEADING  = 289.1680

local function create(_, cb)
    local ped     = PlayerPedId()
    local x, y, z = table.unpack(POSITION)

    SetEntityCollision(ped, true)
    FreezeEntityPosition(ped, false)
    SetEntityCoordsNoOffset(ped, x, y, z)
    SetEntityHeading(ped, HEADING)
    SetEntityVisible(ped, true)

    TriggerEvent(Events.CREATE_WARDROBE_SESSION)
    cb({})
end
RegisterNUICallback(Events.CREATE_NEW_CHARACTER, create)
