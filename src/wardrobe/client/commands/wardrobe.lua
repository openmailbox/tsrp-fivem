local function cmd_wardrobe(_, _, _)
    TriggerEvent(Events.CREATE_WARDROBE_SESSION)
end
RegisterCommand("wardrobe", cmd_wardrobe, false)
