local function create(message)
    local env     = GetConvar("FIVEM_ENVIRONMENT")
    local webhook = GetConvar("DISCORD_LOGGING_WEBHOOK")
    local token   = GetConvar("DISCORD_LOGGING_TOKEN")

    if string.len(webhook) < 1 or string.len(token) < 1 then
        Logging.log(Logging.WARN, "Unable to log to Discord without a configured webhook and token.")
        return
    end

    local url     = webhook .. "/" .. token
    local params  = { "content=" .. message }

    if string.len(env) > 0 then
        table.insert(params, "username=Server Log (" .. env .. ")")
    end

    PerformHttpRequest(url, function(status, data, _)
        if status == 200 or status == 204 then
            Logging.log(Logging.INFO, "Discord logging webhook responded " .. status .. " " .. tostring(data))
        else
            Logging.log(Logging.WARN, "Discord API Error: " .. tostring(url) .. "\n")
            Logging.log(Logging.WARN, "Params: " .. table.concat(params, ", ") .. "\n")
            Logging.log(Logging.WARN, "Status: " .. status .. ", Data: " .. tostring(data) .. "\n")
        end
    end, "POST", table.concat(params, "&"))
end
AddEventHandler(Events.CREATE_DISCORD_LOG, create)
