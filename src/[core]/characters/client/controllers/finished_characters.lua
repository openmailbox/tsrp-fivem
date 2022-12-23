local function update(_)
    SelectSession.resolve()
end
RegisterNetEvent(Events.UPDATE_FINISHED_CHARACTER, update)
