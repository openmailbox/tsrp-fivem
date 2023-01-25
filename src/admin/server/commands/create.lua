local function cmd_create_object(source, args, raw_command)
    if not source or source == 0 then
        Citizen.Trace("Invalid console command.\n")
        return
    end

    if not args[1] or args[2] then
        TellPlayer(source, "Syntax: /createo <model_name> - Spawn an object from a model.")
        return
    end

    TriggerClientEvent(Events.CREATE_OBJECT_SPAWN, source, {
        args        = args,
        raw_command = raw_command
    })
end
RegisterCommand("createo", cmd_create_object, true)

local function cmd_create_ped(source, args, raw_command)
    if not source or source == 0 then
        Citizen.Trace("Invalid console command.\n")
        return
    end

    if not args[1] or args[2] then
        TellPlayer(source, "Syntax: /createp <model_name> - Spawn an ped from a model.")
        return
    end

    TriggerClientEvent(Events.CREATE_PED_SPAWN, source, {
        args        = args,
        raw_command = raw_command
    })
end
RegisterCommand("createp", cmd_create_ped, true)