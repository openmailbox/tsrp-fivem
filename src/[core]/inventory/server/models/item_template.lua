ItemTemplate = {}

local templates = {}

function ItemTemplate.for_name(name)
    return templates[string.lower(string.gsub(name, '%s', ''))]
end

function ItemTemplate.register(name, details)
    details.name = name
    templates[string.lower(string.gsub(name, '%s', ''))] = details
end
exports("RegisterItem", ItemTemplate.register)
