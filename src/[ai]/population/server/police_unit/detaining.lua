Detaining = {}

PoliceUnit.States[PoliceStates.DETAINING] = Detaining

-- Forward declarations
local find_player_from_ped

function Detaining:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Detaining:enter()
    local x, y, z = table.unpack(self.unit.current_target_offset)

    SetCurrentPedWeapon(self.unit.entity, Weapons.UNARMED, true)
    TaskGoStraightToCoord(self.unit.entity, x, y, z, 1.0, -1, 0, 0.0)
end

function Detaining:exit()
end

function Detaining:update()
    local task     = GetPedScriptTaskCommand(self.unit.entity)
    local distance = Dist2d(GetEntityCoords(self.unit.entity), GetEntityCoords(self.unit.current_target))

    if distance < 2.0 and not self.timeout then
        self.timeout = GetGameTimer() + 5000

        local enactor_owner = NetworkGetEntityOwner(self.unit.entity)
        local target_owner  = NetworkGetEntityOwner(self.unit.current_target)
        local target_net_id = NetworkGetNetworkIdFromEntity(self.unit.current_target)

        TriggerClientEvent(Events.CREATE_POPULATION_TASK, enactor_owner, {
            task_id = Tasks.DETAIN,
            net_id  = NetworkGetNetworkIdFromEntity(self.unit.entity),
            target  = target_net_id,
            ping    = GetPlayerPing(enactor_owner)
        })

        TriggerClientEvent(Events.CREATE_CUFFED_HOSTAGE, target_owner, {
            target = target_net_id,
            ping   = GetPlayerPing(target_owner)
        })

        Citizen.SetTimeout(3000, function()
            if IsPedAPlayer(self.unit.current_target) then
                local player = find_player_from_ped(self.unit.current_target)

                SetPlayerWantedLevel(player, 0)

                TriggerClientEvent(Events.CREATE_PRISON_SENTENCE, player)

                TriggerClientEvent(Events.FLUSH_WANTED_STATUS, player, {
                    ping = GetPlayerPing(player)
                })
            end

            if self.unit.assigned_call then
                Dispatcher.cancel(self.unit.assigned_call.id)
            end
        end)

        return
    end

    if task == Tasks.NO_TASK and self.timeout and GetGameTimer() > self.timeout then
        self.unit:move_to(PoliceStates.SEARCHING)
    end
end

-- @local
function find_player_from_ped(ped)
    for _, player in ipairs(GetPlayers()) do
        if GetPlayerPed(player) == ped then
            return player
        end
    end

    return nil
end
