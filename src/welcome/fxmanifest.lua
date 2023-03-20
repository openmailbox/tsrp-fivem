---@diagnostic disable: undefined-global
fx_version "cerulean"
games { "gta5" }
lua54 "yes"

description "Provides the main menu that loads automatically after a player connects."

client_scripts {
    "@common/shared/events.lua",
    "client/**/*.lua"
}

server_scripts {
    "@common/shared/events.lua",
    "server/**/*.lua"
}

ui_page "web/index.html"

files {
    "web/**/*.html",
    "web/**/*.js",
    "web/**/*.css",
    "web/**/*.png"
}
