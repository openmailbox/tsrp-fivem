local function delete(data)
    StoreSafe.open(data.id, data.completionType)
end
AddEventHandler(Events.DELETE_LOCKPICK_SESSION, delete)
