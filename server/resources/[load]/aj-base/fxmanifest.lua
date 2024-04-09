fx_version 'cerulean'
game 'gta5'

description 'AJ-Base'

version '3.1.0'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'

shared_scripts{
    'global/config/config.lua',
    'shared/locale.lua',
    'global/locale/en.lua',
    'global/locale/*.lua',
    'shared/main.lua',
    'data/**/*.lua',
    'global/core/sh_core.lua',
    'exports/sh_exports.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
    'global/core/sv_core.lua',
    'base/**/sv_*.lua',
    'exports/sv_exports.lua',
    'loops/**/sv_*.lua',
}

client_scripts {
    'global/core/cl_core.lua',
    'base/**/cl_*.lua',
    'exports/cl_exports.lua',
}

ui_page 'html/index.html'

files {
	'html/index.html',
	'html/style.css',
	'html/*.js'
}

dependency 'oxmysql'
lua54 'yes'