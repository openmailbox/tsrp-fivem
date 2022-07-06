---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Tools for performing various administrative functions on or in the server."
version "0.0.1"

server_scripts {
    "@common/shared/colors.lua",
    "@common/shared/events.lua",
    "server/**/*.lua"
}
