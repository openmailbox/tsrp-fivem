ItemTemplate = {}

local templates = {}

function ItemTemplate.for_name(name)
    return templates[name]
end

function ItemTemplate.register(name, details)
    details.name = name
    templates[name] = details
end
exports("RegisterItem", ItemTemplate.register)

ItemTemplate.register("Test Object", {
    description = "An unremarkable item."
})
