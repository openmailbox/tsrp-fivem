Stash = {}

local INTERACT_NAME = "Open Stash"
local OPEN_TIME     = 2000 -- ms

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

function Stash.close_all()
    for _, stash in pairs(stashes) do
        if stash.opened then
            stash:mark_unopened()
        end
    end
end

function Stash.find_by_name(name)
    return stashes[name]
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
            exports.interactions:AddExclusion(object)
            exports.progress:ShowProgressBar(OPEN_TIME, "Opening")

            TriggerServerEvent(Events.CREATE_STASH_OPENING, {
                net_id    = ObjToNet(object),
                opened_at = GetGameTimer() + OPEN_TIME
            })
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

function Stash:mark_opened()
    self.opened = true
    ShowTickOnBlip(self.blip, true)
end

function Stash:mark_unopened()
    self.opened = false
    ShowTickOnBlip(self.blip, false)
end

function Stash:show()
    local x, y, z = table.unpack(self.location)
    local blip    = AddBlipForCoord(x, y, z)

    SetBlipSprite(blip, 587)
    SetBlipColour(blip, 60)
    SetBlipDisplay(blip, 6)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.6)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Stash")
    EndTextCommandSetBlipName(blip)

    self.blip = blip
end
