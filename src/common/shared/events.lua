Events = {}

-- Base FiveM things
Events.ON_CLIENT_RESOURCE_START = "onClientResourceStart"
Events.ON_CLIENT_RESOURCE_STOP  = "onClientResourceStop"
Events.ON_ENTITY_CREATED        = "entityCreated"
Events.ON_PLAYER_CONNECTING     = "playerConnecting"
Events.ON_PLAYER_DROPPED        = "playerDropped"
Events.ON_RESOURCE_START        = "onResourceStart"
Events.ON_RESOURCE_STOP         = "onResourceStop"

-- @resource accounts
Events.CREATE_ACCOUNT_SESSION = "accounts:CreateSession"

-- @resource admin
Events.CREATE_OBJECT_SPAWN = "admin:CreateObjectSpawn"
Events.UPDATE_OBJECT_SPAWN = "admin:UpdateObjectSpawn"

-- @resource chat
Events.ADD_CHAT_MESSAGE       = "chat:addMessage"
Events.ADD_CHAT_SUGGESTION    = "chat:addSuggestion"
Events.ADD_CHAT_SUGGESTIONS   = "chat:addSuggestions"
Events.REMOVE_CHAT_SUGGESTION = "chat:removeSuggestion"

-- @resource relationships
Events.UPDATE_ENTITY_RELGROUP = "relationships:UpdateEntityRelgroup"

-- @resource stash_hunt
Events.CREATE_STASH_OBJECT = "stash_hunt:CreateStashObject"
Events.UPDATE_STASH_OBJECT = "stash_hunt:UpdateStashObject"
Events.CREATE_STASH_EVENTS = "stash_hunt:CreateEvents"