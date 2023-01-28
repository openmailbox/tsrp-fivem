---@diagnostic disable: undefined-global

fx_version "cerulean"
games { "gta5" }

server_scripts {
    "@common/shared/events.lua",
    "server/**/*.lua"
}

client_scripts {
    "@common/shared/events.lua",
    "@common/client/scaleform.lua",
    "client/**/*.lua"
}

exports {
    "StartLockpicking"
}

ui_page "web/index.html"

files {
    "web/**/*.wav",
    "web/**/*.html",
    "web/**/*.js",
    "web/**/*.css",
    "web/**/*.png"
}
