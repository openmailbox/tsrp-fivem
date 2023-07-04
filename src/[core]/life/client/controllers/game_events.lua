local TYPES = {
    [0] = "nothing",
    [1] = "ped",
    [2] = "vehicle",
    [3] = "object"
}

local function on_event(name, args)
    if name ~= Events.CLIENT_ENTITY_DAMAGE then return end

    local victim    = args[1]
    local was_fatal = args[6] == 1

    if was_fatal and victim == PlayerPedId() then
        local attacker = args[2] -- same as GetPedSourceOfDeath()
        local weapon   = args[7]
        local melee    = args[12] == 1
        local cause    = nil

        if attacker > -1 then
            cause = TYPES[GetEntityType(attacker)]
        elseif IsEntityInWater(PlayerPedId()) then
            cause = "drowning"
        else
            cause = "falling"
        end

        TriggerServerEvent(Events.CREATE_DEATH_EVENT, {
            cause            = cause,
            killer_net_id    = attacker > -1 and NetworkGetNetworkIdFromEntity(attacker),
            killer_player_id = IsPedAPlayer(attacker) and GetPlayerServerId(attacker),
            weapon           = weapon,
            melee            = melee
        })
    end
end
AddEventHandler(Events.ON_GAME_EVENT, on_event)
