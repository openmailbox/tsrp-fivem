local keys = {}

local function create(data)
    local hash = GetHashKey(data.message)

    if not keys[hash] then
        AddTextEntry(hash, data.message)
        keys[hash] = data
    end

    BeginTextCommandDisplayHelp(hash)
    EndTextCommandDisplayHelp(0, false, true, -1)
end
RegisterNetEvent(Events.CREATE_HUD_HELP_MESSAGE, create)
