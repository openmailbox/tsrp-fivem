---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Provides centralized behaviors related to the map and player locations."
version "0.0.1"

client_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "shared/**/*.lua",
    "client/**/*/.lua"
}
