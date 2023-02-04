local Animation = { DICTIONARY = "clothingshirt", NAME = "try_shirt_positive_a" }

local function respawn(data)
    data = data or {}

    local location = data.location or SpawnPoints[math.random(1, #SpawnPoints)]
    local player   = PlayerId()
    local ped      = PlayerPedId()
    local x, y, z  = table.unpack(vector3(location.x, location.y, location.z))
    local timeout  = GetGameTimer() + 7000

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

    TriggerEvent("logging:CreateMessage", {
        level   = Logging.DEBUG,
        message = "Spawning player at " .. vector3(location.x, location.y, location.z) .. "."
    })

    RequestCollisionAtCoord(x, y, z)
    RequestAdditionalCollisionAtCoord(x, y, z)
    SetEntityCoordsNoOffset(ped, x, y, z + 0.3, false, false, false)
    NetworkResurrectLocalPlayer(x, y, z, 0, true, true)
    RemoveAllPedWeapons(ped)
    ClearPedBloodDamage(ped)

    repeat
        Citizen.Wait(1500)
    until (HasCollisionLoadedAroundEntity(ped) or GetGameTimer() > timeout)

    SetPlayerControl(player, true, 0)
    SetPlayerInvincible(player, false)

    SetEntityVisible(ped, true)
    SetEntityCollision(ped, true)
    FreezeEntityPosition(ped, false)

    if data.heading then
        SetEntityHeading(ped, data.heading)
    end

    SwitchInPlayer(ped)

    local life = LifeCycle:new()
    life:begin()

    if not HasAnimDictLoaded(Animation.DICTIONARY) then
        RequestAnimDict(Animation.DICTIONARY)

        repeat
            Citizen.Wait(10)
        until HasAnimDictLoaded(Animation.DICTIONARY)
    end

    TaskPlayAnim(PlayerPedId(), Animation.DICTIONARY, Animation.NAME, -3.0, 3.0, -1, 48, false, false, false)

    TriggerEvent(Events.ON_PLAYER_SPAWNED, {
        x       = location.x,
        y       = location.y,
        z       = location.z,
        heading = data.heading or 0,
    })
end
RegisterNetEvent(Events.CREATE_RESPAWN, respawn)
