local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    Interaction.look_for_targets()
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)
