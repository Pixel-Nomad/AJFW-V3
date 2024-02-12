fx_version 'cerulean'
game { 'gta5' }

name 'Melee Addon Weapon'
version '1.0'
description 'Melee Addon Weapon'
 
files {
	'stream/data/**/contentunlocks.meta',
	'stream/data/**/loadouts.meta',
	'stream/data/**/pedpersonality.meta',
	'stream/data/**/shop_weapon.meta',
	'stream/data/**/weaponanimations.meta',
	'stream/data/**/weaponarchetypes.meta',
	'stream/data/**/weapons.meta'
	}

	data_file 'WEAPONINFO_FILE' 'stream/data/**/weapons.meta'
	data_file 'WEAPON_METADATA_FILE' 'stream/data/**/weaponarchetypes.meta'
	data_file 'WEAPON_SHOP_INFO' 'stream/data/**/shop_weapon.meta'
	data_file 'WEAPON_ANIMATIONS_FILE' 'stream/data/**/weaponanimations.meta'
	data_file 'CONTENT_UNLOCKING_META_FILE' 'stream/data/**/contentunlocks.meta'
	data_file 'LOADOUTS_FILE' 'stream/data/**/loadouts.meta'
	data_file 'PED_PERSONALITY_FILE' 'stream/data/**/pedpersonality.meta'
