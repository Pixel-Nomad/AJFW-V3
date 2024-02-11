fx_version 'cerulean'
game 'gta5'

description 'UI_TEXT'
version '2.0.0'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
client_script 'client.lua'
ui_page('html/ui.html')

files {'html/ui.html', 'html/script.js', 'html/style.css'}

lua54 'yes'