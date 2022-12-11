---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Provides initial and respawn behavior when players connect."
version "0.0.1"

dependencies {
    "spawnmanager"
}

client_scripts {
    "@common/shared/logging.lua",
    "@common/shared/events.lua",
    "@common/shared/ped_models.lua",
    "client/**/*.lua"
}

server_scripts {
    "@common/shared/events.lua",
    "@common/shared/colors.lua",
    "server/**/*.lua"
}
