Stash = {}

local INTERACT_NAME = "Open Stash"

local models  = {} -- ModelHash->Boolean map of all the registered object models that can be stashes
local stashes = {} -- Name->Stash map of all the stashes this player knows about

function Stash.cleanup()
    for model, _ in pairs(models) do
        exports.interactions:UnregisterInteraction(model, INTERACT_NAME)
    end

    for _, stash in pairs(stashes) do
        stash:hide()
    end

    models  = {}
    stashes = {}
end

function Stash.initialize(data)
    for name, d in pairs(data) do
        local stash = Stash:new(d)
        stash:show()

        stashes[name] = stash
        models[stash.model] = false
    end

    for hash, _ in pairs(models) do
        models[hash] = exports.interactions:RegisterInteraction({
            model  = hash,
            name   = INTERACT_NAME,
            prompt = "open the stash"
        }, function(object)
            exports.progress:ShowProgressBar(2000, "Opening")
            exports.interactions:AddExclusion(object)

            Citizen.Wait(1950)

            local wallet     = GetHashKey("MP0_WALLET_BALANCE")
            local _, balance = StatGetInt(wallet, -1)
            local new_b      = balance + 100

            StatSetInt(wallet, new_b, true)
        end)
    end
end

function Stash:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Stash:hide()
    RemoveBlip(self.blip)
end

function Stash:show()
    local x, y, z = table.unpack(self.location)
    local blip    = AddBlipForCoord(x, y, z)

    SetBlipSprite(blip, 587)
    SetBlipColour(blip, 46)
    SetBlipDisplay(blip, 6)
    SetBlipAsShortRange(blip, true)
    SetBlipCategory(blip, 2)
    SetBlipScale(blip, 0.6)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Stash")
    EndTextCommandSetBlipName(blip)

    self.blip = blip
end
