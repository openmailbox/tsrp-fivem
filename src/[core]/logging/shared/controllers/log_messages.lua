local LABELS = {
    [Logging.FATAL] = "FATAL",
    [Logging.ERROR] = "ERROR",
    [Logging.WARN]  = "WARN",
    [Logging.INFO]  = "INFO",
    [Logging.DEBUG] = "DEBUG",
    [Logging.TRACE] = "TRACE"
}

local function create(data)
    local level   = data.level or Logging.INFO
    local current = GetConVarInt("LOG_LEVEL", Logging.INFO)

    if level >= current then
        Citizen.Trace("[" .. LABELS[level] .. "] " .. data.message .. "\n")
    end
end
RegisterNetEvent(Events.LOG_MESSAGE, create)
