name "aj-payments"
author "Jimathy"
version "v2.8.7"
description "Payment Script By Jimathy"
fx_version "cerulean"
game "gta5"
lua54 'yes'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
shared_scripts { 'config.lua', 'shared/*.lua', 'locales/*.lua' }
client_scripts { 'client/*.lua', }
server_scripts { '@oxmysql/lib/MySQL.lua', 'server/*.lua' }
shared_scripts { '@ox_lib/init.lua','config.lua', 'shared/*.lua', 'locales/*.lua' }
