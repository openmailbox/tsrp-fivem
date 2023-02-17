---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Stuff related to prison."
version "0.0.1"

client_scripts {
    "@common/shared/events.lua",
    "client/**/*.lua"
}

server_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "@common/shared/weapons.lua",
    "server/**/*.lua"
}
