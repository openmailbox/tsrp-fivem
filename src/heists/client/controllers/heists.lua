local function update(data)
    for _, record in ipairs(data.heists) do
        local heist = Heist.find_by_id(record.id)

        if not heist then
            heist = Heist:new(record)
        end

        heist:update()
    end
end
RegisterNetEvent(Events.UPDATE_HEISTS, update)
