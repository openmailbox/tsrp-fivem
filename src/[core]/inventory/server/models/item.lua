Item = {}

function Item.from_template(template)
    local new_item = {}

    for k, v in pairs(template) do
        new_item[k] = v
    end

    return new_item
end
