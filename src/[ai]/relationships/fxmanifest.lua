---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }

author "open_mailbox <admin@timeservedrp.com>"
description "Make NPCs engage in dynamic acts based on preset relationship groups with other NPCs (and players)."
version "1.1.1"

lua54 "yes"

client_scripts {
    "@common/shared/events.lua",
    "shared/**/*.lua",
    "client/**/*.lua"
}

server_scripts {
    "@common/shared/events.lua",
    "shared/**/*.lua",
    "server/**/*.lua"
}
