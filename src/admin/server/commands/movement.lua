local function cmd_goto(source, args, raw_command)
    if not args[1] or not args[2] or not args[3] then
        TellPlayer(source, "Syntax: /goto <x> <y> <z>")
        return
    end

    -- Allow input either as "0 0 0" or "0, 0, 0"
    local x = tonumber((tostring(args[1]):gsub(',', '')))
    local y = tonumber((tostring(args[2]):gsub(',', '')))
    local z = tonumber((tostring(args[3]):gsub(',', '')))

    SetEntityCoords(source, x, y, z, 0, false, false, false)
    TellPlayer(source, "Moving you to " .. vector3(x, y, z) .. ".")
    Citizen.Trace("Player " .. source .. " (" .. GetPlayerName(source) .. ") executed command: '" .. raw_command .. "'.\n")
end
RegisterCommand("goto", cmd_goto, true)

local function cmd_join(source, args, raw_command)
    if not args[1] then
        TellPlayer(source, "Syntax: /join <player ID>")
        return
    end

    local target = tonumber(args[1])

    if target == source or target < 1 then
        TellPlayer(source, "Invalid player ID.")
        return
    end

    for _, player in ipairs(GetPlayers()) do
        if player == target then
            local coords  = GetEntityCoords(GetPlayerPed(player))
            local x, y, z = table.unpack(coords)

            SetEntityCoords(source, x, y, z, 0, false, false, false)
            TellPlayer(source, "Moving you to Player " .. target .. " at " .. coords .. ".")
            Citizen.Trace("Player " .. source .. " (" .. GetPlayerName(source) .. ") executed command: '" .. raw_command .. "'.\n")

            return
        end
    end

    TellPlayer(source, "Invalid player ID.")
end
RegisterCommand("join", cmd_join, true)
