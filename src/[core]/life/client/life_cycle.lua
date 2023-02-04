LifeCycle = {}

local current = nil

function LifeCycle:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function LifeCycle:begin()
    current = self

    TriggerEvent("logging:CreateMessage", {
        level   = Logging.DEBUG,
        message = "Starting new lifecycle."
    })

    self.is_alive = true

    Citizen.CreateThread(function()
        while current.is_alive do
            current:update()
            Citizen.Wait(1000)
        end
    end)
end

function LifeCycle:kill()
    self.is_alive = false
    StartDeathCam()
end

function LifeCycle:update()
    if IsPlayerDead(PlayerId()) or IsPedDeadOrDying(PlayerPedId(), 1) then
        self:kill()
    end
end
