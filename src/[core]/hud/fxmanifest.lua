---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Handle modifications and additions to the in-game HUD for players."
version "0.0.1"

client_scripts {
    "@common/shared/events.lua",
    "client/**/*.lua"
}
