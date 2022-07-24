local first_spawn = true

local function create()
    if not first_spawn then return end
    first_spawn = false
    SetNuiFocus(true, true)
    SendNUIMessage({ type = Events.CREATE_WELCOME_SESSION })
end
AddEventHandler(Events.ON_PLAYER_SPAWNED, create)
