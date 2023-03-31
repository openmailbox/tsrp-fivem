ItemTemplate = {}

-- Forward declarations
local format_name

local templates = {}

function ItemTemplate.for_name(name)
    return templates[format_name(name)]
end

function ItemTemplate.is_valid(name)
    return not not templates[format_name(name)]
end
exports("IsValidItem", ItemTemplate.is_valid)

function ItemTemplate.register(name, details)
    details.name = name

    templates[format_name(name)] = details

    Logging.log(Logging.TRACE, "Registered new item template for '" .. name .. ".")
end
exports("RegisterItem", ItemTemplate.register)

-- @local
function format_name(name)
    return string.lower(string.gsub(name, '%s', ''))
end
