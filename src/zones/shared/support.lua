-- Used both client and server side from Zone.lua
function DoesZoneContain(zone, point)
    local x, y  = table.unpack(point)
    local x_min = zone.center.x - (zone.width / 2)
    local x_max = zone.center.x + (zone.width / 2)

    if x < x_min or x > x_max then
        return false
    end

    local y_min = zone.center.y - (zone.height / 2)
    local y_max = zone.center.y + (zone.height / 2)

    if y < y_min or y > y_max then
        return false
    end

    return true
end
