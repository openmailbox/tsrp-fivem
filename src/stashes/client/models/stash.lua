Stash = {}

local INTERACT_NAME = "Open Stash"
local OPEN_TIME     = 2000 -- ms
local HELP_KEY      = "StashBonusHelp"

local models  = {} -- ModelHash->Boolean map of all the registered object models that can be stashes
local stashes = {} -- Name->Stash map of all the stashes on the map.

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
        stash:hide()

        if stash.opened then
            stash:mark_unopened()
        end
    end
end

function Stash.find_by_name(name)
    return stashes[name]
end

function Stash.initialize(data)
    AddTextEntry(HELP_KEY, "Get ~g~~h~20~h~~s~ kills with any weapon to earn a bonus.")

    for name, d in pairs(data) do
        local stash = Stash:new(d)
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

function Stash.random()
    local ordered = {}

    for _, stash in pairs(stashes) do
        table.insert(ordered, stash)
    end

    return ordered[math.random(#ordered)]
end

function Stash.show_bonus_help()
    BeginTextCommandDisplayHelp(HELP_KEY)
    EndTextCommandDisplayHelp(0, false, true, -1)
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
    SetBlipAsShortRange(blip, false)
    SetBlipFlashes(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Stash")
    EndTextCommandSetBlipName(blip)

    self.blip = blip

    Citizen.CreateThread(function()
        Citizen.Wait(7000)
        SetBlipFlashes(self.blip, false)
        SetBlipAsShortRange(self.blip, true)
    end)
end
