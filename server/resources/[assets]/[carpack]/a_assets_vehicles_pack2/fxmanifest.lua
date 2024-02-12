fx_version 'cerulean'
game { 'gta5' }

name 'Car Pack'
version '1.0'
description 'Car Pack'

files{
    'stream/**/vehicles.meta',
    'stream/**/carvariations.meta',
    'stream/**/carcols.meta',
    'stream/**/vehiclelayouts.meta'
}


data_file 'VEHICLE_METADATA_FILE' 'stream/data/**/vehicles.meta'
data_file 'CARCOLS_FILE' 'stream/data/**/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'stream/data/**/carvariations.meta'
data_file 'VEHICLE_LAYOUTS_FILE' 'stream/data/**/vehiclelayouts.meta'
