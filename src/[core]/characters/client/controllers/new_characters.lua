local function create(_, cb)
    -- TODO: Prepare ped
    TriggerEvent(Events.CREATE_WARDROBE_SESSION)
    cb({})
end
RegisterNUICallback(Events.CREATE_NEW_CHARACTER, create)
