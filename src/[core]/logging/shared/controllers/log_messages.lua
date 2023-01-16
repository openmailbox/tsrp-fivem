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
    local timestamp = ""
    local level     = data.level or Logging.INFO
    local current   = GetConvarInt("LOG_LEVEL", Logging.INFO)

    if os and os.time then
        timestamp = tostring(os.date("%x %X", os.time()))
    else
        timestamp = GetGameTimer()
    end

    if level <= current then
        Citizen.Trace("[" .. timestamp .. "] [" .. invoker .. "] [" .. LABELS[level] .. "] " .. data.message .. "\n")
    end
end
RegisterNetEvent(Events.LOG_MESSAGE, create)
