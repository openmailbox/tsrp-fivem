local function on_new_session(data)
    Keyring.initialize(data.player_id)
end
AddEventHandler(Events.ON_CHARACTER_SESSION_START, on_new_session)