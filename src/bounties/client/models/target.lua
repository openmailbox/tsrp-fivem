Target = {}

Target.Behaviors = {
    FLEEING = 1
}

-- Forward delcarations
local approaching,
      chasing,
      find_victim,
      searching

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

    self.next_update = searching
    self.area_blip   = exports.map:AddBlip(self.vicinity, {
        color   = 13,
        alpha   = 125,
        display = 2,
        radius  = RADIUS
    })

    local x, y, _ = table.unpack(self.vicinity)
    SetNewWaypoint(x, y)

    if is_active then return end

    local ploc, update_count

    Citizen.CreateThread(function()
        ploc         = GetEntityCoords(PlayerPedId())
        update_count = 0

        TriggerEvent(Events.LOG_MESSAGE, { level = Logging.DEBUG, message = "Start bounty mission update loop." })

        while is_active do
            for _, target in ipairs(current) do
                if target.next_update then
                    update_count = update_count + 1
                    target:next_update(target, ploc)
                end
            end

            if update_count == 0 then
                is_active = false
            end

            Citizen.Wait(2000)
        end

        TriggerEvent(Events.LOG_MESSAGE, { level = Logging.DEBUG, message = "Stop bounty mission update loop." })
    end)
end

function Target:deactivate()
    self.next_update = nil
    exports.map:RemoveBlip(self.area_blip)
    exports.map:RemoveBlip(self.victim_blip)
end

function Target:flee()
    TriggerServerEvent(Events.CREATE_BOUNTY_TARGET_BEHAVIOR, {
        net_id    = PedToNet(self.victim),
        behavior  = Target.Behaviors.FLEEING,
        my_net_id = PedToNet(PlayerPedId())
    })

    TriggerEvent(Events.CREATE_HUD_NOTIFICATION, {
        message = "The ~HUD_COLOUR_PURPLELIGHT~target~s~ saw you and ~r~fled~s~."
    })

    self.next_update = chasing
end

function Target:set_victim(entity)
    self.victim = entity

    self.victim_blip = exports.map:StartEntityTracking(self.victim, {
        icon    = 303,
        color   = 13,
        display = 2,
        label   = "Bounty Target"
    })

    TriggerEvent(Events.CREATE_HUD_HELP_MESSAGE, {
        message = "The ~HUD_COLOUR_PURPLELIGHT~bounty target ~BLIP_BOUNTY_HIT~~s~ has been revealed on your map."
    })

    self.next_update = approaching
end

-- @local
function approaching(target, ploc)
    if Vdist(ploc, GetEntityCoords(target.entity)) < 20.0 then
        target:flee()
    end
end

-- @local
function chasing(target, ploc)
    if not DoesEntityExist(target.victim) then
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

    for _, entity in ipairs(pool) do
        if Vdist(GetEntityCoords(entity), origin) < RADIUS and not IsPedInAnyVehicle(entity, true) then
            table.insert(candidates, entity)
        end
    end

    if #candidates == 0 then
        return nil
    end

    return candidates[math.random(#candidates)]
end

-- @local
function searching(target, ploc)
    if Vdist(ploc, target.vicinity) < RADIUS then
        local victim = find_victim(ploc)

        if victim then
            target:set_victim(victim)
        end
    end
end
