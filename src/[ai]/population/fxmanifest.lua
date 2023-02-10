---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Handles spawning and tracking of NPCs for a specific purpose, loot tables, and related."
version "0.1.0"

client_scripts {
    "@common/shared/logging.lua",
    "@common/shared/events.lua",
    "shared/**/*.lua",
    "client/**/*.lua"
}

server_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "@common/shared/uuid.lua",
    "@common/shared/weapons.lua",
    "shared/**/*.lua",
    "server/**/*.lua"
}

server_exports {
    "AddSpawn",
    "RemoveSpawn"
}
