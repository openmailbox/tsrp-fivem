---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

server_scripts {
    "@common/shared/events.lua",
    "server/**/*.lua"
}

server_exports {
    "SetPlayerInstance"
}

server_only 'yes'
