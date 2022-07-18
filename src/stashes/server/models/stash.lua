Stash = {}

-- Forward declarations
local closest_player,
      distance,
      spawn_stash

local stashes = {} -- Name->Stash map of all stashes in the game
local models  = {} -- Unique list of all object model hashes used for stashes

function Stash.models()
    return models
end

function Stash.cleanup()
    for _, stash in pairs(stashes) do
        if DoesEntityExist(stash.object_id) then
            DeleteEntity(stash.object_id)
        end
    end

    stashes = {}
end

function Stash.find_by_name(name)
    return stashes[name]
end

function Stash.initialize()
    local model_map = {}

    for name, data in pairs(Stashes) do
        local stash = Stash:new(data)
        stash.name = name

        model_map[stash.model] = true
        stashes[name]          = stash
    end

    for hash, _ in pairs(model_map) do
        table.insert(models, hash)
    end

    Citizen.CreateThread(function()
        while true do
            for _, stash in pairs(stashes) do
                stash:update()
            end

            Citizen.Wait(10000)
        end
    end)

    TriggerClientEvent(Events.UPDATE_STASH_MODELS, -1, models)
end

function Stash:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Stash:update()
    if not DoesEntityExist(self.object_id) then
        spawn_stash(self)
    end
end

-- @local
function closest_player(loc)
    local closest = 10000
    local player  = nil

    for _, p in ipairs(GetPlayers()) do
        local dist = distance(loc, GetEntityCoords(GetPlayerPed(p)))

        if dist < closest then
            closest = dist
            player  = p
        end
    end

    return player, closest
end

-- @local
function distance(p1, p2)
    return (p1.x - p2.x) ^ 2 + (p1.y - p2.y) ^ 2
end

-- @local
function spawn_stash(stash)
    local player = closest_player(stash.location)
    if not player then return end

    TriggerClientEvent(Events.CREATE_STASH_OBJECT, player, {
        stash = stash
    })
end
