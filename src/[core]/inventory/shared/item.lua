Item = {}

function Item.from_template(template)
    local new_item = { quantity = 1 }

    for k, v in pairs(template) do
        new_item[k] = v
    end

    return new_item
end
