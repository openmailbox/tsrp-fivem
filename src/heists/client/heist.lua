Heist = {}

local BLIP_SCALE = vector3(0.8, 0.8, 0.8)

local heists = {}

function Heist.cleanup()
    for _, heist in ipairs(heists) do
        heist.available = false
        heist:update({})
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
    self.blip   = {}
    self.spawns = {}

    table.insert(heists, self)
end

-- Process any updates based on changed internal state of the heist.
function Heist:update(changes)
    if not self.available and changes.available then
        self.blip.display = 2
        self.blip.scale   = BLIP_SCALE

        self.blip_id = exports.map:AddBlip(changes.location, changes.blip)
    elseif self.available and not changes.available then
        exports.map:RemoveBlip(self.blip_id)
    end

    if not self.active and changes.active then
        for _, spawn in ipairs(changes.spawns) do
            local entity = NetworkDoesEntityExistWithNetworkId(spawn.net_id) and NetToPed(spawn.net_id)

            if entity and NetworkGetEntityOwner(entity) == PlayerId() then
                SetCurrentPedWeapon(entity, GetBestPedWeapon(entity, 0), true)
            end
        end
    end

    for k, v in pairs(changes) do
        self[k] = v
    end
end
