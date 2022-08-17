Camera = {}

-- Frequently accessed loop variables
local x, y, z

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
    local cloc     = GetGameplayCamCoord()
    local ploc     = GetEntityCoords(PlayerPedId())
    local spot     = ploc - (norm(ploc - cloc) * 2)
    local _, floor = GetGroundZFor_3dCoord(ploc.x, ploc.y, ploc.z, 0)

    local rads  = math.atan2(ploc.y - spot.y, ploc.x - spot.x)
    local angle = rads * (180 / math.pi)

    if angle < 0 then
        angle = 360 - (-1 * angle)
    end

    -- TODO: Overrotating doesn't work when zooming. Need better camera positioning.

    self.camera  = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", spot.x, spot.y, ploc.z + 0.2, 0, 0, angle - 110.0, 65.0, false, 0)
    self.floor   = floor + 0.1
    self.ceiling = floor + 1.4

    SetCamUseShallowDofMode(self.camera, true)
    SetCamNearDof(self.camera, 0.5)
    SetCamFarDof(self.camera, 4.0)
    SetCamDofStrength(self.camera, 1.0)
    SetCamActive(self.camera, true)
    RenderScriptCams(true, true, 1500, true, true)
end

function Camera:start_pan(direction)
    self.panning = direction * 0.01
end

function Camera:start_zoom(direction)
    local _, forward = self:get_matrix()
    self.zooming = forward * direction * 0.01
end

function Camera:stop_pan()
    self.panning = false
end

function Camera:stop_zoom()
    self.zooming = false
end

-- Called every frame while wardrobe session is active
function Camera:update()
    SetUseHiDof() -- enables camera depth of field

    if self.panning then
        x, y, z = table.unpack(GetCamCoord(self.camera))
        SetCamCoord(self.camera, x, y, math.min(math.max(z + self.panning, self.floor), self.ceiling))
    end

    if self.zooming then
        ---@diagnostic disable-next-line: param-type-mismatch
        x, y, z = table.unpack(GetCamCoord(self.camera) + self.zooming)
        -- TODO: Cap zoom values
        SetCamCoord(self.camera, x, y, z)
    end
end
