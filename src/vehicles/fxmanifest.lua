---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Provides rental vehicles."
version "0.1.0"

dependencies {
    "banking",
    "characters",
    "keyring",
    "map",
    "markers",
    "showroom",
    "wallet",
    "zones"
}

client_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "@common/shared/vehicle_classes.lua",
    "client/**/*.lua"
}

server_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "server/**/*.lua"
}
