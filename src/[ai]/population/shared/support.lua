-- Misc support functions

function Dist2d(p1, p2)
    return math.sqrt((p1.x - p2.x) ^ 2 + (p1.y - p2.y) ^ 2)
end

function GetRandomPointInCircle(origin, r)
    local angle  = math.random() * math.pi * 2
    local radius = math.sqrt(math.random()) * r
    local x      = origin.x + radius * math.cos(angle)
    local y      = origin.y + radius * math.sin(angle)

    return vector3(x, y, origin.z)
end
