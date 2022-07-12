local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    Interaction.look_for_targets()
end
AddEventHandler(Events.CREATE_CLIENT_RESOURCE, create)
