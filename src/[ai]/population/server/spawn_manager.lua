SpawnManager = {}

local is_active = false
local spawns    = {}

function SpawnManager.add_spawn(options)
    local spawn = Spawn:new(options)
    spawn.uuid = GenerateUUID() -- defined in @common/shared/uuid

    table.insert(spawns, options)
end
exports("AddSpawn", SpawnManager.add_spawn)

function SpawnManager.cleanup()
    spawns = {}
end

function SpawnManager.initialize()
    is_active = true

    Citizen.CreateThread(function()
        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.DEBUG,
            message = "Population spawn manager updates starting."
        })

        while is_active do
            for _, spawn in ipairs(spawns) do
                spawn:update()
            end

            Citizen.Wait(10000)
        end

        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.DEBUG,
            message = "Population spawn manager updates stopping."
        })
    end)
end

function SpawnManager.remove_spawn(id)
end
exports("RemoveSpawn", SpawnManager.remove_spawn)
