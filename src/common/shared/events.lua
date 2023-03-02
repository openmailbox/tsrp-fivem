Events = {}

-- Base FiveM things
Events.ON_CLIENT_RESOURCE_START = "onClientResourceStart"
Events.ON_CLIENT_RESOURCE_STOP  = "onClientResourceStop"
Events.ON_ENTITY_CREATED        = "entityCreated"
Events.ON_ENTITY_DAMAGED        = "entityDamaged"
Events.ON_GAME_EVENT            = "gameEventTriggered"
Events.ON_PLAYER_CONNECTING     = "playerConnecting"
Events.ON_PLAYER_DROPPED        = "playerDropped"
Events.ON_PLAYER_SPAWNED        = "playerSpawned"
Events.ON_RESOURCE_START        = "onResourceStart"
Events.ON_RESOURCE_STOP         = "onResourceStop"

-- Low-level game events
Events.CLIENT_PLAYER_COLLECT_AMBIENT_PICKUP = "CEventNetworkPlayerCollectedAmbientPickup"
Events.CLIENT_ENTITY_DAMAGE                 = "CEventNetworkEntityDamage"
Events.CLIENT_GUN_AIMED_AT                  = "CEventGunAimedAt"
Events.CLIENT_CRIME_REPORTED                = "CEventCrimeReported"

-- @resource accounts
Events.CREATE_ACCOUNT_SESSION = "accounts:CreateSession"

Events.ON_ACCOUNT_LOADED = "accounts:OnAccountLoaded" -- Sent by resource after a player account is loaded

-- @resource admin
Events.CREATE_ADMIN_ANIMATION = "admin:CreateAnimation"
Events.CREATE_ADMIN_SOUND     = "admin:CreateSound"
Events.CREATE_ADMIN_SPEECH    = "admin:CreateSpeech"
Events.CREATE_ADMIN_SCENARIO  = "admin:CreateScenario"

Events.CREATE_ADMIN_HP_ADJUST = "admin:CreateHpAdjust"

Events.CREATE_OBJECT_SPAWN = "admin:CreateObjectSpawn"
Events.UPDATE_OBJECT_SPAWN = "admin:UpdateObjectSpawn"

Events.CREATE_PED_SPAWN = "admin:CreatePedSpawn"
Events.UPDATE_PED_SPAWN = "admin:UpdatePedSpawn"

Events.FLUSH_WANTED_STATUS = "admin:FlushWantedStatus"

-- @resource atm
Events.CREATE_ATM_SESSION = "atm:CreateSession"
Events.DELETE_ATM_SESSION = "atm:DeleteSession"

Events.CREATE_ATM_DEPOSIT = "atm:CreateDeposit"
Events.UPDATE_ATM_DEPOSIT = "atm:UpdateDeposit"

Events.UPDATE_BANK_BALANCE = "atm:UpdateBankBalance"

-- @resource bounties
Events.CREATE_BOUNTY_MISSION_OFFER = "bounties:CreateMissionOffer"
Events.UPDATE_BOUNTY_MISSION_OFFER = "bounties:UpdateMissionOffer"
Events.DELETE_BOUNTY_MISSION_OFFER = "bounties:DeleteMissionOffer"

Events.CREATE_BOUNTY_TARGET_BEHAVIOR = "bounties:CreateTargetBehavior"

Events.CREATE_BOUNTY_PAYOUT = "bounties:CreatePayout"

-- @resource characters
Events.CREATE_CHARACTER_SELECT_SESSION = "characters:CreateSelectSession"
Events.DELETE_CHARACTER_SELECT_SESSION = "characters:DeleteSelectSession"

Events.CREATE_CHARACTER_AUTH_REQUEST = "characters:CreateAuthRequest"
Events.UPDATE_CHARACTER_AUTH_REQUEST = "characters:UpdateAuthRequest"

Events.CREATE_NEW_CHARACTER = "characters:CreateNewCharacter"
Events.DELETE_NEW_CHARACTER = "characters:DeleteNewCharacter"

Events.GET_CHARACTER_ROSTER    = "characters:GetRoster"
Events.UPDATE_CHARACTER_ROSTER = "characters:UpdateRoster"

Events.CREATE_FINISHED_CHARACTER = "characters:CreateFinished"
Events.UPDATE_FINISHED_CHARACTER = "characters:UpdateFinished"

Events.CREATE_CHARACTER_NAME_PROMPT = "characters:CreateNamePrompt"
Events.DELETE_CHARACTER_NAME_PROMPT = "characters:DeleteNamePrompt"

Events.CREATE_CHARACTER_NAME_VALIDATION = "characters:CreateNameValidation"
Events.UPDATE_CHARACTER_NAME_VALIDATION = "characters:UpdateNameValidation"

Events.CREATE_CHARACTER_SELECTION = "characters:CreateSelection"
Events.UPDATE_CHARACTER_SELECTION = "characters:UpdateSelection"

-- @resource chat
Events.ADD_CHAT_MESSAGE       = "chat:addMessage"
Events.ADD_CHAT_SUGGESTION    = "chat:addSuggestion"
Events.ADD_CHAT_SUGGESTIONS   = "chat:addSuggestions"
Events.CLEAR_CHAT             = "chat:clear"
Events.REMOVE_CHAT_SUGGESTION = "chat:removeSuggestion"

