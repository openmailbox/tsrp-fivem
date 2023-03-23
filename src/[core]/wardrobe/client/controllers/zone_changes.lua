local function on_new_zone(data)
    local old_store = data.old_zone and Store.find_by_name(data.old_zone.name)
    local new_store = data.zone and Store.find_by_name(data.zone.name)

    if not old_store and not new_store then return end

    local message = ""

    if old_store then
        Store.exit()
        message = "You left the ~y~" .. old_store.category .. "~s~."
    end

    if new_store then
        Store.enter(new_store)
        message = "You entered a ~y~" .. new_store.category .. "~s~."
    end

    TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
        message = message
    })
end
AddEventHandler(Events.ON_NEW_PLAYER_ZONE, on_new_zone)
