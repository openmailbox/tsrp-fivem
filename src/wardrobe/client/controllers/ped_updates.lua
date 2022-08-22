local function create(data, cb)
    local attribute = Attributes[data.attribute]
    local ped       = PlayerPedId()

    if attribute.type == AttributeTypes.COMPONENT then
        local updates = {}
        local index   = data.value - 1 -- 0-based indices internally, 1-based in UI

        if data.control == "Style" then
            SetPedComponentVariation(ped, attribute.index, index, 0, 0)

            table.insert(updates, {
                label = "Variant",
                value = 1,
                max   = math.max(GetNumberOfPedTextureVariations(ped, attribute.index, index), 1)
            })
        elseif data.control == "Variant" then
            local current_drawable = GetPedDrawableVariation(ped, attribute.index)
            SetPedComponentVariation(PlayerPedId(), attribute.index, current_drawable, index)
        end

        cb({ controls = updates })
    end
end
RegisterNUICallback(Events.CREATE_WARDROBE_PED_UPDATE, create)
