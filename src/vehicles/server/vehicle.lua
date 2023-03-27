Vehicle = {}

function Vehicle.from_impound(player_id, callback)
    local character = exports.characters:GetPlayerCharacter(player_id)

    MySQL.Async.fetchAll(
        [[SELECT vehicles.*, first_name, last_name FROM vehicles
          INNER JOIN characters ON characters.id = vehicles.character_id
          WHERE character_id = @char_id]],
        {
            ["@char_id"] = character.id
        },
        function(results)
            if #results == 0 then
                callback({})
                return
            end

            local map = {}

            for _, row in ipairs(results) do
                map[row.id] = row
            end

            local impounded = {}
            local active    = PlayerVehicle.active()

            -- remove any active vehicles from the list
            for _, vehicle in ipairs(active) do
                if vehicle.id and map[vehicle.id] then
                    map[vehicle.id] = nil
                end
            end

            for _, vehicle in pairs(map) do
                table.insert(impounded, vehicle)
            end

            callback(impounded)
        end
    )
end
