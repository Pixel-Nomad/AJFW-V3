fx_version 'cerulean'
game 'gta5'

description 'Framework Resource'
version '3.0.0'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
shared_scripts {
    '@aj-base/shared/locale.lua',
    'global/core.lua',
    'locale/en.lua',
    'locale/*.lua',
}
lua54 'yes'


server_scripts {
	'@oxmysql/lib/MySQL.lua',

    'configs/server/*.lua',
    'configs/secure/sv_*.lua',

    'server/commands/sv_*.lua',
    'server/player/**/*.lua',
    'server/callbacks/*.lua',

    'base/**/sv_*.lua',
    -- 'illegal/**/sv_*.lua',
    'game/**/sv_*.lua',
    -- 'jobs/**/sv_*.lua',
    'vehicles/**/sv_*.lua'
}

client_scripts {
    'client/shared/collection.lua',

    'configs/client/*.lua',
    'configs/secure/cl_*.lua',

    'client/player/**/*.lua',
    'client/commands/*.lua',

    'base/**/cl_*.lua',
    -- 'illegal/**/cl_*.lua',
    'game/**/cl_*.lua',
    -- 'jobs/**/cl_*.lua',
    'animations/**/cl_*.lua',
    'vehicles/**/cl_*.lua'
}

shared_scripts {
    'configs/shared/*.lua',
    
    'base/**/sh_*.lua',
    -- 'illegal/**/sh_*.lua',
    'game/**/sh_*.lua',
    -- 'jobs/**/sh_*.lua',
}

dependencies {
    'pma-voice',
	'aj-base'
}