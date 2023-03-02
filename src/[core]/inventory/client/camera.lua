Camera = {}

-- Forward declarations
local get_camera_coords

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

function Camera:initialize()
    local coords = GetGameplayCamCoord()
    local rot    = GetGameplayCamRot()

    self.origin = coords
    self.camera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", coords.x, coords.y, coords.z, rot.x, rot.y, rot.z, 75.0, false, 0)

    -- TODO: Noticeable texture issues when DoF is on behind objects with transparency
    SetCamUseShallowDofMode(self.camera, true)
    SetCamNearDof(self.camera, 0.1)
    SetCamFarDof(self.camera, 4.0)
    SetCamDofStrength(self.camera, 0.9)
    SetCamActive(self.camera, true)
    RenderScriptCams(true, true, 1500, true, true)
end

function Camera:get_location()
    return GetCamCoord(self.camera)
end

function Camera:get_matrix()
    return GetCamMatrix(self.camera)
end

-- update() is called every frame while inventory session is active
-- Frequently accessed loop vars
local _next, _rot
function Camera:update()
    _next, _rot = get_camera_coords()

    SetUseHiDof() -- enables camera depth of field
    SetCamCoord(self.camera, _next.x, _next.y, _next.z)
    SetCamRot(self.camera, _rot.x, _rot.y, _rot.z, 2)
end

-- @local
function get_camera_coords()
    local ploc     = GetEntityCoords(PlayerPedId())
    local forward  = ploc + GetEntityForwardVector(PlayerPedId())
    local cloc     = GetGameplayCamCoord()
    local x_offset = -0.75
    local y_offset = 1.5

    if Vdist(forward, cloc) > Vdist(ploc, cloc) then
        x_offset = x_offset * -1
        y_offset = y_offset * -1
    end

    local spot  = GetOffsetFromEntityInWorldCoords(PlayerPedId(), x_offset, y_offset, 0.2)
    local rads  = math.atan2(ploc.y - spot.y, ploc.x - spot.x)
    local angle = rads * (180 / math.pi)

    if angle < 0 then
        angle = 360 - (-1 * angle)
    end

    return spot, vector3(0, 0, angle - 105.0)
end
