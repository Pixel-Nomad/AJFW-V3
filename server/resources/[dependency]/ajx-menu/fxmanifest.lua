fx_version "cerulean"
games { 'gta5' }

name "ajx-menu"
description "AJFW menu"

ui_page "./ui/index.html"

files {
    "./ui/index.html",
    "./ui/main.css",
    "./ui/main.js",
}

client_script "client.lua"
lua54 'yes'
