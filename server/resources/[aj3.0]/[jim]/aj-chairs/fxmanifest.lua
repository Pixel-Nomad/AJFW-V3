name "aj-Chairs"
author ""
version "1.5"
description "aj-Chairs By "
fx_version "cerulean"
game "gta5"
lua54 'yes'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
shared_scripts { 'config.lua', 'shared/*.lua' }
client_scripts { 'client/*.lua' }
server_scripts { 'server/*.lua' }

escrow_ignore {
    '**/*.png',
}