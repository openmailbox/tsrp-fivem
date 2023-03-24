---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Stuff related to banking."
version "0.0.1"

dependencies {
    "accounts",
    "interactions",
    "mysql-async"
}

client_scripts {
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "client/**/*.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "@common/shared/events.lua",
    "@common/shared/logging.lua",
    "server/**/*.lua"
}

ui_page "web/dist/index.html"

files {
    "web/dist/**/*.html",
    "web/dist/**/*.js",
    "web/dist/**/*.css",
}

server_exports {
    "Deposit",
    "Withdraw"
}
