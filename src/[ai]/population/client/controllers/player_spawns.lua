local function on_spawn(_)
    SetCreateRandomCops(true)
    SetCreateRandomCopsNotOnScenarios(true)
    SetCreateRandomCopsOnScenarios(true)
end
AddEventHandler(Events.ON_PLAYER_SPAWNED, on_spawn)

local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    on_spawn()
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)
