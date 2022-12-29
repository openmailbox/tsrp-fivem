Interaction = {}

local DEFAULT_PROMPT       = "Press ~INPUT_CONTEXT~ to interact."
local DEFAULT_PROMPT_LABEL = "interactions:default_prompt"

local exclusions    = {}
local registrations = {} -- ModelHash->Dict<String, Interaction> of registered entity interactions

-- Add a specific entity to the exclusion list. Excluded entities will NOT generate an interaction prompt.
-- @tparam number entity
function Interaction.add_exclusion(entity)
    exclusions[entity] = true
end
exports("AddExclusion", Interaction.add_exclusion)

function Interaction.check_exclusion(entity)
    return not not exclusions[entity]
end
exports("IsExcluded", Interaction.check_exclusion)

function Interaction.clear_exclusions()
    exclusions = {}
end

function Interaction.for_entity(entity)
    if not entity then return {} end

    local model   = GetEntityModel(entity)
    local results = {}

    for _, interaction in pairs(registrations[model] or {}) do
        table.insert(results, interaction)
    end

    return results
end

function Interaction.initialize()
    AddTextEntry(DEFAULT_PROMPT_LABEL, DEFAULT_PROMPT)
    SetEntityDrawOutlineColor(0, 200, 0, 100)
end

function Interaction.interact()
    local target = EntityRadar.get_current_target()

    if target < 1 or IsPlayerDead(PlayerId()) or IsPedDeadOrDying(PlayerPedId(), true) then
        return
    end

    local interactions = Interaction.for_entity(target)
    if #interactions == 0 then return end

    for name, interaction in pairs(interactions) do
        local succ, error = pcall(interaction.callback, target)

        if not succ then
            error = error or "unspecified error"
            Citizen.Trace("Error while running interaction '" .. name .. "' with entity " .. target .. ": " ..  error .. "\n")
        end
    end
end
RegisterCommand("interact", Interaction.interact, false)
RegisterKeyMapping("interact", "Interact with the current target", "keyboard", "E")

-- Used to register a new interaction with a game entity. When player looks at the model type, they will get a crosshair and prompt to interact.
-- @tparam table options
-- @tparam number options.model the entity model hash
-- @tparam string options.name a descriptive verb for this interaction
-- @tparam string options.prompt a descriptive phrase shown to the user as a prompt i.e. "open the crate"
-- @tparam function options.on_target an optional callback triggered once when the player initially targets this entity.
-- @tparam function callback behavior to execute when the player interacts with the target.
-- @treturn boolean success or failure
function Interaction.register(options, callback)
    local model_hash   = tonumber(options.model)
    local interactions = registrations[model_hash]
    local prompt_label = options.prompt and ("interactions:" .. model_hash .. "_" .. string.lower(options.name))

    if not model_hash then
        return false
    end

    if not interactions then
        interactions = {}
        registrations[model_hash] = interactions
    end

    if prompt_label then
        AddTextEntry(prompt_label, "Press ~INPUT_CONTEXT~ to " .. options.prompt .. ".")
    end

    local interaction = Interaction:new(options)

    interaction.callback     = callback
    interaction.prompt_label = prompt_label

    -- An entity can have multiple behaviors as long as they have unique names
    interactions[options.name] = interaction

    return true
end
exports("RegisterInteraction", Interaction.register)

function Interaction.remove_exclusion(entity)
    exclusions[entity] = nil
end
exports("RemoveExclusion", Interaction.remove_exclusion)

function Interaction.unregister(model, name)
    local model_hash   = tonumber(model)
    local interactions = registrations[model_hash]

    if not interactions then return end

    interactions[name] = nil

    local empty = true

    for _, _ in pairs(interactions) do
        empty = false
        break
    end

    if empty and model_hash then
        registrations[model_hash] = nil
    end
end
exports("UnregisterInteraction", Interaction.unregister)

function Interaction:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end
