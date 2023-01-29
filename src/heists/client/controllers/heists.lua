local function update(data)
    for _, record in ipairs(data.heists) do
        local heist = Heist.find_by_id(record.id)

        if not heist then
            heist = Heist:new()
            heist:initialize()
        end

        heist:update(record)
    end
end
RegisterNetEvent(Events.UPDATE_HEISTS, update)
