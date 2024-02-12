local function getInteriorByType(x, y, z, name, iplName)
	local id = 0

	if not IsIplActive(iplName) then
		RequestIpl(iplName)

		while not IsIplActive(iplName) do
			RequestIpl(iplName)
			Wait(20)
		end
	end

	while id == 0 do
		id = GetInteriorAtCoordsWithType(x, y, z, name)
		Wait(20)
	end

	return id
end


CreateThread(function()
	
	local penthouse = getInteriorByType(976.6364,70.2947,115.1641,"vw_dlc_casino_apart", "vw_casino_penthouse")
	local ks_casino_vault = getInteriorByType(946.251,43.2715,58.9172,"ks_casino_vault", "ks_casino_vault_milo_")
	local ks_casino_main = getInteriorByType(935.1050,42.5656,71.2737,"ks_casino_main", "ks_casino_main_milo_")
	local ks_casino_back = getInteriorByType(974.5600,22.5161,70.8396,"ks_casino_back", "ks_casino_back_milo_")
	local ks_casino_tunnel = getInteriorByType(930.1539,-0.2010,59.1323,"ks_casino_tunnel", "ks_casino_tunnel_milo_")

EnableInteriorProp(penthouse, "set_pent_tint_shell")
	DisableInteriorProp(penthouse, "set_pent_bar_party_1")  
	EnableInteriorProp(penthouse, "set_pent_media_bar_open")
	EnableInteriorProp(penthouse, "set_pent_spa_bar_open")
	EnableInteriorProp(penthouse, "set_pent_dealer")
	DisableInteriorProp(penthouse, "set_pent_nodealer")
	DisableInteriorProp(penthouse, "set_pent_media_bar_closed")
	DisableInteriorProp(penthouse, "set_pent_spa_bar_closed")
	DisableInteriorProp(penthouse, "set_pent_pattern_01")
	DisableInteriorProp(penthouse, "set_pent_pattern_03")
	DisableInteriorProp(penthouse, "set_pent_pattern_02")
	DisableInteriorProp(penthouse, "set_pent_pattern_04")
	DisableInteriorProp(penthouse, "set_pent_pattern_05")
	DisableInteriorProp(penthouse, "set_pent_pattern_06")
	DisableInteriorProp(penthouse, "set_pent_pattern_07")
	DisableInteriorProp(penthouse, "set_pent_pattern_08")
	EnableInteriorProp(penthouse, "set_pent_pattern_09")
	DisableInteriorProp(penthouse, "set_pent_arcade_modern")
	EnableInteriorProp(penthouse, "set_pent_arcade_retro")
	EnableInteriorProp(penthouse, "set_pent_clutter_03")
	EnableInteriorProp(penthouse, "set_pent_clutter_02")
	EnableInteriorProp(penthouse, "set_pent_clutter_01")
	DisableInteriorProp(penthouse, "set_pent_lounge_blocker")
	DisableInteriorProp(penthouse, "set_pent_guest_blocker")
	DisableInteriorProp(penthouse, "set_pent_office_blocker")
	DisableInteriorProp(penthouse, "set_pent_cine_blocker")
	DisableInteriorProp(penthouse, "set_pent_spa_blocker")
	DisableInteriorProp(penthouse, "set_pent_bar_blocker")
	DisableInteriorProp(penthouse, "set_pent_bar_party_after")
	DisableInteriorProp(penthouse, "set_pent_bar_clutter")
	EnableInteriorProp(penthouse, "set_pent_bar_party_2")
	DisableInteriorProp(penthouse, "set_pent_bar_light_0")
	DisableInteriorProp(penthouse, "set_pent_bar_light_01")
	DisableInteriorProp(penthouse, "set_pent_bar_light_02")
	DisableInteriorProp(penthouse, "set_pent_bar_party_0")
	DisableInteriorProp(penthouse, "set_pent_bar_party_1")

    SetInteriorEntitySetColor(penthouse,"set_pent_tint_shell","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_bar_party_1","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_tint_shell","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_media_bar_open","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_spa_bar_open","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_dealer","3") -- Дверцы
    SetInteriorEntitySetColor(penthouse, "set_pent_nodealer","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_media_bar_closed","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_spa_bar_closed","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_pattern_01","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_pattern_03","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_pattern_02","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_pattern_04","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_pattern_05","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_pattern_06","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_pattern_07","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_pattern_08","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_pattern_09","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_arcade_modern","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_arcade_retro","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_clutter_03","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_clutter_02","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_clutter_01","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_lounge_blocker","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_guest_blocker","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_office_blocker","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_cine_blocker","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_spa_blocker","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_bar_blocker","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_bar_party_after","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_bar_clutter","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_bar_party_2","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_bar_light_0","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_bar_light_01","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_bar_light_02","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_bar_party_0","3")
    SetInteriorEntitySetColor(penthouse, "set_pent_bar_party_1","3")
	RefreshInterior(penthouse)

	EnableInteriorProp(ks_casino_vault, "set_vault_diamonds_02")
	EnableInteriorProp(ks_casino_vault, "set_vault_diamonds_01")
	EnableInteriorProp(ks_casino_vault, "set_vault_gold_02")
	EnableInteriorProp(ks_casino_vault, "set_vault_gold_01")
	EnableInteriorProp(ks_casino_vault, "set_vault_art_02")
	EnableInteriorProp(ks_casino_vault, "set_vault_art_01")
	EnableInteriorProp(ks_casino_vault, "set_vault_cash_02")
	EnableInteriorProp(ks_casino_vault, "set_vault_cash_01")
	EnableInteriorProp(ks_casino_vault, "set_vault_dressing")
	EnableInteriorProp(ks_casino_vault, "set_spawn_group2")
	EnableInteriorProp(ks_casino_vault, "set_spawn_group1")
	DisableInteriorProp(ks_casino_vault, "set_vault_door_broken")
	EnableInteriorProp(ks_casino_vault, "set_vault_door")
	DisableInteriorProp(ks_casino_vault, "set_vault_door_closed")
	RefreshInterior(ks_casino_vault)

	EnableInteriorProp(ks_casino_main, "casino_manager_default")
	EnableInteriorProp(ks_casino_main, "casino_manager_workout")
	RefreshInterior(ks_casino_main)

	EnableInteriorProp(ks_casino_back, "casino_back_laundry_damage")
	RefreshInterior(ks_casino_back)
	
	EnableInteriorProp(ks_casino_tunnel, "set_tunnel_collapse")
	RefreshInterior(ks_casino_tunnel)
end)



-- CreateThread(function()

-- while true do

--     SetRadarAsExteriorThisFrame()

--     SetRadarAsInteriorThisFrame(`h4_fake_islandx`, vec(4700.0, -5145.0), 0, 0)

--     Wait(0)

-- end
-- end)