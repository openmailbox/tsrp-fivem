WebSerializer = {}

-- Forward declarations
local find_member,
      serialize_component,
      serialize_models,
      serialize_prop

function WebSerializer:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

-- Serialize the ped into a format that can be used to initialize the web UI.
function WebSerializer:serialize()
    local attributes = {}
    local sfunc

    for name, details in pairs(Attributes) do
        sfunc = nil

        if details.type == AttributeTypes.COMPONENT then
            sfunc = serialize_component
        elseif details.type == AttributeTypes.MODEL then
            sfunc = serialize_models
        elseif details.type == AttributeTypes.PROP then
            sfunc = serialize_prop
        end

        if sfunc then
            local data = sfunc(self.ped, name)

            if data then
                table.insert(attributes, data)
            end
        end
    end

    table.sort(attributes, function (a, b)
        if a.type == b.type then
            return a.index < b.index
        else
            return a.type < b.type
        end
    end)

    return {
        categories = attributes
    }
end

-- @local
function find_member(collection, target)
    for i, m in ipairs(collection) do
        if GetHashKey(m) == target then
            return i
        end
    end

    return nil
end

-- @local
function serialize_component(ped, name)
    local attribute        = Attributes[name]
    local draw_count       = GetNumberOfPedDrawableVariations(ped, attribute.index)
    local current_drawable = GetPedDrawableVariation(ped, attribute.index)
    local current_texture  = GetPedTextureVariation(ped, attribute.index)
    local texture_count    = GetNumberOfPedTextureVariations(ped, attribute.index, current_drawable)

    -- Don't display if there's 0 options or only 1 drawable with a single texture option.
    if draw_count < 1 or (texture_count == 1 and draw_count == 1) then
        return
    end

    return {
        label    = attribute.label,
        type     = attribute.type,
        index    = attribute.index,
        name     = name,
        controls = {
            {
                type  = "index",
                label = "Style",
                value = current_drawable + 1, -- 1-based indices in the UI
                count = draw_count
            },
            {
                type  = "slider",
                label = "Variant",
                value = current_texture + 1,
                min   = 1,
                max   = texture_count
            }
        }
    }
end

-- @local
function serialize_models(ped, name)
    local attribute  = Attributes[name]
    local model      = GetEntityModel(ped)
    local freemode_i = find_member(FreemodeModels, model)
    local ped_i      = find_member(PedModels, model)

    return {
        label    = attribute.label,
        type     = attribute.type,
        index    = attribute.index,
        name     = name,
        controls = {
            {
                type  = "index",
                label = "Citizens",
                value = freemode_i,
                count = #FreemodeModels
            },
            {
                type  = "index",
                label = "Locals",
                value = ped_i,
                count = #PedModels
            }
        }
    }
end

-- @local
function serialize_prop(ped, name)
    local attribute        = Attributes[name]
    local draw_count       = GetNumberOfPedPropDrawableVariations(ped, attribute.index)
    local current_drawable = GetPedPropIndex(ped, attribute.index)
    local current_texture  = GetPedPropTextureIndex(ped, attribute.index)
    local texture_count    = GetNumberOfPedPropTextureVariations(ped, attribute.index, current_drawable)

   if draw_count < 1 then
        return
    end

    return {
        label    = attribute.label,
        type     = attribute.type,
        index    = attribute.index,
        name     = name,
        controls = {
            {
                type  = "switch",
                label = "Visible",
                value = current_drawable > -1
            },
            {
                type  = "index",
                label = "Style",
                value = current_drawable + 1, -- 1-based indices in the UI
                count = draw_count
            },
            {
                type  = "slider",
                label = "Variant",
                value = current_texture + 1,
                min   = 1,
                max   = texture_count
            }
        }
    }
end
