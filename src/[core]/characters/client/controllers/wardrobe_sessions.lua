local function delete(data)
    local session = SelectSession.get_active()
    if not session then return end

    if data.success then
        SelectSession.await()

        TriggerServerEvent(Events.CREATE_FINISHED_CHARACTER, {
            snapshot = data.snapshot
        })
    end

    SetNuiFocus(true, true)
    session:initialize()
end
AddEventHandler(Events.DELETE_WARDROBE_SESSION, delete)
