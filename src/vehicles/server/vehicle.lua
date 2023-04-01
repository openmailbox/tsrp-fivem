Vehicle = {}

function Vehicle.from_id(id, callback)
    MySQL.Async.fetchAll(
        "SELECT * FROM vehicles WHERE id = @id",
        { ["@id"] = id },
        function(results)
            callback(results and results[1])
        end
    )
end

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

function Vehicle.touch(id)
    MySQL.Async.execute(
        "UPDATE vehicles SET last_seen_at = NOW() WHERE id = @id",
        { ["@id"] = id },
        function(rows_changed)
            if rows_changed == 0 then
                Logging.log(Logging.WARN, "Unable to update last_seen_at for vehicle " .. id .. ".")
            end
        end
    )
end
