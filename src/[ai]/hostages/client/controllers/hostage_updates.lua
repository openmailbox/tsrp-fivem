local BAG_NAME = "hostage_state"

-- TDOO: Does this trigger when entity newly enters player scope and BAG_NAME is set?
local function on_change(bag, _, value)
    local entity = GetEntityFromStateBagName(bag)

    if not DoesEntityExist(entity) then return end
    if not NetworkGetEntityOwner(entity) == PlayerId() then return end

    local net_id  = PedToNet(entity)
    local hostage = Hostage.for_net_id(net_id)

    if not hostage then
        hostage = Hostage:new({
            entity = entity,
            net_id = net_id
        })

        hostage:initialize()
    end

    hostage:move_to(value)
end
AddStateBagChangeHandler(BAG_NAME, nil, on_change)
