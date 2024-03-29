-- Forward declarations
local tell_player

local function cmd_give_item(source, args, raw_command)
    if not args[1] then
        tell_player(source, "Syntax: /giveitem <player_id> <name> [amount] - Give items to a player.")
        return
    end

    local player = nil

    for _, p in ipairs(GetPlayers()) do
        if p == args[1] then
            player = p
            break
        end
    end

    if not player then
        tell_player(source, "No player found with ID " .. args[1] .. ".")
        return
    end

    local template = ItemTemplate.for_name(args[2])

    if not template then
        tell_player(source, "No such item '" .. args[2] .. "'.")
        return
    end

    local container = Container.for_player(player)
    local new_item  = Item.from_template(template)
    local amount    = math.abs((args[3] and tonumber(args[3])) or 1)

    new_item.quantity = amount

    container:add_item(new_item)

    tell_player(source, "Gave " .. amount .. "x '" .. template.name .. "' to " .. GetPlayerName(player) .. " (" .. player .. ").")
    Logging.log(Logging.INFO, GetPlayerName(source) .. " (" .. source .. ") used command '" .. raw_command .. "'.")

    TriggerClientEvent(Events.UPDATE_INVENTORY_REFRESH, source, {
        inventory = container
    })
end
RegisterCommand("giveitem", cmd_give_item, true)

-- @local
 function tell_player(player, message)
    if not player or player == 0 then
        Citizen.Trance(message .. "\n")
        return
    end

    TriggerClientEvent(Events.ADD_CHAT_MESSAGE, player, {
        color     = Colors.RED,
        multiline = true,
        args      = { GetCurrentResourceName(), message }
    })
end