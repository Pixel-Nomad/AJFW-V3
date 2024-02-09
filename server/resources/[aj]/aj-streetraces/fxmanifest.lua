fx_version 'cerulean'
game 'gta5'

description 'AJ-StreetRaces'
version '1.3.0'

ui_page 'html/index.html'

shared_script 'config.lua'
client_script 'client/main.lua'
server_script'server/main.lua'

files {
    'html/index.html',
    'html/index.js',
    'html/index.css',
}

dependency 'aj-base'

lua54 'yes'
