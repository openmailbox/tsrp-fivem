local function delete(_)
    local player = source
    Instance.set_player(player, nil)
end
AddEventHandler(Events.ON_PLAYER_DROPPED, delete)
