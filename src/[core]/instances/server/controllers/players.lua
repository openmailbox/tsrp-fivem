local function delete(_)
    local player = source
    Instance.set_player(player, nil)
end
AddEventHandler(Events.PLAYER_DISCONNECT, delete)
