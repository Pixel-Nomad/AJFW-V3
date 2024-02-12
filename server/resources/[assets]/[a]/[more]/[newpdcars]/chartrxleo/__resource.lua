resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'
 
---If you leak this you smell like cheese and expired milk, if you bought this legitly i love you <3 :)

files {
    'vehicles.meta',
    'carvariations.meta',
    'carcols.meta',
    'handling.meta',
    'vehiclelayouts.meta',    -- Not Required
}

data_file 'HANDLING_FILE' 'handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'vehicles.meta'
data_file 'CARCOLS_FILE' 'carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'carvariations.meta'
data_file 'VEHICLE_LAYOUTS_FILE' 'vehiclelayouts.meta'   -- Not Required


client_script {
    'vehicle_names.lua'    -- Not Required
}