-- @resource chop
Events.CREATE_CHOP_MISSION_OFFER = "chop:CreateMissionOffer"
Events.DELETE_CHOP_MISSION_OFFER = "chop:DeleteMissionOffer"
Events.UPDATE_CHOP_MISSION_OFFER = "chop:UpdateMissionOffer"

Events.CREATE_CHOP_VEHICLE_DROPOFF = "chop:CreateVehicleDropoff"
Events.UPDATE_CHOP_VEHICLE_DROPOFF = "chop:UpdateVehicleDropoff"

-- @resource food
Events.CREATE_FOOD_CHARGE_AUTH = "food:CreateChargeAuth"
Events.UPDATE_FOOD_CHARGE_AUTH = "food:UpdateChargeAuth"

-- @resource heists
Events.GET_HEISTS    = "heists:Get"
Events.UPDATE_HEISTS = "heists:Update"

Events.CREATE_DAMAGED_HEIST_OBJECT = "heists:CreateDamagedObject"

Events.CREATE_CRACKED_SAFE_ATTEMPT = "heists:CreateCrackedSafeAttempt"
Events.UPDATE_CRACKED_SAFE_ATTEMPT = "heists:UpdateCrackedSafeAttempt"

-- @resouce hostages
Events.CREATE_NEW_HOSTAGE = "hostages:CreateNew"

Events.CREATE_HOSTAGE_UPDATE = "hostages:CreateUpdate"

Events.CREATE_CUFFED_HOSTAGE = "hostages:CreateCuffed"
Events.DELETE_CUFFED_HOSTAGE = "hostages:DeleteCuffed"

-- @resource hud
Events.CREATE_HUD_NOTIFICATION = "hud:CreateNotification"

Events.CREATE_HUD_HELP_MESSAGE = "hud:CreateHelpMessage"

-- @resource interactions --
Events.CREATE_INTERACTIVE_OBJECT = "interactions:CreateObject"
Events.DELETE_INTERACTIVE_OBJECT = "interactions:DeleteObject"

Events.CREATE_SCANNER_TOGGLE = "interactions:CreateScannerToggle"

-- @resource inventory
Events.CREATE_INVENTORY_SESSION = "inventory:CreateSession"
Events.DELETE_INVENTORY_SESSION = "inventory:DeleteSession"

Events.CREATE_INVENTORY_REFRESH = "inventory:CreateRefresh"
Events.UPDATE_INVENTORY_REFRESH = "inventory:UpdateRefresh"

Events.CREATE_INVENTORY_ITEM_USE = "inventory:CreateItemUse"

-- @resource life
Events.CREATE_RESPAWN = "respawn:CreateSpawn"

Events.CREATE_WANTED_STATUS_CHANGE = "life:CreateWantedStatusChange"

-- @resource lockpicking
Events.CREATE_LOCKPICK_SESSION = "lockpicking:CreateSession"
Events.DELETE_LOCKPICK_SESSION = "lockpicking:DeleteSession"

-- @resource map
Events.MAP_UPDATE_PLAYER = "map:UpdatePlayer"

Events.CREATE_MAP_VSPAWN_RESULT = "map:CreateVspawnResult"

-- @resource population
Events.UPDATE_POPULATION_PED = "population:UpdatePed"

Events.CREATE_POPULATION_TASK = "population:CreateTask"
Events.UPDATE_POPULATION_TASK = "population:UpdateTask"
Events.DELETE_POPULATION_TASK = "population:DeleteTask"

-- @resource prison
Events.CREATE_PRISON_SENTENCE = "prison:CreateSentence"
Events.UPDATE_PRISON_SENTENCE = "prison:UpdateSentence"

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

Events.CREATE_STASH_SCORE_EVENT = "stashes:CreateScoreEvent"

-- @resource wallets
Events.CREATE_WALLET_RESET = "wallet:CreateReset"

Events.UPDATE_WALLET_BALANCE = "wallet:UpdateBalance"

Events.CREATE_CASH_PICKUP = "wallet:CreateCashPickup"

-- @resource wardrobe
Events.CREATE_WARDROBE_SESSION = "wardrobe:CreateSession"
Events.DELETE_WARDROBE_SESSION = "wardrobe:DeleteSession"

Events.CREATE_WARDROBE_ROTATION = "wardrobe:CreateRotation"
Events.DELETE_WARDROBE_ROTATION = "wardrobe:DeleteRotation"

Events.CREATE_WARDROBE_CAMERA_PAN = "wardrobe:CreateCameraPan"
Events.DELETE_WARDROBE_CAMERA_PAN = "wardrobe:DeleteCameraPan"

Events.CREATE_WARDROBE_CAMERA_ZOOM = "wardrobe:CreateCameraZoom"
Events.DELETE_WARDROBE_CAMERA_ZOOM = "wardrobe:DeleteCameraZoom"

Events.CREATE_WARDROBE_PED_UPDATE = "wardrobe:CreatePedUpdate"

-- @resource welcome
Events.CREATE_WELCOME_SESSION = "welcome:CreateSession"
Events.DELETE_WELCOME_SESSION = "welcome:DeleteSession"

-- @resource zones
Events.CREATE_ZONES = "zones:CreateZones"
Events.GET_ZONES    = "zones:GetZones"
Events.UPDATE_ZONES = "zones:UpdateZones"

Events.ON_NEW_PLAYER_ZONE = "zones:OnNewPlayerZone" -- triggered when a player's zone changes
