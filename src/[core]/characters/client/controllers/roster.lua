local function update(data)
    Roster.update(data.characters)
    SelectSession.resolve()
end
RegisterNetEvent(Events.UPDATE_CHARACTER_ROSTER, update)
