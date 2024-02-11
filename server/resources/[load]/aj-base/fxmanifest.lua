fx_version 'cerulean'
game 'gta5'

description 'AJ-Base'

version '3.0.0'

shared_scripts {
    'config.lua',
    'shared/locale.lua',
    'locale/en.lua',
    'locale/*.lua',
    'shared/main.lua',
    'shared/items.lua',
    'shared/jobs.lua',
    'shared/vehicles.lua',
    'shared/gangs.lua',
    'shared/weapons.lua',
    'shared/locations.lua'
}

client_script 'client/main.lua'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua',
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/style.css',
	'html/*.js'
}

escrow_ignore {
	'shared/locale.lua',
}

dependency 'oxmysql'
lua54 'yes'