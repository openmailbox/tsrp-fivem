local COLOR_RED = { 255, 0, 0 }

local function parse_command(source, args, raw_command)
    local subcommand = args[1]
    local handler    = nil

    if source and source > 0 then
        Citizen.Trace("Unsuccessful attempt to run command '" .. raw_command .. "' by Player " .. source .. ".\n")

        TriggerClientEvent(Events.ADD_CHAT_MESSAGE, source, {
            color     = COLOR_RED,
            multiline = true,
            args      = { GetCurrentResourceName(), "This command may only be used from a server console.\n" }
        })

        return
    end

    if subcommand == "migrate" then
        handler = Migrate
    elseif subcommand == "setup" then
        -- TODO: apply exported schema
    end

    if handler then
        local command = handler:new({
            source      = source,
            args        = args,
            raw_command = raw_command
        })

        command:execute()
    else
        Citizen.Trace("Invalid subcommand: '" .. raw_command .. "'.\n")
    end
end
RegisterCommand("dbutil", parse_command, true)
