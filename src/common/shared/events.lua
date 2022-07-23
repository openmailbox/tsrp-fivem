Events = {}

-- Base FiveM things
Events.ON_CLIENT_RESOURCE_START = "onClientResourceStart"
Events.ON_CLIENT_RESOURCE_STOP  = "onClientResourceStop"
Events.ON_ENTITY_CREATED        = "entityCreated"
Events.ON_PLAYER_CONNECTING     = "playerConnecting"
Events.ON_PLAYER_DROPPED        = "playerDropped"
Events.ON_PLAYER_SPAWNED        = "playerSpawned"
Events.ON_RESOURCE_START        = "onResourceStart"
Events.ON_RESOURCE_STOP         = "onResourceStop"

-- @resource accounts
Events.CREATE_ACCOUNT_SESSION = "accounts:CreateSession"

Events.ON_ACCOUNT_LOADED = "accounts:OnAccountLoaded" -- Sent by resource after a player account is loaded

-- @resource admin
Events.CREATE_OBJECT_SPAWN = "admin:CreateObjectSpawn"
Events.UPDATE_OBJECT_SPAWN = "admin:UpdateObjectSpawn"

-- @resource atm
Events.CREATE_ATM_SESSION = "atm:CreateSession"
Events.DELETE_ATM_SESSION = "atm:DeleteSession"

Events.CREATE_ATM_DEPOSIT = "atm:CreateDeposit"
Events.UPDATE_ATM_DEPOSIT = "atm:UpdateDeposit"

Events.UPDATE_BANK_BALANCE = "atm:UpdateBankBalance"

-- @resource chat
Events.ADD_CHAT_MESSAGE       = "chat:addMessage"
Events.ADD_CHAT_SUGGESTION    = "chat:addSuggestion"
Events.ADD_CHAT_SUGGESTIONS   = "chat:addSuggestions"
Events.REMOVE_CHAT_SUGGESTION = "chat:removeSuggestion"

-- @resource interactions --
Events.CREATE_INTERACTIVE_OBJECT = "interactions:CreateObject"
Events.DELETE_INTERACTIVE_OBJECT = "interactions:DeleteObject"

-- @resource progress
Events.CREATE_PROGRESS_BAR = "progress:CreateBar"
Events.DELETE_PROGRESS_BAR = "progress:DeleteBar"

-- @resource relationships
Events.UPDATE_ENTITY_RELGROUP = "relationships:UpdateEntityRelgroup"

-- @resource stashes
Events.GET_STASHES    = "stashes:UpdateStashes"
Events.UPDATE_STASHES = "stashes:UpdateStashes"

Events.CREATE_STASH_OBJECT = "stashes:CreateStashObject"
Events.UPDATE_STASH_OBJECT = "stashes:UpdateStashObject"

Events.CREATE_STASH_OPENING = "stashes:CreateOpening"
Events.UPDATE_STASH_OPENING = "stashes:UpdateOpening"

-- @resource wallets
Events.CREATE_WALLET_RESET = "wallet:CreateReset"

Events.UPDATE_WALLET_BALANCE = "wallet:UpdateBalance"

-- @resource zones
Events.CREATE_ZONES = "zones:CreateZones"
Events.GET_ZONES    = "zones:GetZones"
Events.UPDATE_ZONES = "zones:UpdateZones"

Events.ON_NEW_PLAYER_ZONE = "zones:OnNewPlayerZone" -- triggered when a player's zone changes
