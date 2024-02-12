fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'Assetsmap'
version '1.0'
description 'All maps/mlo in one resource'
author '9dgamer'

this_is_a_map 'yes'



files {
    -- "interiorproxies.meta",
    -- "interiorproxiesmech.meta",
    -- "interiorproxiesKFC.meta",
    'audio/bahamamamas_game.dat151.rel',
	'audio/bahamamamas_sounds.dat54.rel',
	'audio/sfx/dlc_bahamamamas/bahama_mamas_club_mix.awc',
    -- 'gabz_mrpd_timecycle.xml',
	-- 'interiorproxiesmrpd.meta',
    'gabz_timecycle_mods_1.xml',
    'tuner_meet.xml',
    "stream/int3232302352.gfx",
    -- 'interiorproxiesdriving.meta',
    'nutt_timecycle_mods_1.xml',
    
}

-- data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxies.meta'
-- data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxiesmech.meta'
-- data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxiesKFC.meta'
-- data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxiesdriving.meta'
data_file 'DLC_ITYP_REQUEST' 'stream/prison_props.ytyp'
data_file 'AUDIO_GAMEDATA' 'audio/bahamamamas_game.dat'
data_file 'AUDIO_SOUNDDATA' 'audio/bahamamamas_sounds.dat'
data_file 'AUDIO_WAVEPACK' 'audio/sfx/dlc_bahamamamas'
-- data_file 'TIMECYCLEMOD_FILE' 'gabz_mrpd_timecycle.xml'
-- data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxiesmrpd.meta'
data_file 'DLC_ITYP_REQUEST' 'stream/ch_dlc_int_02_ch.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/mcd2'
data_file 'DLC_ITYP_REQUEST' 'stream/ch_prop_ch_casino_backarea.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/ch_prop_ch_casino_main.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/ch_prop_ch_casino_vault.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/h4_dlc_int_05_h4.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/h4_prop_h4_island_02.ytyp'
data_file 'TIMECYCLEMOD_FILE' 'gabz_timecycle_mods_1.xml'
data_file 'DLC_ITYP_REQUEST' 'stream/uj_prop_tr_01/uj_prop_tr_01.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/uj_prop_tr_vehicles/uj_prop_tr_vehicles.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/uj_prop_tr_track_hoardings/uj_prop_tr_track_hoardings.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/uj_prop_tr_track_course/uj_prop_tr_track_course.ytyp'
data_file "SCALEFORM_DLC_FILE" "stream/int3232302352.gfx"
--data_file 'DLC_ITYP_REQUEST' 'stream/alamo_sea.ytyp'  ------ice lake
data_file 'TIMECYCLEMOD_FILE' 'nutt_timecycle_mods_1.xml'
data_file('DLC_ITYP_REQUEST')('stream/forest_lod.ytyp')
data_file('DLC_ITYP_REQUEST')('stream/forest_slod.ytyp')
data_file('DLC_ITYP_REQUEST')('stream/vremastered_lod.ytyp')
data_file('DLC_ITYP_REQUEST')('stream/vremastered_slod.ytyp')

client_scripts {
    'client.lua',
    -- "gabz_mrpd_entitysets.lua",
    "main.lua",
    'clientdrift.lua',
    'cayo_perico_entitysets.lua',
    --'xnArenaclient.lua',
    --'xnArenaconfig.lua',
}
