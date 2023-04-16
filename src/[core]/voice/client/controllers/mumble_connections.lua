local function on_connect(address, reconnecting)
    Logging.log(Logging.DEBUG, ((reconnecting and "Reconnected") or "Connected") .. " to mumble server at " .. address .. ".")
    MumbleSetTalkerProximity(10.0)
end
AddEventHandler(Events.ON_MUMBLE_CONNECT, on_connect)

local function on_disconnect(address)
    Logging.log(Logging.DEBUG, "Disconnected from mumble server at " .. address .. ".")
end
AddEventHandler(Events.ON_MUMBLE_DISCONNECT, on_disconnect)
