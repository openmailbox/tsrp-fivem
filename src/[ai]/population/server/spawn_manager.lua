SpawnManager = {}

local spawns = {}

function SpawnManager.add_spawn(options)
    local spawn = Spawn:new(options)

    spawn:initialize()
    table.insert(spawns, spawn)

    return spawn.id, spawn.entity
end
exports("AddSpawn", SpawnManager.add_spawn)

function SpawnManager.cleanup()
    for _, spawn in ipairs(spawns) do
        spawn:cleanup()
    end

    spawns = {}
end

function SpawnManager.remove_spawn(id)
    for i, spawn in ipairs(spawns) do
        if spawn.id == id then
            spawn:cleanup()
            table.remove(spawns, i)
            return true
        end
    end

    return false
end
exports("RemoveSpawn", SpawnManager.remove_spawn)
