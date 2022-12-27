Instance = {}

-- Forward declarations
local claim_bucket

local MAX_BUCKETS = 63

local bucket_ids = {} -- dict to keep track of which routing buckets are in use
local instances  = {} -- dict to keep track of active instances by label
local players    = {} -- dict to keep track of active instances by player ID

for i = 1, MAX_BUCKETS do
    bucket_ids[i] = false
end

--- Place player inside specified instance. If a label is not passed, the player is
--- removed from their current instance, if there is one.
-- @tparam number player_id the player's server ID
-- @tparam string label an optional instance label
-- @treturn boolean success or failure
function Instance.set_player(player_id, label)
    -- nil means we're removing player from any instance they might be in
    if not label then
        local instance = players[player_id]

        if instance then
            players[player_id] = nil
            return instance:remove_player(player_id)
        else
            return false
        end
    end

    local instance = instances[label]

    if not instance then
        local bucket_id = claim_bucket()

        -- We ran out of buckets
        if bucket_id < 0 then
            return false
        end

        instance = Instance:new({
            bucket_id = bucket_id,
            label     = label,
            players   = {}
        })

        instances[label] = instance

        Citizen.Trace("Initialized instance '" .. label .. "' with bucket " .. bucket_id .. ".\n")
    end

    instance:add_player(player_id)

    return true
end
exports("SetPlayerInstance", Instance.set_player)

function Instance:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Instance:add_player(player_id)
    players[player_id] = self

    table.insert(self.players, player_id)
    SetPlayerRoutingBucket(player_id, self.bucket_id)

    Citizen.Trace("Added Player " .. player_id .. " to instance '" .. self.label .. "'.\n")
end

function Instance:remove_player(player_id)
    for i, id in ipairs(self.players) do
        if id == player_id then
            table.remove(self.players, i)

            SetPlayerRoutingBucket(player_id, 0)
            Citizen.Trace("Removed Player " .. player_id .. " from instance '" .. self.label .. "'.\n")

            if #self.players == 0 then
                bucket_ids[self.bucket_id] = false
                instances[self.label] = nil
                Citizen.Trace("Removed empty instance '" .. self.label .. "' for bucket " .. self.bucket_id .. ".\n")
            end

            return true
        end
    end

    return false
end

-- @local
function claim_bucket()
    for id, occupied in pairs(bucket_ids) do
        if not occupied then
            bucket_ids[id] = true
            return id
        end
    end

    return -1
end
