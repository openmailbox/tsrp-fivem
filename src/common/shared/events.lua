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
Events.ON_MUMBLE_CONNECT        = "mumbleConnected"
Events.ON_MUMBLE_DISCONNECT     = "mumbleDisconnected"

-- Low-level game events
Events.CLIENT_PLAYER_COLLECT_AMBIENT_PICKUP = "CEventNetworkPlayerCollectedAmbientPickup"
Events.CLIENT_PLAYER_COLLECT_PICKUP         = "CEventNetworkPlayerCollectedPickup"
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

-- @resource banking
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

Events.CREATE_CHARACTER_GAME_SESSION = "characters:CreateGameSession"
Events.UPDATE_CHARACTER_GAME_SESSION = "characters:UpdateGameSession"

Events.ON_CHARACTER_SESSION_START = "characters:OnSessionstart" -- triggered internally as a convenience for other resources

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

-- @resource consumables
Events.CREATE_FOOD_CHARGE_AUTH = "consumables:CreateChargeAuth"
Events.UPDATE_FOOD_CHARGE_AUTH = "consumables:UpdateChargeAuth"

Events.CREATE_CONSUMABLES_REWARD = "consumables:CreateReward"

Events.CREATE_CONSUMED_ITEM = "consumables:CreateConsumed"

-- @resource delivery
Events.CREATE_DELIVERY_VEHICLE = "delivery:CreateVehicle"
Events.DELETE_DELIVERY_VEHICLE = "delivery:DeleteVehicle"
Events.UPDATE_DELIVERY_VEHICLE = "delivery:UpdateVehicle"

Events.CREATE_DELIVERY_PACKAGE_DROPOFF = "delivery:CreatePackageDropoff"

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
Events.UPDATE_INVENTORY_ITEM_USE = "inventory:UpdateItemUse"

Events.CREATE_INVENTORY_ITEM_DISCARD = "inventory:CreateItemDiscard"
Events.UPDATE_INVENTORY_ITEM_DISCARD = "inventory:UpdateItemDiscard"

Events.CREATE_INVENTORY_ITEM_ACTION = "inventory:CreateItemAction"
Events.UPDATE_INVENTORY_ITEM_ACTION = "inventory:UpdateItemAction"

Events.CREATE_INVENTORY_ITEM_UNEQUIP = "inventory:CreateItemUnequip"
Events.UPDATE_INVENTORY_ITEM_UNEQUIP = "inventory:UpdateItemUnequip"

Events.CREATE_INVENTORY_ITEM_EQUIP = "inventory:CreateItemEquip"

-- @resource keyring
Events.UPDATE_PLAYER_KEYRING = "keyring:UpdatePlayer"

Events.CREATE_KEYRING_LOCK_TOGGLE = "keyring:CreateLockToggle"
Events.UPDATE_KEYRING_LOCK_TOGGLE = "keyring:UpdateLockToggle"

-- @resource life
Events.CREATE_RESPAWN = "respawn:CreateSpawn"

Events.CREATE_WANTED_STATUS_CHANGE = "life:CreateWantedStatusChange"

-- @resource lockpicking
Events.CREATE_LOCKPICK_SESSION = "lockpicking:CreateSession"
Events.DELETE_LOCKPICK_SESSION = "lockpicking:DeleteSession"

-- @resource logging
Events.CREATE_DISCORD_LOG = "logging:CreateDiscordLog"

-- @resource map
Events.MAP_UPDATE_PLAYER = "map:UpdatePlayer"

Events.CREATE_MAP_VSPAWN_RESULT = "map:CreateVspawnResult"

-- @resource phone
Events.CREATE_PHONE_SESSION = "phone:CreateSession"
Events.DELETE_PHONE_SESSION = "phone:DeleteSession"

Events.GET_PHONE_GAME_TIME = "phone:GetGameTime"

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

-- @resource showroom
Events.CREATE_SHOWROOM_SESSION = "showroom:CreateSession"
Events.DELETE_SHOWROOM_SESSION = "showroom:DeleteSession"

Events.CREATE_SHOWROOM_PREVIEW = "showroom:CreateVehiclePreview"

Events.CREATE_SHOWROOM_ROTATION = "showroom:CreateVehicleRotation"
Events.DELETE_SHOWROOM_ROTATION = "showroom:DeleteVehicleRotation"

Events.CREATE_SHOWROOM_VEHICLE_ACTION = "showroom:CreateVehicleAction"

-- @resource stashes
Events.GET_STASHES    = "stashes:UpdateStashes"
Events.UPDATE_STASHES = "stashes:UpdateStashes"

Events.CREATE_STASH_OBJECT = "stashes:CreateStashObject"
Events.UPDATE_STASH_OBJECT = "stashes:UpdateStashObject"

Events.CREATE_STASH_OPENING = "stashes:CreateOpening"
Events.UPDATE_STASH_OPENING = "stashes:UpdateOpening"

Events.CREATE_STASH_SCORE_EVENT = "stashes:CreateScoreEvent"

-- @resource vehicles
Events.CREATE_RENTAL_VEHICLE = "vehicles:CreateRentalVehicle"

Events.CREATE_VEHICLE_PURCHASE = "vehicles:CreatePurchase"

Events.UPDATE_PLAYER_VEHICLES = "vehicles:UpdatePlayer"

Events.GET_IMPOUNDED_VEHICLES    = "vehicles:GetImpounded"
Events.UPDATE_IMPOUNDED_VEHICLES = "vehicles:UpdateImpounded"

Events.CREATE_VEHICLE_IMPOUND_SESSION = "vehicles:CreateImpoundSession"
Events.DELETE_VEHICLE_IMPOUND_SESSION = "vehicles:DeleteImpoundSession"

Events.CREATE_PARKED_VEHICLE_RETRIEVAL = "vehicles:CreateParkedRetrieval"
Events.UPDATE_PARKED_VEHICLE_RETRIEVAL = "vehicles:UpdateParkedRetrieval"

Events.CREATE_VEHICLE_SNAPSHOT = "vehicles:CreateSnapshot"
Events.UPDATE_VEHICLE_SNAPSHOT = "vehicles:UpdateSnapshot"

Events.UPDATE_VEHICLE_LIVERY = "vehicles:UpdateLivery"

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

-- @resource weapons
Events.CREATE_WEAPON_PICKUP = "weapons:CreateWeaponPickup"

Events.CREATE_AMMO_RESUPPLY = "weapons:CreateAmmoResupply"
Events.UPDATE_AMMO_RESUPPLY = "weapons:UpdateAmmoResupply"

-- @resource welcome
Events.CREATE_WELCOME_SESSION = "welcome:CreateSession"
Events.DELETE_WELCOME_SESSION = "welcome:DeleteSession"
Events.UPDATE_WELCOME_SESSION = "welcome:UpdateSession"

-- @resource zones
Events.GET_ZONES    = "zones:GetZones"
Events.UPDATE_ZONES = "zones:UpdateZones"

Events.CREATE_VISIBLE_ZONES = "zones:CreateVisible"
Events.DELETE_VISIBLE_ZONES = "zones:DeleteVisible"

Events.ON_NEW_PLAYER_ZONE = "zones:OnNewPlayerZone" -- triggered when a player's zone changes
