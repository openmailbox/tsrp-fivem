Event = {}

-- Forward declarations
local closest_player,
      distance,
      spawn_stash

-- Center of a circular area
local EVENT_LOCATIONS = {
    {
        center = vector3(-1109.4373, 4924.5083, 218.5466), -- cultist camp
        size   = 100.0
    }
}

-- Never generate more than this number of events at one time
local MAX_EVENTS = 1

local STASH_MODEL = GetHashKey('prop_mil_crate_01')

local events    = {}     -- All active events on the map right now
local is_active = false  -- Control variable for the update loop
local next_id   = 1      -- Internal tracking

function Event.check_and_init()
    if #events >= MAX_EVENTS then return end

    local location = EVENT_LOCATIONS[math.random(#EVENT_LOCATIONS)]
    local event    = Event:new({ location = location, id = next_id })

    Citizen.Trace("Starting Event " .. event.id .. " at " .. location.center .. ".\n")

    next_id = next_id + 1
    table.insert(events, event)
    event:initialize()

    if is_active then return end
    is_active = true

    Citizen.CreateThread(function()
        while is_active do
            for _, e in ipairs(events) do
                e:update()
            end

            Citizen.Wait(10000)
        end
    end)
end

function Event.cleanup()
    is_active = false

    for _, event in ipairs(events) do
        RemoveBlip(event.blip)

        if DoesEntityExist(event.stash) then
            DeleteEntity(event.stash)
        end
    end

    events = {}
end

function Event.find_by_id(id)
    for _, e in ipairs(events) do
        if e.id == id then
            return e
        end
    end

    return nil
end

function Event.from_point(x, y)
    local matches = {}

    for _, event in ipairs(events) do
        if event:contains(x, y) then
            table.insert(matches, event)
        end
    end

    return matches
end

function Event:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Event:contains(x, y)
    local x_min = self.location.center.x - (self.location.size / 2)
    local x_max = self.location.center.x + (self.location.size / 2)

    if x < x_min or x > x_max then
        return false
    end

    local y_min = self.location.center.y - (self.location.size / 2)
    local y_max = self.location.center.y + (self.location.size / 2)

    if y < y_min or y > y_max then
        return false
    end

    return true
end

function Event:initialize()
    TriggerClientEvent(Events.CREATE_STASH_EVENTS, -1, {
        events = { self }
    })
end

function Event:update()
    if not DoesEntityExist(self.stash) then
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
function spawn_stash(event)
    local player = closest_player(event.location.center)
    if not player then return end

    TriggerClientEvent(Events.CREATE_STASH_OBJECT, player, {
        model = STASH_MODEL,
        event = event
    })
end
