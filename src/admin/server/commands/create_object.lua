local function create_object(source, args, raw_command)
    if not source or source == 0 then
        Citizen.Trace("Invalid console command.\n")
        return
    end

    if not args[1] or args[2] then
        TellPlayer(source, "Syntax: /createo <name | hash> - Spawn an object from a model.")
        return
    end

    TriggerClientEvent(Events.CREATE_OBJECT_SPAWN, source, {
        args        = args,
        raw_command = raw_command
    })
end
RegisterCommand("createo", create_object, true)
