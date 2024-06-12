fx_version 'cerulean'
game 'gta5'

version '1.0.0'

shared_script {
	'@aj-base/shared/locale.lua',
	'locales/en.lua',
	'config.lua',
}

client_scripts {
	'client/client.lua'
}

server_script {
	'server/server.lua'
}

lua54 'yes'