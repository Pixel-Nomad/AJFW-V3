fx_version 'cerulean'
game 'gta5'
 
description 'AJ-REST_API'
version '1.0.0'
 
lua54 'yes'

shared_scripts {
    'config.lua',
    'global/shared.lua'
}
 
server_scripts {
    'private.lua',
    'core/oAuth.lua',
    'codes.lua',
    'get/**/*.lua',
    'post/**/*.lua'
}