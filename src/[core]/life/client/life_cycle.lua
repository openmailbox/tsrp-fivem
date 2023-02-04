LifeCycle = {}

local PROMPT_KEY = "LifeCyclePrompt"

local current = nil
local next_id = 0

function LifeCycle.get_current()
    return current
end

function LifeCycle.initialize()
    AddTextEntry(PROMPT_KEY, "You are incapacitated. Press ~INPUT_REPLAY_START_STOP_RECORDING~ to respawn.")

    Citizen.CreateThread(function()
        while true do
            if current then
                current:update()
            end

            Citizen.Wait(1000)
        end
    end)
end

function LifeCycle:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function LifeCycle:begin()
    if current then
        current:finish()
    end

    self.id       = next_id
    self.is_alive = not IsPlayerDead(PlayerId()) and not IsPedDeadOrDying(PlayerPedId())

    current = self
    next_id = next_id + 1

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.DEBUG,
        message = "Starting new lifecycle " .. self.id .. "."
    })
end

function LifeCycle:finish()
    current = nil

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.DEBUG,
        message = "Ending lifecycle " .. self.id .. "."
    })
end

function LifeCycle:kill()
    self.is_alive = false

    StartDeathCam()

    Citizen.CreateThread(function()
        while current == self and IsPedDeadOrDying(PlayerPedId(), 1) do
            DisplayHudWhenDeadThisFrame()
            DisplayHelpTextThisFrame(PROMPT_KEY, 0)
            ProcessCamControls()

            if IsControlJustPressed(0, 288) then -- F1
                self:finish()
                TriggerEvent(Events.CREATE_RESPAWN)
                EndDeathCam()
            end

            Citizen.Wait(0)
        end
    end)
end

function LifeCycle:update()
    -- we poll instead of relying on events b/c hp can change w/o generating an event
    if self.is_alive and (IsPlayerDead(PlayerId()) or IsPedDeadOrDying(PlayerPedId(), 1)) then
        self:kill()
    end
end
