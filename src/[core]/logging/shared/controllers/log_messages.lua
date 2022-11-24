local LABELS = {
    [Logging.FATAL] = "FATAL",
    [Logging.ERROR] = "ERROR",
    [Logging.WARN]  = "WARN",
    [Logging.INFO]  = "INFO",
    [Logging.DEBUG] = "DEBUG",
    [Logging.TRACE] = "TRACE"
}

local function create(data)
    local level = data.level or GetConVarInt("LOG_LEVEL", Logging.TRACE)

    Citizen.Trace("[" .. LABELS[level] .. "] " .. data.message .. "\n")
end
RegisterNetEvent(Events.LOG_MESSAGE, create)
