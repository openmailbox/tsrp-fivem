Hostage = {}

-- Behaviors based on HostageStates registered from the models/hostage/ subdir.
Hostage.States = {}

-- Forward declarations
local start_updates

local hostages   = {}    -- all the in-scope hostages controlled by this client
local is_running = false -- true if the hostage updates are running

function Hostage.for_net_id(net_id)
    for _, h in ipairs(hostages) do
        if h.net_id == net_id then
            return h
        end
    end

    return nil
end

function Hostage:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Hostage:cleanup()
    if DoesEntityExist(self.entity) then
        SetBlockingOfNonTemporaryEvents(self.entity, false)
        TaskSetBlockingOfNonTemporaryEvents(self.entity, false)
    end

    if self.state then
        self.state:exit()
    end
end

function Hostage:initialize()
    table.insert(hostages, self)

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.DEBUG,
        message = "Hostage " .. self.net_id .. " initialized."
    })

    if is_running then return end
    start_updates()
end

-- @tparam number state_id a value from HostageStates
function Hostage:move_to(state_id)
    if self.state_id == state_id then return end
    self.state_id = state_id

    TriggerEvent(Events.LOG_MESSAGE, {
        level = Logging.DEBUG,
        message = "Hostage " .. self.net_id .. " moving to state " .. state_id .. "."
    })

    -- TODO: Causes an unnecessary extra network call for state changes initialized by client (i.e. Waiting->Fleeing timeout)
    TriggerServerEvent(Events.CREATE_HOSTAGE_UPDATE, {
        net_id       = self.net_id,
        new_state_id = state_id
    })

    if self.state then
        self.state:exit()
    end

    local constructor = Hostage.States[state_id]
    if not constructor then return end

    self.state = constructor:new({
        created_at = GetGameTimer(),
        hostage    = self,
    })

    self.state:enter()
end

function Hostage:update()
    if self.state then
        self.state:update()
    end
end

-- @local
function start_updates()
    is_running = true

    Citizen.CreateThread(function()
        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.DEBUG,
            message = "Hostage updates starting."
        })

        while is_running do
            local next_hostage = nil

            for i = #hostages, 1, -1 do
                next_hostage = hostages[i]

                -- TODO: Handle edge case if dead
                if DoesEntityExist(next_hostage.entity) then
                    next_hostage:update()
                else
                    table.remove(hostages, i)
                    next_hostage:cleanup()
                end
            end

            if #hostages == 0 then
                is_running = false
            end

            Citizen.Wait(1000)
        end

        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.DEBUG,
            message = "Hostage updates stopping."
        })
    end)
end
