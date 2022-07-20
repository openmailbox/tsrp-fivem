Stash = {}

-- Forward declarations
local closest_player,
      distance,
      spawn_stash

local stashes = {} -- Name->Stash map of all stashes in the game

function Stash.all()
    return stashes
end

function Stash:can_open(player_id)
    -- TODO: Limit to once per restart per player
    return true
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

-- Generates the options that will be presented to the player.
function Stash.generate_contents(stash)
    -- Non-placed stashes using the same object models give a minor reward.
    if not stash then
        return {
            { cash = math.random(5, 75) }
        }
    end

    local contents = {}

    for _, option in ipairs(stash.contents) do
        if option.cash then
            table.insert(contents, option)
        elseif option.weapon then
            local selection = option.weapon[math.random(1, #option.weapon)]
            table.insert(contents, { weapon = selection })
        end
    end

    return contents
end

function Stash.initialize()
    for name, data in pairs(Stashes.Locations) do
        local stash = Stash:new(data)
        stash.name = name
        stashes[name] = stash
    end

    Citizen.CreateThread(function()
        while true do
            for _, stash in pairs(stashes) do
                stash:update()
            end

            Citizen.Wait(10000)
        end
    end)

    TriggerClientEvent(Events.UPDATE_STASHES, -1, {
        stashes = stashes
    })
end

function Stash:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Stash:open(player_id)
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
