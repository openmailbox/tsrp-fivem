Stash = {}

local STASH_LOCATIONS = {
    vector3(0, 0, 0)
}

-- Never generate more than this number of stashes at one time
local MAX_STASHES = 1

-- All active stashes on the map right now
local stashes = {}

function Stash.check_and_spawn()
    if #stashes >= MAX_STASHES then return end

    local location = STASH_LOCATIONS[math.random(#STASH_LOCATIONS)]
end

function Stash:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end
