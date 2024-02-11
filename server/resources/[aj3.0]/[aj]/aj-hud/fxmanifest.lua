fx_version 'cerulean'
game 'gta5'

description 'aj-hud'
version '2.1.0'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
shared_scripts {
	'@aj-base/shared/locale.lua',
	'locales/en.lua',
	'config.lua',
	'uiconfig.lua'
}

client_script 'client.lua'
server_script 'server.lua'
lua54 'yes'
use_fxv2_oal 'yes'

ui_page 'html/index.html'

files {
	'html/*',
}
