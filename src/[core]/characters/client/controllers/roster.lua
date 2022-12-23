local function update(data)
    Roster.update(data.characters)
end
RegisterNetEvent(Events.UPDATE_CHARACTER_ROSTER, update)
