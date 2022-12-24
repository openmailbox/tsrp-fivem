-- Forward declarations
local handle_component,
      handle_model,
      handle_prop

local function create(data, cb)
    -- This isn't a constant b/c it adds an implicit dependency on file load order
    local handlers = {
        [AttributeTypes.COMPONENT] = handle_component,
        [AttributeTypes.MODEL]     = handle_model,
        [AttributeTypes.PROP]      = handle_prop
    }

    local attribute = Attributes[data.attribute]
    local handler   = handlers[attribute.type]
    local result    = handler(attribute, data)

    cb(result or {})
end
RegisterNUICallback(Events.CREATE_WARDROBE_PED_UPDATE, create)

-- @local
function handle_component(attribute, data)
    local ped     = PlayerPedId()
    local updates = {}
    local index   = data.value - 1 -- 1-based indices in the UI

    if data.control == "Style" then
        SetPedComponentVariation(ped, attribute.index, index, 0, 0)

        local current_texture = GetPedTextureVariation(ped, attribute.index)

        table.insert(updates, {
            label = "Variant",
            value = current_texture + 1,
            min   = 1,
            max   = GetNumberOfPedTextureVariations(ped, attribute.index, index)
        })
    elseif data.control == "Variant" then
        local current_drawable = GetPedDrawableVariation(ped, attribute.index)
        SetPedComponentVariation(ped, attribute.index, current_drawable, index, 0)
    end

    return { controls = updates }
end

-- @local
function handle_model(_, data)
    local model, control, count

    if data.control == "Citizens" then
        control = "Locals"
        count   = #PedModels
        model   = FreemodeModels[data.value]
    elseif data.control == "Locals" then
        control = "Citizens"
        count   = #FreemodeModels
        model   = PedModels[data.value]
    else
        return
    end

    local hash = GetHashKey(model)

    if not HasModelLoaded(hash) then
        RequestModel(hash)

        while not HasModelLoaded(hash) do
            Citizen.Wait(10)
        end
    end

    SetPlayerModel(PlayerId(), hash)
    SetModelAsNoLongerNeeded(hash)
    SetPedDefaultComponentVariation(PlayerPedId())

    if string.match(model, "freemode") then
        SetPedHeadBlendData(PlayerPedId(), 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0, false)
    end

    return {
        controls = {
            {
                type  = "index",
                label = control,
                value = -1,
                count = count
            }
        }
    }
end

-- @local
function handle_prop(attribute, data)
    local ped     = PlayerPedId()
    local updates = {}
    local index   = data.value

    if data.control == "Visible" then
        if data.value then
            index = 0

            SetPedPropIndex(ped, attribute.index, index, 0, true)

            table.insert(updates, {
                label = "Variant",
                value = 1,
                min   = 1,
                max   = GetNumberOfPedPropTextureVariations(ped, attribute.index, index)
            })
        else
            index = -1
            ClearPedProp(ped, attribute.index)

            table.insert(updates, {
                label = "Variant",
                max   = 0
            })
        end

        table.insert(updates, {
            label = "Style",
            value = index + 1 -- 1-based indices in the UI
        })
    else
        index = data.value - 1

        table.insert(updates, {
            label = "Visible",
            value = true
        })
    end

    if data.control == "Style" then
        SetPedPropIndex(ped, attribute.index, index, 0, true)

        local current_texture = GetPedPropTextureIndex(ped, attribute.index)

        table.insert(updates, {
            label = "Variant",
            value = current_texture + 1,
            min   = 1,
            max   = GetNumberOfPedPropTextureVariations(ped, attribute.index, index)
        })
    elseif data.control == "Variant" then
        local current_drawable = GetPedPropIndex(ped, attribute.index)
        SetPedPropIndex(ped, attribute.index, current_drawable, index, true)
    end

    return { controls = updates }
end
