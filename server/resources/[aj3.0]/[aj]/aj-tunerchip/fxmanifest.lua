fx_version 'cerulean'
game 'gta5'

description 'aj-TunerChip'
version '1.0.0'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
ui_page 'html/index.html'

shared_scripts {
	'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/nos.lua'
}

server_script 'server/main.lua'

files {
    'html/*',
}

lua54 'yes'