Target = {}

Target.Behaviors = {
    FLEEING = 1
}

-- Forward delcarations
local approaching,
      chasing,
      find_victim,
      highlight_target,
      searching,
      start_updates

local RADIUS = 225.0

local current   = {}
local is_active = false

function Target.cleanup()
    for _, target in ipairs(current) do
        target:deactivate()
    end

    current = {}
end

function Target.find_by_id(id)
    for _, target in ipairs(current) do
        if target.id == id then
            return target
        end
    end

    return nil
end

-- Called when preparing a new mission offer for the player.
function Target.add_new(data)
    local target = Target:new({
        vicinity = data.location,
        id       = data.id
    })

    table.insert(current, target)

    return target
end

function Target:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

-- Called after player accepts the mission.
function Target:activate()
    TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
        message = "You'll get paid once it's done.",
        sender  = {
            image   = "CHAR_MAUDE",
            name    = "Maude",
            subject = "Job"
        }
    })

    TriggerEvent(Events.CREATE_HUD_HELP_MESSAGE, {
        message = "Search the ~HUD_COLOUR_PURPLELIGHT~highlighted area~s~ on your map for the target ~HUD_COLOUR_PURPLELIGHT~~BLIP_BOUNTY_HIT~~s~."
    })

    self.next_update = searching

    self.area_blip = exports.map:AddBlip(self.vicinity, {
        color   = 13,
        alpha   = 125,
        display = 2,
        radius  = RADIUS
    })

    self.search_blip = exports.map:AddBlip(self.vicinity, {
        color   = 13,
        icon    = 303,
        display = 2,
        label   = "Bounty Search Area"
    })

    local x, y, _ = table.unpack(self.vicinity)
    SetNewWaypoint(x, y)

    start_updates()
end

function Target:deactivate()
    self.next_update = nil
    exports.map:RemoveBlip(self.area_blip)
    exports.map:RemoveBlip(self.victim_blip)
    exports.map:RemoveBlip(self.search_blip)
    SetEntityAsNoLongerNeeded(self.victim)
end

function Target:flee()
    TriggerServerEvent(Events.CREATE_BOUNTY_TARGET_BEHAVIOR, {
        net_id    = PedToNet(self.victim),
        behavior  = Target.Behaviors.FLEEING,
        my_net_id = PedToNet(PlayerPedId())
    })

    TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
        message = "The ~HUD_COLOUR_PURPLELIGHT~target~s~ was alerted and ~r~fled~s~."
    })

    self.next_update = chasing
end

function Target:set_victim(entity)
    self.victim      = entity
    self.next_update = approaching

    exports.map:RemoveBlip(self.search_blip)
    exports.map:RemoveBlip(self.area_blip)

    self.victim_blip = exports.map:StartEntityTracking(self.victim, {
        icon      = 303,
        color     = 13,
        display   = 2,
        label     = "Bounty Target",
        always_on = true
    })

    highlight_target(self.victim)

    TriggerEvent(Events.CREATE_HUD_HELP_MESSAGE, {
        message = "The ~HUD_COLOUR_PURPLELIGHT~bounty target~BLIP_BOUNTY_HIT~~s~ has been revealed on your map."
    })

    TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
        message = "You located the ~HUD_COLOUR_PURPLELIGHT~bounty target~s~."
    })
end

-- @local
function approaching(target)
    local me = PlayerPedId()

    if Vdist(GetEntityCoords(me), GetEntityCoords(target.victim)) < 20.0 and HasEntityClearLosToEntity(me, target.victim, 17) then
        target:flee()
    elseif not DoesEntityExist(target.victim) then
        TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
            message = "The ~HUD_COLOUR_PURPLELIGHT~bounty target~s~ got away."
        })

        target:deactivate()
    end
end

-- @local
function chasing(target)
    if IsPedDeadOrDying(target.victim, true) then
        TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
            message = "The ~HUD_COLOUR_PURPLELIGHT~bounty target~s~ was eliminated."
        })

        TriggerServerEvent(Events.CREATE_BOUNTY_PAYOUT)

        target:deactivate()
    elseif not DoesEntityExist(target.victim) then
        TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
            message = "The ~HUD_COLOUR_PURPLELIGHT~bounty target~s~ got away."
        })
        target:deactivate()
    end
end

-- @local
function find_victim(origin)
    local pool       = GetGamePool("CPed")
    local candidates = {}
    local ped        = PlayerPedId()

    for _, entity in ipairs(pool) do
        if entity ~= ped and Vdist(GetEntityCoords(entity), origin) < RADIUS and not IsPedInAnyVehicle(entity, true) then
            table.insert(candidates, entity)
        end
    end

    if #candidates == 0 then
        return nil
    end

    local winner = candidates[math.random(#candidates)]

    SetEntityAsMissionEntity(winner, true, true)

    return winner
end

-- @local
function highlight_target(entity)
    Citizen.CreateThread(function()
        local vzero    = vector3(0, 0, 0)
        local rotation = vector3(180.0, 0, 0)
        local scale    = vector3(0.2, 0.2, 0.2)
        local offset   = vector3(0, 0, 0.9)
        local loc

        while DoesEntityExist(entity) and not IsPedDeadOrDying(entity, true) do
            loc = GetOffsetFromEntityInWorldCoords(entity, offset)

            DrawMarker(2,
                       loc,
                       vzero,
                       rotation,
                       scale,
                       192, 179, 239, 255,
                       false,
                       false,
                       2,
                       true,
                       nil,
                       nil,
                       false)

            Citizen.Wait(0)
        end
    end)
end

-- @local
function searching(target)
    local ploc = GetEntityCoords(PlayerPedId())

    if Vdist(ploc, target.vicinity) < RADIUS then
        local victim = find_victim(ploc)

        if victim then
            target:set_victim(victim)
        end
    end
end

-- @local
function start_updates()
    if is_active then return end
    is_active = true

    local update_count

    Citizen.CreateThread(function()
        TriggerEvent(Events.LOG_MESSAGE, { level = Logging.DEBUG, message = "Start bounty mission update loop." })

        while is_active do
            update_count = 0

            for _, target in ipairs(current) do
                if target.next_update then
                    update_count = update_count + 1
                    target:next_update(target)
                end
            end

            if update_count == 0 then
                is_active = false
            end

            Citizen.Wait(2000)
        end

        Maudes.reset()

        TriggerEvent(Events.LOG_MESSAGE, { level = Logging.DEBUG, message = "Stop bounty mission update loop." })
    end)
end
