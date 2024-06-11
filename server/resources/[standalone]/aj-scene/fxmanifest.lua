fx_version 'bodacious'
game 'gta5'
author 'dullpear'
version '1.0.0'
description 'Scenes for your roleplay!'

client_scripts {
	'Client/Functions.lua',
	'Locale/*.lua',
	'Client/Fonts.lua',
	'Client/Controls.lua',
	'Client/GUI.lua',
	'Client/Scenes.lua',
	'Client/Events.lua',
	'Client/Framework.lua'
}

shared_scripts {
	'Config.lua',
}
lua54 'yes'
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'Server/Functions.lua',
	'Locale/*.lua',
	'Server/Database.lua',
	'Server/Sql.lua',
	'Server/Kvp.lua',
	'Server/Scenes.lua',
}