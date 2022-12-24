Character = {}

-- Forward declarations
local find_in_snapshot

function Character:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Character:assign_position(position)
    local model      = find_in_snapshot(self.snapshot, "model").value
    local x, y, z, h = table.unpack(position.coords)
    local timeout    = GetGameTimer() + 2000
    local animation  = position.animation

    if not IsModelAPed(model.hash) then
        TriggerEvent(Events.LOG_MESSAGE, {
            level = Logging.WARN,
            message = "Invalid model hash for Character " .. self.id .. "."
        })

        return
    end

    if not HasModelLoaded(model.hash) then
        RequestModel(model.hash)

        while not HasModelLoaded(model.hash) do
            Citizen.Wait(20)
        end
    end

    self.ped = CreatePed(4, model.hash, x, y, z, h, false, true)

    repeat
       Citizen.Wait(20)
    until DoesEntityExist(self.ped) or GetGameTimer() > timeout

    exports.wardrobe:RestoreSnapshot(self.ped, self.snapshot)

    if not HasAnimDictLoaded(animation.dictionary) then
        RequestAnimDict(animation.dictionary)

        while not HasAnimDictLoaded(animation.dictionary) do
            Citizen.Wait(20)
        end
    end

    TaskPlayAnim(self.ped, animation.dictionary, animation.name, 8.0, 8.0, -1, 1, false, false, false)
end

function Character:hide()
    SetEntityVisible(self.ped, false)
end

function Character:remove()
    DeleteEntity(self.ped)
    self.ped = nil
end

-- @local
function find_in_snapshot(snapshot, name)
    for _, record in ipairs(snapshot.attributes) do
        if record.name == name then
            return record
        end
    end

    return {}
end
