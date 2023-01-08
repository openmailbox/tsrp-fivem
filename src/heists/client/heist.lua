Heist = {}

local heists = {}

function Heist.cleanup()
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

-- Process any updates based on changed internal state of the heist.
function Heist:update()
    if self.available then
        self.blip_id = exports.map:AddBlip(self.locations, self.blip)
    else
        exports.map:RemoveBlip(self.blip_id)
    end
end
