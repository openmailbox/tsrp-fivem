local LABELS = {
    [Logging.FATAL] = "FATAL",
    [Logging.ERROR] = "ERROR",
    [Logging.WARN]  = "WARN",
    [Logging.INFO]  = "INFO",
    [Logging.DEBUG] = "DEBUG",
    [Logging.TRACE] = "TRACE"
}

local function create(data)
    local invoker   = GetInvokingResource()
    local timestamp = os.date("%x %X", os.time())
    local level     = data.level or Logging.INFO
    local current   = GetConvarInt("LOG_LEVEL", Logging.INFO)

    if level <= current then
        Citizen.Trace("[" .. invoker .. "] [" .. LABELS[level] .. "] [" .. timestamp .. "] " .. data.message .. "\n")
    end
end
RegisterNetEvent(Events.LOG_MESSAGE, create)
