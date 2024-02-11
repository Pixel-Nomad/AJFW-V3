fx_version 'cerulean'
game 'gta5'

description 'AJ-Input'
version '1.2.0'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
client_scripts {
    'client/*.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/styles/*.css',
    'html/script.js'
}

lua54 'yes'
