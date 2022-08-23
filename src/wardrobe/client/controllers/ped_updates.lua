local function create(data, cb)
    local attribute = Attributes[data.attribute]
    local ped       = PlayerPedId()

    if attribute.type == AttributeTypes.COMPONENT then
        local updates = {}
        local index   = data.value - 1 -- 1-based indices in the UI

        if data.control == "Style" then
            SetPedComponentVariation(ped, attribute.index, index, 0, 0)

            local current_texture  = GetPedTextureVariation(ped, attribute.index)

            table.insert(updates, {
                label = "Variant",
                value = current_texture + 1,
                min   = 1,
                max   = GetNumberOfPedTextureVariations(ped, attribute.index, index)
            })
        elseif data.control == "Variant" then
            local current_drawable = GetPedDrawableVariation(ped, attribute.index)
            SetPedComponentVariation(PlayerPedId(), attribute.index, current_drawable, index, 0)
        end

        cb({ controls = updates })
    end
end
RegisterNUICallback(Events.CREATE_WARDROBE_PED_UPDATE, create)
