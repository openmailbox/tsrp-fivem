---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Provides centralized behaviors related to the map and player locations."
version "0.0.1"

dependencies {
    "bob74_ipl"
}

client_scripts {
    "@common/shared/colors.lua",
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "@common/shared/uuid.lua",
    "shared/**/*.lua",
    "client/**/*.lua"
}

server_scripts {
    "@common/shared/colors.lua",
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "@common/shared/uuid.lua",
    "shared/**/*.lua",
    "server/**/*.lua"
}

exports {
    "AddBlip",
    "FindObjects",
    "GetPedDistribution",
    "GetPlayerHistory",
    "GetVehicleDistribution",
    "GetVehicleSpawn",
    "RemoveBlip",
    "StartTracking",
    "StartEntityTracking",
    "StopTracking",
    "StopEntityTracking"
}

server_exports {
    "FindObjects",
    "StartTracking",
    "StopTracking"
}
