local function cmd_wardrobe(source, args, _)
    local target = source

    if args[1] then
        local found = false

        for _, p in ipairs(GetPlayers()) do
            if p == args[1] then
                found  = true
                target = p

                break
            end
        end

        if not found then
            TellPlayer(source, "No player found with ID " .. args[1] .. ".")
            return
        end
    end

    TriggerClientEvent(Events.CREATE_WARDROBE_SESSION, target)

    local message = "Created a wardrobe session for Player " .. target .. " (" .. GetPlayerName(target) .. ")."

    TellPlayer(source, message)
    Citizen.Trace("Player " .. source .. " (" .. GetPlayerName(source) .. ") " .. string.lower(message) .. "\n")
end
RegisterCommand("wardrobe", cmd_wardrobe, true)
