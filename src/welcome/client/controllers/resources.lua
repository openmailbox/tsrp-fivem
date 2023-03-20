local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    MainMenu.start()
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)
