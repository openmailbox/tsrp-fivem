local function delete(_, cb)
    SetNuiFocus(false, false)
    cb({})
end
RegisterNUICallback(Events.DELETE_CHOP_MISSION_OFFER, delete)
