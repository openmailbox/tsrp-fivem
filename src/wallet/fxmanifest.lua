---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Provides an interface for player cash wallets."
version "0.0.1"

client_scripts {
    "@common/shared/events.lua",
    "@common/shared/objects.lua",
    "client/**/*.lua"
}

server_scripts {
    "@common/shared/events.lua",
    "@common/shared/colors.lua",
    "server/**/*.lua"
}

server_exports {
    "AdjustCash",
    "GetPlayerBalance"
}
