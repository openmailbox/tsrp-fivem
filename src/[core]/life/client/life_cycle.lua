LifeCycle = {}

-- Forward declarations
local get_respawn_point

local PILLBOX      = vector3(293.2390, -583.3027, 43.1950)
local PROMPT_KEY   = "LifeCyclePrompt"
local SPAWN_ORIGIN = vector3(320.8595, -592.9031, 43.2840) -- TODO: Don't assume Pillbox interior

local current = nil
local next_id = 0

function LifeCycle.get_current()
    return current
end

function LifeCycle.initialize()
    AddTextEntry(PROMPT_KEY, "You are incapacitated. Press ~INPUT_REPLAY_START_STOP_RECORDING~ to respawn.")

    exports.map:AddBlip(PILLBOX, {
        icon    = 61,
        display = 2,
        label   = "Hospital"
    })

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

    self.id           = next_id
    self.is_alive     = not IsPlayerDead(PlayerId()) and not IsPedDeadOrDying(PlayerPedId())
    self.wanted_level = GetPlayerWantedLevel()

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
    TriggerEvent(Events.CLEAR_CHAT)

    Citizen.CreateThread(function()
        while current == self and IsPedDeadOrDying(PlayerPedId(), 1) do
            DisplayHudWhenDeadThisFrame()
            DisplayHelpTextThisFrame(PROMPT_KEY, 0)
            ProcessCamControls()

            if IsControlJustPressed(0, 288) then -- F1
                self:finish()

                TriggerEvent(Events.CREATE_RESPAWN, {
                    location = get_respawn_point(),
                    heading  = math.random(359)
                })

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
    elseif self.wanted_level ~= GetPlayerWantedLevel(PlayerId()) then
        local level = GetPlayerWantedLevel(PlayerId())

        TriggerEvent(Events.CREATE_WANTED_STATUS_CHANGE, {
            old = self.wanted_level,
            new = level,
        })

        TriggerServerEvent(Events.CREATE_WANTED_STATUS_CHANGE, {
            old = self.wanted_level,
            new = level
        })

        self.wanted_level = level
    end
end

-- @local
function get_respawn_point()
    local angle  = math.random() * math.pi * 2
    local radius = math.sqrt(math.random()) * 3.0
    local x      = SPAWN_ORIGIN.x + radius * math.cos(angle)
    local y      = SPAWN_ORIGIN.y + radius * math.sin(angle)

    return vector3(x, y, SPAWN_ORIGIN.z)
end
