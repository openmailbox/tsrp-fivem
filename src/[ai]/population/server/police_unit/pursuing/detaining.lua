Detaining = {}

PoliceUnit.States[PoliceStates.DETAINING] = Detaining

-- Forward declarations
local find_player_from_ped,
      sync_approach,
      sync_detain

function Detaining:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

function Detaining:enter()
    SetCurrentPedWeapon(self.unit.entity, Weapons.UNARMED, true)
    sync_approach(self)
end

function Detaining:exit()
end

function Detaining:update()
    local target_loc = GetEntityCoords(self.unit.current_target)
    local distance   = Dist2d(GetEntityCoords(self.unit.entity), target_loc)

    if distance < 1.5 and not self.is_detaining then
        self.is_detaining = true

        sync_detain(self)

        local target = self.unit.current_target
        local player = IsPedAPlayer(target) and find_player_from_ped(target)
        local call   = self.unit.assigned_call

        Citizen.SetTimeout(3000, function()
            if player then
                SetPlayerWantedLevel(player, 0)

                TriggerClientEvent(Events.CREATE_PRISON_SENTENCE, player)

                TriggerClientEvent(Events.FLUSH_WANTED_STATUS, player, {
                    ping = GetPlayerPing(player)
                })
            end

            Dispatcher.cancel(call)
        end)
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

-- @local
function sync_approach(state)
    local owner = NetworkGetEntityOwner(state.unit.entity)

    TriggerClientEvent(Events.CREATE_POPULATION_TASK, owner, {
        task_id = Tasks.GOTO_ENTITY,
        net_id  = NetworkGetNetworkIdFromEntity(state.unit.entity),
        target  = NetworkGetNetworkIdFromEntity(state.unit.current_target),
    })
end

-- @local
function sync_detain(state)
    local entity_owner  = NetworkGetEntityOwner(state.unit.entity)
    local target_owner  = NetworkGetEntityOwner(state.unit.current_target)
    local target_net_id = NetworkGetNetworkIdFromEntity(state.unit.current_target)

    TriggerClientEvent(Events.CREATE_POPULATION_TASK, entity_owner, {
        task_id = Tasks.DETAIN,
        net_id  = NetworkGetNetworkIdFromEntity(state.unit.entity),
        target  = target_net_id,
        ping    = GetPlayerPing(entity_owner)
    })

    TriggerClientEvent(Events.CREATE_CUFFED_HOSTAGE, target_owner, {
        target = target_net_id,
        ping   = GetPlayerPing(target_owner)
    })
end
