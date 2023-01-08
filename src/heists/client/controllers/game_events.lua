local DEBOUNCE       = 1500
local REGISTER_MODEL = GetHashKey('prop_till_01')

local last_at = 0

local function on_event(victim, culprit, weapon, damage)
    if GetEntityModel(victim) ~= REGISTER_MODEL then return end

    local time = GetGameTimer()

    if time < last_at + DEBOUNCE then return end

    last_at = time

    TriggerServerEvent(Events.CREATE_DAMAGED_HEIST_OBJECT, {
        culprit     = culprit,
        weapon_hash = weapon,
        damage      = damage,
        victim      = {
            net_id   = (NetworkGetEntityIsNetworked(victim) and ObjToNet(victim)) or 0,
            location = GetEntityCoords(victim),
            model    = GetEntityModel(victim)
        }
    })
end
AddEventHandler(Events.ON_ENTITY_DAMAGED, on_event)
