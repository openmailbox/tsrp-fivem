---@diagnostic disable: duplicate-set-field
Camera = {}

local LOCATION = vector3(0, 0, 0)

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
    local x, y, z = table.unpack(LOCATION)
    self.camera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", x, y, z, 0, 0, 0, 75.0, false, 0)

    SetCamActive(self.camera, true)
    RenderScriptCams(true, true, 1500, true, true)
end

-- update() is called every frame while session is active
function Camera:update()
end
