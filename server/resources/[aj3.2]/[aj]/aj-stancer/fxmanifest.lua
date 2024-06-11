fx_version 'cerulean'
game 'gta5'
 
description 'Stancer kit'
version '1.0.0'
 
lua54 'yes'
 
client_scripts {
    'config.lua',
    'client.lua'
}
 
server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/script.js',
	'html/style.css',
	'html/audio/*.ogg'
}