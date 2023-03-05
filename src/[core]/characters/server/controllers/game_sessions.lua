local function create(data)
    local player_id = source
    local character = Character:new(data.character)

    character:activate(player_id)

    TriggerEvent(Events.ON_CHARACTER_SESSION_START, {
        player_id = player_id,
        character = character
    })
end
RegisterNetEvent(Events.CREATE_CHARACTER_GAME_SESSION, create)

local function update(data)
    local player_id = source
    local character = Character.for_player(player_id)

    if data.snapshot then
        character.snapshot = data.snapshot
        character:save()
    end
end
RegisterNetEvent(Events.UPDATE_CHARACTER_GAME_SESSION, update)
