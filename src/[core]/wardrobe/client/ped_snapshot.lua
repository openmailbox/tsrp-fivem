PedSnapshot = {}

-- Forward declarations
local get_current_value,
      get_model_label,
      is_freemode_model,
      set_current_value,
      set_model

-- Record current state of all possible ped customizations for saving + later restoring.
function PedSnapshot.record(ped)
    local data = {}

    for name, attribute in pairs(Attributes) do
        local record = {}

        for k, v in pairs(attribute) do
            if k ~= "label" then
                record[k] = v
            end
        end

        record.name  = name
        record.type  = attribute.type
        record.value = get_current_value(ped, attribute)

        table.insert(data, record)
    end

    return {
        created_at = GetCloudTimeAsInt(),
        attributes = data
    }
end
exports("RecordSnapshot", PedSnapshot.record)

-- Restores a previously recorded snapshot to the given ped.
function PedSnapshot.restore(ped, snapshot)
    local is_self = ped == PlayerPedId()

    -- It's important to update the ped in a specific order to make sure i.e. the model is set before the model's components.
    table.sort(snapshot.attributes, function(a, b)
        if a.type == b.type then
            return a.index < b.index
        else
            return a.type < b.type
        end
    end)

    for _, attribute in ipairs(snapshot.attributes) do
        local current = get_current_value(ped, attribute) or {}

        for k, v in pairs(current) do
            -- Always force face update for freemode models to make sure we apply head blend. There's prolly a better way to do this.
            if v ~= attribute.value[k] or (attribute.name == "face" and is_freemode_model(ped)) then
                set_current_value(ped, attribute)

                -- Entity ID changes if model changed. We shouldn't ever need to change models on non-player peds. Just recreate them.
                if attribute.name == "model" and is_self then
                    ped = PlayerPedId()
                end
            end
        end
    end
end
exports("RestoreSnapshot", PedSnapshot.restore)

-- @local
function get_current_value(ped, attribute)
    if attribute.type == AttributeTypes.COMPONENT then
        return {
            drawable = GetPedDrawableVariation(ped, attribute.index),
            texture  = GetPedTextureVariation(ped, attribute.index)
        }
    elseif attribute.type == AttributeTypes.PROP then
        return {
            drawable = GetPedPropIndex(ped, attribute.index),
            texture = GetPedPropTextureIndex(ped, attribute.index)
        }
    elseif attribute.type == AttributeTypes.MODEL then
        local hash = GetEntityModel(ped)

        return {
            label = get_model_label(hash),
            hash  = hash
        }
    end

    return nil
end

-- @local
function get_model_label(hash)
    for _, label in ipairs(FreemodeModels) do
        if GetHashKey(label) == hash then
            return label
        end
    end

    for _, label in ipairs(PedModels) do
        if GetHashKey(label) == hash then
            return label
        end
    end

    return nil
end

-- @local
function is_freemode_model(ped)
    local label = get_model_label(GetEntityModel(ped))
    return label and string.match(label, "freemode") and true
end

-- @local
function set_current_value(ped, attrib)
    if attrib.type == AttributeTypes.COMPONENT then
        SetPedComponentVariation(ped, attrib.index, attrib.value.drawable, attrib.value.texture, 0)

        if attrib.name == "face" then
            local face = attrib.value.drawable
            SetPedHeadBlendData(ped, face, face, face, face, face, face, 0.5, 0.5, 0, false)
        end
    elseif attrib.type == AttributeTypes.PROP then
        if attrib.value.drawable > -1 then
            SetPedPropIndex(ped, attrib.index, attrib.value.drawable, attrib.value.texture, true)
        else
            ClearPedProp(ped, attrib.index)
        end
    elseif attrib.type == AttributeTypes.MODEL then
        set_model(ped, attrib.value.label, attrib.value.hash)
    end
end

-- @local
function set_model(ped, label, hash)
    if PlayerPedId() ~= ped then
        TriggerEvent(Events.LOG_MESSAGE, {
            level   = Logging.WARN,
            message = "Attempted to set the model for a ped that is not this player's."
        })

        return
    end

    if not HasModelLoaded(hash) then
        RequestModel(hash)

        while not HasModelLoaded(hash) do
            Citizen.Wait(10)
        end
    end

    SetPlayerModel(PlayerId(), hash)
    SetModelAsNoLongerNeeded(hash)
    SetPedDefaultComponentVariation(PlayerPedId())

    if string.match(label, "freemode") then
        SetPedHeadBlendData(PlayerPedId(), 0, 0, 0, 0, 0, 0, 0.5, 0.5, 0, false)
    end
end
