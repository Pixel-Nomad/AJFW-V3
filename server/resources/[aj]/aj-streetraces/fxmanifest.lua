fx_version 'cerulean'
game 'gta5'

description 'AJ-StreetRaces'
version '1.3.0'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
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
