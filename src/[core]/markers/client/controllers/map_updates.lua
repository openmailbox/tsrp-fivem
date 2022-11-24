local function update(data)
    Manager.update(data.coords)
end
AddEventHandler(Events.MAP_UPDATE_PLAYER, update)
