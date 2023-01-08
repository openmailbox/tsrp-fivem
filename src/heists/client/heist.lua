Heist = {}

local BLIP_SCALE = vector3(0.8, 0.8, 0.8)

local heists = {}

function Heist.cleanup()
    for _, heist in ipairs(heists) do
        heist.available = false
        heist:update()
    end
end

function Heist.find_by_id(id)
    for _, heist in ipairs(heists) do
        if heist.id == id then
            return heist
        end
    end

    return nil
end

function Heist:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Heist:initialize()
    table.insert(heists, self)
end

-- Process any updates based on changed internal state of the heist.
function Heist:update()
    if self.available then
        self.blip.display = 2
        self.blip.scale   = BLIP_SCALE

        self.blip_id = exports.map:AddBlip(self.location, self.blip)
    else
        exports.map:RemoveBlip(self.blip_id)
    end
end
