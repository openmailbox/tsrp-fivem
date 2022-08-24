-- Forward declarations
local handle_component,
      handle_model

local function create(data, cb)
    -- This isn't a constant b/c it adds an implicit dependency on file load order
    local handlers = {
        [AttributeTypes.COMPONENT] = handle_component,
        [AttributeTypes.MODEL]     = handle_model
    }

    local attribute = Attributes[data.attribute]
    local handler   = handlers[attribute.type]
    local result    = handler(attribute, data)

    cb(result)
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
    local ped   = PlayerPedId()
    local model = PedModels[data.value]
    local hash  = GetHashKey(model)

    if not HasModelLoaded(hash) then
        RequestModel(hash)

        while not HasModelLoaded(hash) do
            Citizen.Wait(10)
        end
    end

    SetPlayerModel(PlayerId(), hash)
    SetModelAsNoLongerNeeded(hash)
    SetPedDefaultComponentVariation(ped)

    if string.match(model, "freemode") then
        SetPedHeadBlendData(ped, 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0, false)
    end

    return {}
end
