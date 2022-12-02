PlayerMap = {}

local current = nil

function PlayerMap.current()
    return current
end

function PlayerMap.initialize()
    current = PlayerMap:new({})
    return current
end

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
