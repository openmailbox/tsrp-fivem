local function create(_)
    TriggerClientEvent(Events.UPDATE_CHOP_MISSION_OFFER, source, {
        target   = "asea",
        delivery = vector3(0, 0, 0)
    })
end
RegisterNetEvent(Events.CREATE_CHOP_MISSION_OFFER, create)
