fx_version 'cerulean'
game 'gta5'

description 'Doorlock system for the AJFW Framework'
version '2.0.0'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
ui_page 'html/index.html'

shared_scripts {
    'config.lua',
    'configs/*.lua',
    '@aj-base/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua'
}

server_script 'server/main.lua'
client_script 'client/main.lua'

files {
	'html/*.html',
	'html/*.js',
	'html/*.css',
	'html/sounds/*.ogg',
}

lua54 'yes'