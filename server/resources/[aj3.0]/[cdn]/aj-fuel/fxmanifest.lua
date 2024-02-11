fx_version 'cerulean'
game 'gta5'
author 'https://www.github.com/CodineDev' -- Base Refueling System: (https://github.com/InZidiuZ/aj-fuel), other code by Codine (https://www.github.com/CodineDev).
description 'aj-fuel'
version '2.1.9'
server_script '@aj-framework-errors/error_sv.lua'
client_script '@aj-framework-errors/error_cl.lua'
client_scripts {
    '@PolyZone/client.lua',
    'client/fuel_cl.lua',
    'client/electric_cl.lua',
    'client/station_cl.lua',
    'client/utils.lua'
}

server_scripts {
    'server/fuel_sv.lua',
    'server/station_sv.lua',
    'server/electric_sv.lua',
    '@oxmysql/lib/MySQL.lua',
}

shared_scripts {
    'shared/config.lua',
    '@aj-base/shared/locale.lua',
    -- '@ox_lib/init.lua', -- OX_Lib, only line this in if you have ox_lib and are using them.
    'locales/en.lua', -- English Locales
    -- 'locales/de.lua', -- German / Deutsch Locales
    -- 'locales/fr.lua', -- French / Français Locales
    -- 'locales/es.lua', -- Spanish / Español / Española Locales
    -- 'locales/ee.lua', -- Estonian Locales
}

exports { -- Call with exports['aj-fuel']:GetFuel or exports['aj-fuel']:SetFuel
    'GetFuel',
    'SetFuel'
}

lua54 'yes'

dependencies { -- Make sure these are started before aj-fuel in your server.cfg!
    'PolyZone',
    'interact-sound',
    -- aj-base Functionality (Input, Target, Menu)
    'aj-target',
    'aj-input',
    'aj-menu',
    -- QBox | Overextended Functionalities (Input, Progressbar, Target, Menu etc.)
    -- 'ox_lib', -- Ox Library
    -- 'ox_target',
}

data_file 'DLC_ITYP_REQUEST' 'stream/[electric_nozzle]/electric_nozzle_typ.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/[electric_charger]/electric_charger_typ.ytyp'

provide 'cdn-syphoning' -- This is used to override cdn-syphoning(https://github.com/CodineDev/cdn-syphoning) if you have it installed. If you don't have it installed, don't worry about this. If you do, we recommend removing it and using this instead.
