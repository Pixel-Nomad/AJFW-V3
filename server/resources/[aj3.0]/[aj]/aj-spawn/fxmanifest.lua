
fx_version 'cerulean'
game 'gta5'

description 'aj-Spawn'
version '1.0.0'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
shared_scripts {
	'config.lua',
	-- '@aj-houses/config.lua',
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
escrow_ignore {
    '**/*.html',
    '**/*.js',
    '**/*.css',
    '**/*.png',
}