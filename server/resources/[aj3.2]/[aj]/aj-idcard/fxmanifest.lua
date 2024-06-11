fx_version "adamant"

game "gta5"

client_scripts {
	'client.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua'
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/assets/css/main.css',
	'html/assets/css/animations.css',
	'html/assets/js/navigation.js',
	'html/assets/img/arrow_up_grey.png',
	'html/assets/img/change_down.png',
	'html/assets/img/change_none.png',
	'html/assets/img/change_up.png',
	'html/assets/img/close.png',
	'html/assets/img/company_logo_placeholder.png',
	'html/assets/img/Driving.png',
	'html/assets/img/ID_Card.png',
	'html/assets/img/Job_Card.png',
	'html/assets/img/Weapon.png'
}


lua54 'yes'