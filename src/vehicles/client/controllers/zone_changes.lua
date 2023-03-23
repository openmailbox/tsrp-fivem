local function on_new_zone(data)
    local old_dealer = data.old_zone and Dealer.find_by_name(data.old_zone.name)
    local new_dealer = data.zone and Dealer.find_by_name(data.zone.name)

    if not old_dealer and not new_dealer then return end

    local message = ""

    if old_dealer then
        message = "You left the ~y~Vehicle Dealer~s~."
        old_dealer:exit()
    end

    if new_dealer then
        message = "You entered a ~y~Vehicle Dealer~s~."
        new_dealer:enter()
    end

    TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
        message = message
    })
end
AddEventHandler(Events.ON_NEW_PLAYER_ZONE, on_new_zone)
