local function create(_)
    Interaction.clear_exclusions()
end
AddEventHandler(Events.ON_PLAYER_SPAWNED, create)
