ItemTemplate = {}

local templates = {}

function ItemTemplate.for_name(name)
    return templates[string.lower(name)]
end

function ItemTemplate.register(name, details)
    details.name = name
    templates[string.lower(name)] = details
end
exports("RegisterItem", ItemTemplate.register)
