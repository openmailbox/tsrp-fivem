local function respawn()
    exports.spawnmanager:setAutoSpawnCallback(function()
        local location = SpawnPoints[math.random(1, #SpawnPoints)]

        exports.spawnmanager:spawnPlayer({
            x        = location.x,
            y        = location.y,
            z        = location.z,
            model    = PedModels[math.random(1, #PedModels)],
            skipFade = false
        }, function(_)
            SetPedRandomComponentVariation(PlayerPedId(), 0)
            ClearPedBloodDamage(PlayerPedId())
        end)
    end)

    exports.spawnmanager:setAutoSpawn(true)
    exports.spawnmanager:forceRespawn()
end
RegisterNetEvent(Events.CREATE_RESPAWN, respawn)

local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end
    respawn()
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)
