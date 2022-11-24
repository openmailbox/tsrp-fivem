PlayerMap = {}

local current
local blips = {}

function PlayerMap.add_blip(label, coords, options)
    for _, b in ipairs(blips) do
        -- TODO: Support duplicates by name
        if b.label == label then
            return false
        end
    end

    local x, y, z = table.unpack(coords)
    local blip    = AddBlipForCoord(x, y, z)

    SetBlipSprite(blip, options.icon or 1)
    SetBlipColour(blip, options.color or 0)
    SetBlipDisplay(blip, options.display or 3)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(label)
    EndTextCommandSetBlipName(blip)

    table.insert(blips, {
        label = label,
        blip  = blip
    })

    return true
end
exports("AddBlip", PlayerMap.add_blip)

function PlayerMap.current()
    return current
end

function PlayerMap.initialize()
    current = PlayerMap:new({})
    return current
end

function PlayerMap.remove_blip(label)
    for i, b in ipairs(blips) do
        if b.label == label then
            RemoveBlip(b.blip)
            table.remove(blips, i)
            return true
        end
    end

    return false
end
exports("RemoveBlip", PlayerMap.remove_blip)

function PlayerMap:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function PlayerMap:update(force_update)
    self.ploc = GetEntityCoords(PlayerPedId())

    local cell, cx, cy = WorldMap.current():get_cell(self.ploc)

    if force_update or not self.active_cell or self.active_cell ~= cell then
        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.DEBUG,
            message = "Updating active player map cell to " .. cx .. ", " .. cy .. "."
        })

        TriggerEvent(Events.MAP_UPDATE_PLAYER, {
            coords = self.ploc,
            x      = cx,
            y      = cy
        })

        self.active_cell = cell
    end
end
