fx_version 'cerulean'
lua54 'yes'
game 'gta5'

author 'ajfw'
description 'Dependency for creating progressbars in AJ-Core.'
version '1.0.0'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
ui_page 'html/index.html'

client_script 'client.lua'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}
