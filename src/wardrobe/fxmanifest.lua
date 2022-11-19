---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }
lua54 "yes"

author "open_mailbox <dev@open-mailbox.com>"
description "Provides user interface for character customization."
version "0.0.1"

dependencies {
    --"mysql-async",
}

client_scripts {
    "@common/shared/events.lua",
    "@common/shared/ped_models.lua",
    "client/**/*.lua"
}

ui_page "web-vite/dist/index.html"

files {
    "web-vite/dist/**/*.html",
    "web-vite/dist/**/*.js",
    "web-vite/dist/**/*.css",
}

exports {
}

server_exports {
}
