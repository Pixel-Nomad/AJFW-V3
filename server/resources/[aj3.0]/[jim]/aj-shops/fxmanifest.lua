name "aj-Shops"
author ""
version "2.1"
description "Shop Script By "
fx_version "cerulean"
game "gta5"
lua54 'yes'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
shared_scripts { 'config.lua', 'shared/*.lua',  }
client_scripts { 'client.lua', }
server_scripts { '@oxmysql/lib/MySQL.lua', 'server.lua', }

shared_script '@ox_lib/init.lua'

--client_script '@warmenu/warmenu.lua'