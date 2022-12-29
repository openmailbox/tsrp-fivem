local DEBOUNCE = 1000

local last_at = 0

local function on_event(targets, enactor, _)
    if enactor ~= PlayerPedId() then return end

    local target = targets[1]

    if IsPedAPlayer(target) then return end

    -- Only locals who were going to flee anyways are hostage candidates.
    if not IsPedFleeing(target) then return end

    -- TODO: Handle this as a special case
    if IsPedInAnyVehicle(target) then return end

    local time = GetGameTimer()
    if time < last_at + DEBOUNCE then return end
    last_at = time

    TriggerServerEvent(Events.CREATE_NEW_HOSTAGE, {
        target_net_id = PedToNet(target)
    })
end
AddEventHandler(Events.CLIENT_GUN_AIMED_AT, on_event)
