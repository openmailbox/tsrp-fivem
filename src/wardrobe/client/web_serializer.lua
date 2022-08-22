WebSerializer = {}

-- Forward declarations
local serialize_component

function WebSerializer:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end

-- Serialize the ped into a format that can be used to initialize the web UI.
function WebSerializer:serialize()
    local attributes = {}

    for name, details in pairs(Attributes) do
        if details.type == AttributeTypes.COMPONENT then
            table.insert(attributes, serialize_component(self.ped, name))
        end
    end

    return {
        categories = attributes
    }
end

-- @local
function serialize_component(ped, name)
    local attribute        = Attributes[name]
    local draw_count       = GetNumberOfPedDrawableVariations(ped)
    local current_drawable = GetPedDrawableVariation(ped, attribute.index)
    local current_texture  = GetPedTextureVariation(ped, attribute.index)
    local texture_count    = GetNumberOfPedTextureVariations(ped, attribute.index, current_drawable)

    return {
        label    = attribute.label,
        name     = name,
        controls = {
            {
                type  = "index",
                label = "Style",
                value = current_drawable,
                count = draw_count
            },
            {
                type  = "slider",
                label = "Variant",
                value = current_texture,
                min   = 1,
                max   = texture_count
            }
        }
    }
end
