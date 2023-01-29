local DEBOUNCE       = 1500
local REGISTER_MODEL = GetHashKey('prop_till_01')

local last_at = 0

local function on_event(victim, culprit, weapon, damage)
    if GetEntityModel(victim) ~= REGISTER_MODEL then return end

    local time = GetGameTimer()
    if time < last_at + DEBOUNCE then return end

    last_at = time

    if not NetworkGetEntityIsNetworked(victim) then
        NetworkRegisterEntityAsNetworked(victim)
    end

    local net_id = ObjToNet(victim)

    SetNetworkIdCanMigrate(net_id)

    TriggerServerEvent(Events.CREATE_DAMAGED_HEIST_OBJECT, {
        culprit     = culprit,
        weapon_hash = weapon,
        damage      = damage,
        victim      = {
            net_id   = net_id,
            location = GetEntityCoords(victim)
        }
    })
end
AddEventHandler(Events.ON_ENTITY_DAMAGED, on_event)
