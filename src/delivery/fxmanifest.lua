---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Provides a configurable job allowing players to deliver packages."
version "0.0.1"

dependencies {
    "characters",
    "map",
    "markers",
    "vehicles",
    "wallet"
}

client_scripts {
    "@common/shared/events.lua",
    "shared/**/*.lua",
    "client/**/*.lua"
}

server_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "shared/**/*.lua",
    "server/**/*.lua"
}
