local RELATIONSHIPS = {
    Companion   = 0,
    Respect     = 1,
    Like        = 2,
    Neutral     = 3,
    Dislike     = 4,
    Hate        = 5,
    Pedestrians = 255
}

local function create(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    for _, group in ipairs(Config.CustomRelationshipGroups) do
        if not DoesRelationshipGroupExist(GetHashKey(group)) then
            AddRelationshipGroup(group)
        end
    end

    for _, relationship in ipairs(Config.Relationships) do
        for _, group in ipairs(relationship.groups) do
            local g = GetHashKey(group)

            for _, other in ipairs(relationship.groups) do
                if other ~= group then
                    local o = GetHashKey(other)
                    SetRelationshipBetweenGroups(RELATIONSHIPS[relationship.nature], g, o)
                    SetRelationshipBetweenGroups(RELATIONSHIPS[relationship.nature], o, g)
                end
            end
        end
    end
end
AddEventHandler(Events.ON_CLIENT_RESOURCE_START, create)

local function delete(resource_name)
    if GetCurrentResourceName() ~= resource_name then return end

    for _, group in ipairs(Config.CustomRelationshipGroups) do
        local hash = GetHashKey(group)

        if DoesRelationshipGroupExist(hash) then
            RemoveRelationshipGroup(hash)
        end
    end
end
AddEventHandler(Events.ON_RESOURCE_STOP, delete)
