---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Allows players to use ATMs in the world to deposit cash."
version "0.0.1"

dependencies {
    "accounts",
    "interactions",
    "mysql-async"
}

client_scripts {
    "@common/shared/events.lua",
    "client/**/*.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "@common/shared/events.lua",
    "server/**/*.lua"
}

ui_page "web/dist/index.html"

files {
    "web/dist/**/*.html",
    "web/dist/**/*.js",
}
