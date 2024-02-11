
fx_version 'cerulean'
game 'gta5'

description 'aj-Spawn'
version '1.0.0'

shared_scripts {
	'config.lua',
	-- '@aj-houses/config.lua',
	'@aj-apartments/config.lua'
}

client_script 'client.lua'
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/style.css',
	'html/script.js',
	'html/reset.css',
	'html/*.png',
}

lua54 'yes'
