Camera = {}

-- Forward declarations
local dist2d

local MAX_ZOOM = 1.1

function Camera:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Camera:cleanup()
    SetCamActive(self.camera, false)
    RenderScriptCams(false, true, 1500, true, true)
end

function Camera:get_location()
    return GetCamCoord(self.camera)
end

function Camera:get_matrix()
    return GetCamMatrix(self.camera)
end

function Camera:initialize()
    local ploc     = GetEntityCoords(PlayerPedId())
    local forward  = ploc + GetEntityForwardVector(PlayerPedId())
    local cloc     = GetGameplayCamCoord()
    local x_offset = -0.75
    local y_offset = 1.5

    if Vdist(forward, cloc) > Vdist(ploc, cloc) then
        x_offset = x_offset * -1
        y_offset = y_offset * -1
    end

    local spot     = GetOffsetFromEntityInWorldCoords(PlayerPedId(), x_offset, y_offset, 0.0)
    local _, floor = GetGroundZFor_3dCoord(ploc.x, ploc.y, ploc.z, 0)
    local rads     = math.atan2(ploc.y - spot.y, ploc.x - spot.x)
    local angle    = rads * (180 / math.pi)

    if angle < 0 then
        angle = 360 - (-1 * angle)
    end

    self.floor   = floor + 0.15
    self.ceiling = floor + 1.6
    self.origin  = spot
    self.camera  = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", spot.x, spot.y, spot.z, 0, 0, angle - 105.0, 75.0, false, 0)

    -- TODO: Noticeable texture issues when DoF is on behind objects with transparency
    SetCamUseShallowDofMode(self.camera, true)
    SetCamNearDof(self.camera, 0.1)
    SetCamFarDof(self.camera, 4.0)
    SetCamDofStrength(self.camera, 0.9)
    SetCamActive(self.camera, true)
    RenderScriptCams(true, true, 1500, true, true)
end

function Camera:start_pan(direction)
    self.panning = direction * 0.01
end

function Camera:start_zoom(direction)
    -- TODO: Vector should be toward the ped, not the camera's forward
    local _, forward = self:get_matrix()
    self.zooming = forward * direction * 0.01
end

function Camera:stop_pan()
    self.panning = false
end

function Camera:stop_zoom()
    self.zooming = false
end

-- update() is called every frame while wardrobe session is active
-- Frequently accessed loop vars
local _next, _x, _y, _z
function Camera:update()
    SetUseHiDof() -- enables camera depth of field

    if self.panning then
        _x, _y, _z = table.unpack(GetCamCoord(self.camera))
        SetCamCoord(self.camera, _x, _y, math.min(math.max(_z + self.panning, self.floor), self.ceiling))
    end

    if self.zooming then
        _next = GetCamCoord(self.camera) + self.zooming

        if dist2d(self.origin, _next) < MAX_ZOOM then
            ---@diagnostic disable-next-line: param-type-mismatch
            _x, _y, _z = table.unpack(GetCamCoord(self.camera) + self.zooming)

            SetCamCoord(self.camera, _x, _y, _z)
        end
    end
end

-- @local
function dist2d(p1, p2)
    return math.sqrt((p1.x - p2.x) ^ 2 + (p1.y - p2.y) ^ 2)
end
