Hostage = {}

-- Forward declarations
local dist2d

local StateBehaviors = {
    WAITING = 1,
    FLEEING = 2
}

function Hostage:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Hostage:cleanup()
    local owner = nil

    if DoesEntityExist(self.entity) then
        owner = NetworkGetEntityOwner(self.entity)
    else
        owner = self.owner
    end

    TriggerClientEvent(Events.DELETE_NEW_HOSTAGE, owner, self)
end

function Hostage:fleeing()
    local new_position = GetEntityCoords(self.entity)

    if not self.position or dist2d(self.position, new_position) < 0.5 then
        -- TODO: If original hostage taker is not nearby, this might break
        self.position = new_position
        TaskReactAndFleePed(self.entity, GetPlayerPed(self.enactor))
        Entity(self.entity).state.interaction = false
    end
end

function Hostage:initialize()
    self.owner = NetworkGetEntityOwner(self.entity)
    TriggerClientEvent(Events.CREATE_NEW_HOSTAGE, self.owner, self)

    ClearPedTasks(self.entity)
    TaskHandsUp(self.entity, -1, self.enactor, -1, 1)
    Entity(self.entity).state.interaction = true

    self.initialized_at = GetGameTimer()
    self:move_to(StateBehaviors.WAITING)

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.DEBUG,
        message = "Hostage " .. self.entity .. " initialized."
    })
end

function Hostage:move_to(new_state)
    if self.state == new_state then return end

    TriggerEvent(Events.LOG_MESSAGE, {
        level = Logging.DEBUG,
        message = "Hostage " .. self.entity .. " moving to state " .. new_state .. "."
    })

    self.state          = new_state
    self.last_change_at = GetGameTimer()

    self:update()
end

-- Make a decision about what to do next
function Hostage:update(_)
    local owner = NetworkGetEntityOwner(self.entity)

    if owner ~= self.owner then
        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.DEBUG,
            message = "Hostage " .. self.entity .. " is migrating owners to Player " .. owner .. "."
        })

        self.owner = owner
    end

    if self.state == StateBehaviors.WAITING then
        self:waiting()
    elseif self.state == StateBehaviors.FLEEING then
        self:fleeing()
    end
end

function Hostage:waiting()
    if GetGameTimer() > self.last_change_at + 5000 then
        self:move_to(StateBehaviors.FLEEING)
    end
end

-- @local
function dist2d(p1, p2)
    return math.sqrt((p1.x - p2.x) ^ 2 + (p1.y - p2.y) ^ 2)
end
