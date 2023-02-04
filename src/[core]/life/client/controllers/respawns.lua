local function respawn()
    local location = SpawnPoints[math.random(1, #SpawnPoints)]
    local player   = PlayerId()
    local ped      = PlayerPedId()
    local x, y, z  = table.unpack(vector3(location.x, location.y, location.z))
    local timeout  = GetGameTimer() + 5000

    SwitchOutPlayer(ped, 0, 1)

    if IsScreenFadedOut() then
        DoScreenFadeIn(1000)
    end

    repeat
        Citizen.Wait(250)
    until IsScreenFadedIn()

    SetPlayerControl(player, false, 0)
    SetPlayerInvincible(player, true)
    ClearPlayerWantedLevel(player)

    SetEntityVisible(ped, false)
    SetEntityCollision(ped, false)
    FreezeEntityPosition(ped, true)
    ClearPedTasksImmediately(ped)

    RequestCollisionAtCoord(x, y, z)
    SetEntityCoordsNoOffset(ped, x, y, z, false, false, false)
    NetworkResurrectLocalPlayer(x, y, z, 0, true, true)
    RemoveAllPedWeapons(ped)
    ClearPedBloodDamage(ped)

    while (not HasCollisionLoadedAroundEntity(ped) and GetGameTimer() < timeout) do
        Citizen.Wait(1000)
    end

    SetPlayerControl(player, true, 0)
    SetPlayerInvincible(player, false)

    SetEntityVisible(ped, true)
    SetEntityCollision(ped, true)
    FreezeEntityPosition(ped, false)

    SwitchInPlayer(ped)

    local life = LifeCycle:new()
    life:begin()

    TriggerEvent("logging:CreateMessage", {
        level   = Logging.DEBUG,
        message = "Spawning player at " .. vector3(location.x, location.y, location.z) .. "."
    })
end
RegisterNetEvent(Events.CREATE_RESPAWN, respawn)
