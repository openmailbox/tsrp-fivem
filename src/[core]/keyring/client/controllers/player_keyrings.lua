local function update(data)
    Keyring.update(data.keys)
end
RegisterNetEvent(Events.UPDATE_PLAYER_KEYRING, update)
