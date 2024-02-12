fx_version 'cerulean'
game { 'gta5' }

name 'Addon Weapons'
version '1.0'
description 'Addon Weapons'
 
files {
	'stream/data/**weaponcomponents.meta',
	'stream/data/**weaponarchetypes.meta',
	'stream/data/**weaponanimations.meta',
	'stream/data/**pedpersonality.meta',
	'stream/data/**weaponsaddon.meta',
	'weapons.meta'
	}

	data_file 'WEAPONCOMPONENTSINFO_FILE' 'stream/data/**weaponcomponents.meta'
	data_file 'WEAPON_METADATA_FILE' 'stream/data/**weaponarchetypes.meta'
	data_file 'WEAPON_ANIMATIONS_FILE' 'stream/data/**weaponanimations.meta'
	data_file 'WEAPONINFO_FILE' 'stream/data/**pedpersonality.meta'
	data_file 'WEAPONINFO_FILE' 'stream/data/**weaponsaddon.meta'
	data_file 'WEAPONINFO_FILE_PATCH' 'weapons.meta'
