fx_version 'cerulean'
game 'gta5'

description 'AJ-Scoreboard'
version '1.2.1'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
ui_page 'html/ui.html'

shared_script 'config.lua'
client_script 'client.lua'
server_script 'server.lua'

files {
    'html/*'
}

lua54 'yes'
