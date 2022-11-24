---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Utilities for dealing with native markers."
version "0.0.1"

dependencies {
    "map"
}

client_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "shared/**/*.lua",
    "client/**/*.lua"
}

exports {
    "AddMarker",
    "RemoveMarker"
}
