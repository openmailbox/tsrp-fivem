local function create(data)
    local id = source
    Logging.log(Logging.INFO, GetPlayerName(id) .. " (" .. id .. ") wanted level changed from " .. data.old .. " to " .. data.new .. ".")
end
RegisterNetEvent(Events.CREATE_WANTED_STATUS_CHANGE, create)
