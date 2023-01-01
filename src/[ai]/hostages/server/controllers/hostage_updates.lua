local function create(data)
    local hostage = HostageDirector.find_by_net_id(data.net_id)

    if not hostage then
        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.WARN,
            message = "Hostage " .. data.net_id .. " attempted an update but was not found."
        })

        return
    end

    hostage:move_to(data.new_state_id)
end
RegisterNetEvent(Events.CREATE_HOSTAGE_UPDATE, create)
