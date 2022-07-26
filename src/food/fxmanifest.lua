---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Provides interactions with world objects so players can regain health by eating food."
version "0.0.1"

dependencies {
    "interactions"
}

client_scripts {
    "@common/shared/events.lua",
    "client/**/*.lua"
}
