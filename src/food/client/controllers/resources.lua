local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    Citizen.CreateThread(function()
        local current_health, max_health
        local active = false

        while true do
            current_health = GetEntityHealth(PlayerPedId())
            max_health     = GetEntityMaxHealth(PlayerPedId())

            if not active and current_health < max_health then
                active = true
                WorldObject.activate()
            elseif active and current_health >= max_health then
                active = false
                WorldObject.deactivate()
            end

            Citizen.Wait(1500)
        end
    end)
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)
