Logging = {}

Logging.FATAL = 0
Logging.ERROR = 1
Logging.WARN  = 2
Logging.INFO  = 3
Logging.DEBUG = 4
Logging.TRACE = 5

Events = Events or {}

Events.LOG_MESSAGE = "logging:CreateMessage"

local LABELS = {
    [Logging.FATAL] = "FATAL",
    [Logging.ERROR] = "ERROR",
    [Logging.WARN]  = "WARN",
    [Logging.INFO]  = "INFO",
    [Logging.DEBUG] = "DEBUG",
    [Logging.TRACE] = "TRACE"
}

-- @tparam boolean net_send true if this should be echoed over the network (i.e. to Discord if configured)
function Logging.log(level, message, net_send)
    level = level or Logging.INFO

    local timestamp = ""
    local current   = GetConvarInt("LOG_LEVEL", Logging.INFO)

    if os and os.time then
        timestamp = tostring(os.date("%x %X", os.time()))
    else
        timestamp = GetGameTimer()
    end

    local formatted = "[" .. LABELS[level] .. "] " .. message .. "\n"

    if level <= current then
        Citizen.Trace("[" .. timestamp .. "] " .. formatted)

        if net_send then
            TriggerEvent(Events.CREATE_DISCORD_LOG, formatted)
        end
    end
end
