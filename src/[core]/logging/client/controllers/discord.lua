local function create(message)
    TriggerServerEvent(Events.CREATE_DISCORD_LOG, message)
end
AddEventHandler(Events.CREATE_DISCORD_LOG, create)
