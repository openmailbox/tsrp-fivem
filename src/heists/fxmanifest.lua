---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Provides heists at various locations."
version "0.0.1"

dependencies {
    "hostages",
    "lockpicking",
    "map",
    "population"
}

client_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "client/**/*.lua"
}

server_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "server/**/*.lua"
}
