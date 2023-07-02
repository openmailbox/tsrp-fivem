---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Things to make logging easier and more useful."
version "0.0.1"

client_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "shared/**/*.lua",
    "client/**/*.lua"
}

server_scripts {
    "@common/shared/colors.lua",
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "shared/**/*.lua",
    "server/**/*.lua"
}
