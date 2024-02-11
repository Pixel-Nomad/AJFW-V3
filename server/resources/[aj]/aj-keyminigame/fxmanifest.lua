fx_version 'cerulean'
game 'gta5'

description 'AJ-KeyMiniGame'
version '1.2.0'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
ui_page 'html/index.html'

client_script 'client/main.lua'

files {
    'html/index.html',
    'html/app.js',
    'html/style.css',
}

lua54 'yes'
