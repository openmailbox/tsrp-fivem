local function respawn()
    exports.spawnmanager:forceRespawn()
end
RegisterNetEvent(Events.CREATE_RESPAWN, respawn)

local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    exports.spawnmanager:setAutoSpawnCallback(function()
        local location = SpawnPoints[math.random(1, #SpawnPoints)]

        SwitchOutPlayer(PlayerPedId(), 0, 1)

        exports.spawnmanager:spawnPlayer({
            x        = location.x,
            y        = location.y,
            z        = location.z,
            skipFade = false
        }, function(_)
            ClearPedBloodDamage(PlayerPedId())
            SwitchInPlayer(PlayerPedId())
        end)

        TriggerEvent("logging:CreateMessage", {
            level   = Logging.DEBUG,
            message = "Spawning player at " .. vector3(location.x, location.y, location.z) .. "."
        })
    end)
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)
