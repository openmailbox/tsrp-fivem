Marker = {}

local DEFAULT_COLOR          = { r = 255, g = 255, b = 255, a = 255 }
local DEFAULT_DRAW_RANGE     = 7.0
local DEFAULT_INTERACT_RANGE = 2.0
local DEFAULT_ROTATION       = vector3(0, 0, 0)
local DEFAULT_SCALE          = vector3(1.0, 1.0, 1.0)
local VECTOR3_ZERO           = vector3(0, 0, 0)

-- Frequently used loop variables for rendering
local cloc, distance, fov, scale

function Marker.add(options)
    local marker = Marker:new({
        icon           = options.icon or 1,
        coords         = options.coords,
        direction      = options.direction or VECTOR3_ZERO,
        rotation       = options.rotation or DEFAULT_ROTATION,
        scale          = options.scale or DEFAULT_SCALE,
        bob            = options.bob or false,
        face_camera    = options.face_camera or false,
        rotate         = options.rotate or false,
        text           = options.text,
        on_enter       = options.on_enter,
        on_exit        = options.on_exit,
        on_interact    = options.on_interact,
        draw_range     = options.draw_range or DEFAULT_DRAW_RANGE ^ 2, -- squared b/c Vdist2
        interact_range = options.interact_range or DEFAULT_INTERACT_RANGE ^ 2,
        data           = options.data or {},
        color          = {
            r = options.red or DEFAULT_COLOR.r,
            g = options.green or DEFAULT_COLOR.g,
            b = options.blue or DEFAULT_COLOR.b,
            a = options.alpha or DEFAULT_COLOR.a
        }
    })

    exports.map:StartTracking(marker.coords, GetCurrentResourceName(), marker)

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.DEBUG,
        message = "Added marker icon " .. marker.icon .. " at " .. marker.coords .."."
    })

    return true
end
exports("AddMarker", Marker.add)

function Marker.remove(coords)
    exports.map:StopTracking(coords, GetCurrentResourceName())

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.DEBUG,
        message = "Removed marker icon at " .. coords .."."
    })
end
exports("RemoveMarker", Marker.remove)

function Marker:new(o)
    o = o or {}

    o.text_coords = vector3(o.coords.x, o.coords.y, o.coords.z + 1.0)

    setmetatable(o, self)

    self.__index     = self
    self.__tostring  = self.tostring

    return o
end

function Marker:activate()
    if self.active then return end
    self.active = true

    TriggerEvent(Events.LOG_MESSAGE, {
        level   = Logging.DEBUG,
        message = "Activating marker at " .. self.coords .. "."
    })

    if self.on_enter then
        local succ, err = pcall(self.on_enter, self.data)

        if not succ then
            Citizen.Trace("WARNING: Error executing on_enter for marker at " .. self.coords .. ": " .. tostring(err) .. "\n")
        end
    end
end

function Marker:deactivate()
    self.active = false

    if self.on_exit then
        local succ, err = pcall(self.on_exit, self.data)

        if not succ then
            Citizen.Trace("WARNING: Error executing on_exit for marker at " .. self.coords .. ": " .. tostring(err) .. "\n")
        end
    end
end

function Marker:render()
    DrawMarker(self.icon,
               self.coords,
               self.direction,
               self.rotation,
               self.scale,
               self.color.r, self.color.g, self.color.b, self.color.a,
               self.bob,
               self.face_camera,
               2,
               self.rotate,
               nil,
               nil,
               false)


    if self.active and self.on_interact and IsControlJustPressed(0, 51) and
        Vdist2(self.coords, GetEntityCoords(PlayerPedId())) <= self.interact_range then

        local succ, err = pcall(self.on_interact, self.data)

        if not succ then
            Citizen.Trace("WARNING: Error executing on_interact for marker at " .. tostring(self.coords) .. ": " ..
                          tostring(err) .. "\n")
        end
    end

    if not self.text then return end

    cloc     = GetGameplayCamCoords()
    distance = #(self.coords - cloc)
    scale    = (1 / distance) * 2
    fov      = (1 / GetGameplayCamFov()) * 100

    scale = scale * fov

    SetTextScale(0.0 * scale, 0.55 * scale)
    SetTextFont(0)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(10, 100, 100, 100, 255)
    SetTextOutline()
    SetTextCentre(true)
    SetDrawOrigin(self.text_coords, 0)

    -- TODO: Probably more efficient to store labels w/ AddTextEntry
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(self.text)
    EndTextCommandDisplayText(0.0, 0.0)

    ClearDrawOrigin()
end

function Marker:tostring(_)
    local fields = {}

    for k, v in pairs(self) do
        table.insert(fields, k .. "=" .. tostring(v))
    end

    return "Marker{" .. table.concat(fields, ", ") .. "}"
end
