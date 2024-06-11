fx_version 'adamant'

description 'Casino and Cayo Perico IPL loader by Kromstar Gaming#8228'

version '1.0'

game 'gta5'

this_is_a_map 'yes'
files {
    'stream/[house]/starter_shells_k4mb1.ytyp'
}
-- data_file 'h4_dlc_int_03_h4' 'stream/ytyp/h4_dlc_int_03_h4.ytyp'
-- data_file 'h4_dlc_int_04_h4' 'stream/ytyp/h4_dlc_int_04_h4.ytyp'
-- data_file 'h4_mph4_airstrip_interior_0_airstrip_hanger' 'stream/ytyp/h4_mph4_airstrip_interior_0_airstrip_hanger.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/[fuel]/[electric_nozzle]/electric_nozzle_typ.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/[fuel]/[electric_charger]/electric_charger_typ.ytyp'
data_file 'DLC_ITYP_REQUEST' 'starter_shells_k4mb1.ytyp'
data_file 'DLC_ITYP_REQUEST' 'x64c:/levels/gta5/interiors/int_props/int_corporate.rpf/int_corporate.ytyp'
data_file 'DLC_ITYP_REQUEST' 'x64c:/levels/gta5/interiors/int_props/int_industrial.rpf/int_industrial.ytyp'
data_file 'DLC_ITYP_REQUEST' 'x64c:/levels/gta5/interiors/int_props/int_lev_des.rpf/int_lev_des.ytyp'
data_file 'DLC_ITYP_REQUEST' 'x64c:/levels/gta5/interiors/int_props/int_residential.rpf/int_residential.ytyp'
data_file 'DLC_ITYP_REQUEST' 'x64c:/levels/gta5/interiors/int_props/int_retail.rpf/int_retail.ytyp'
data_file 'DLC_ITYP_REQUEST' 'x64c:/levels/gta5/interiors/int_props/int_services.rpf/int_services.ytyp'

file 'stream/[house]/**.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/[house]/**.ytyp'
-- --IMPORTANT For this DLC Loader to render correctly please ensure your game build is set to the latest version in your server.cfg. sv_enforceGameBuild 2189 and ensure that you are running Canary on all clients connecting--
