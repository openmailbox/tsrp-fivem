Interaction = {}

local DEFAULT_PROMPT       = "Press ~INPUT_CONTEXT~ to interact."
local DEFAULT_PROMPT_LABEL = "interactions:default_prompt"

local exclusions    = {}
local registrations = {} -- Key->Dict<String, Interaction> of registered entity or model interactions
-- TODO: This would be cleaner modeled as a hierarchy where model interactions include entity children

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
    if exclusions[entity] then return {} end

    local results = {}

    local keys = {
        "model-" .. GetEntityModel(entity),
        "entity-" .. entity
    }

    for _, key in ipairs(keys) do
        if registrations[key] then
            for _, interaction in pairs(registrations[key] or {}) do
                table.insert(results, interaction)
            end
        end
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
-- @tparam number options.model the entity model hash (supersedes options.entity)
-- @tparam number options.entity only one specific entity that should be interactive
-- @tparam string options.name a descriptive verb for this interaction
-- @tparam string options.prompt a descriptive phrase shown to the user as a prompt i.e. "open the crate"
-- @tparam function options.on_target an optional callback triggered once when the player initially targets this entity.
-- @tparam function callback behavior to execute when the player interacts with the target.
-- @treturn boolean success or failure
function Interaction.register(options, callback)
    local key = nil

    if options.model then
        key = "model-" .. options.model
    elseif options.entity then
        key = "entity-" .. options.entity
    else
        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.WARN,
            message = "Unable to generate an interaction key for unknown type."
        })

        return false
    end

    local interactions = registrations[key]
    local prompt_label = options.prompt and ("interactions:" .. key .. "_" .. string.lower(options.name))

    if not interactions then
        interactions = {}
        registrations[key] = interactions
    end

    if prompt_label then
        AddTextEntry(prompt_label, "Press ~INPUT_CONTEXT~ to " .. options.prompt .. ".")
    end

    local interaction = Interaction:new(options)

    interaction.callback     = callback
    interaction.prompt_label = prompt_label or DEFAULT_PROMPT_LABEL

    -- An entity can have multiple behaviors as long as they have unique names
    interactions[options.name] = interaction

    return true
end
exports("RegisterInteraction", Interaction.register)

function Interaction.remove_exclusion(entity)
    exclusions[entity] = nil
end
exports("RemoveExclusion", Interaction.remove_exclusion)

-- Unregister a previously registered interaction.
-- @tparam number entity If present, only interactions for the specified entity are removed.
function Interaction.unregister(model, name, entity)
    local key = nil

    if entity then
        key = "entity-" .. entity
    else
        key = "model-" .. model
    end

    local interactions = registrations[key]
    if not interactions then return end

    interactions[name] = nil

    local empty = true

    for _, _ in pairs(interactions) do
        empty = false
        break
    end

    if empty and key then
        registrations[key] = nil
    end
end
exports("UnregisterInteraction", Interaction.unregister)

function Interaction:new(o)
    o = o or {}

    setmetatable(o, self)
    self.__index = self

    return o
end
