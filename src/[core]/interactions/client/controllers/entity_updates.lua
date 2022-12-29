local function on_change(bag, key, value)
    local entity = GetEntityFromStateBagName(bag)
    if not DoesEntityExist(entity) then return end

    if value then
        Interaction.register({
            entity = entity,
            name   = "Say Hello",
            prompt = "say hello"
        }, function(object_id)
            print("Interact w/ " .. object_id)
        end)
    else
        Interaction.unregister(GetEntityModel(entity), "Say Hello", entity)
    end
end
AddStateBagChangeHandler("interaction", nil, on_change)
