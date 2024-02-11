fx_version 'cerulean'
game 'gta5'

description 'AJ-Menu'
version '1.2.0'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
client_script 'client/main.lua'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/script.js',
    'html/style.css'
}

lua54 'yes'
