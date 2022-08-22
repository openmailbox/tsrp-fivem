local function create(data, cb)
    local attribute = Attributes[data.attribute]
    local ped       = PlayerPedId()

    if attribute.type == AttributeTypes.COMPONENT then
        local current_drawable = GetPedDrawableVariation(ped, attribute.index)
        local current_texture  = GetPedTextureVariation(ped, attribute.index)
        local updates          = {}

        if data.control == "Style" then
            SetPedComponentVariation(ped, attribute.index, data.value, current_texture)

            table.insert(updates, {
                label = "Variant",
                value = 1,
                max   = GetNumberOfPedTextureVariations(ped, attribute.index, current_drawable)
            })
        elseif data.control == "Variant" then
            SetPedComponentVariation(PlayerPedId(), attribute.index, current_drawable, data.value)
        end

        cb({ controls = updates })
    end
end
RegisterNUICallback(Events.CREATE_WARDROBE_PED_UPDATE, create)
