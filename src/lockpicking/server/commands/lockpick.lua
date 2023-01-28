-- Convenience command for testing
local function cmd_lockpick(source, args)
    args[1] = args[1] or "hard"
    TriggerClientEvent(Events.CREATE_LOCKPICK_SESSION, source, { args = args })
end
RegisterCommand("lockpick", cmd_lockpick, true)
