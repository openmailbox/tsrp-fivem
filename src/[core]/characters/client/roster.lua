Roster = {}

local POSITIONS = {
    {
        coords    = vector4(-803.1011, 171.6763, 72.8446, 299.0097),
        animation = { dictionary = "timetable@ron@ig_3_couch", name = "base" }
    }
}

local characters = {}

function Roster.cleanup()
    for _, char in ipairs(characters) do
        char:remove()
    end

    characters = {}
end

function Roster.hide()
    for _, c in ipairs(characters) do
        c:hide()
    end
end

function Roster.update(data)
    Roster.cleanup()

    for i, record in ipairs(data) do
        local char = Character:new(record)

        char:assign_position(POSITIONS[i])

        table.insert(characters, char)
    end
end
