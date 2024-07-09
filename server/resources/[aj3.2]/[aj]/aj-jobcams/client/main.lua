local menuActive = false
local menuCoords = nil
Citizen.CreateThread(function()
	for k, v in pairs(Config.WatchAreas) do
		for a, b in pairs(v.areas) do
			if v.interaction.Target.Enable then
				if GetResourceState('ox_target') == 'started' or GetResourceState('aj-target') == 'started' or GetResourceState('pa-target') == 'started' then
					if type(v.job) == "table" then
						for c, d in pairs(v.job) do
							exports['aj-target']:AddBoxZone(a .. "_g_boxZone_target", vector3(b.coords.x, b.coords.y, b.coords.z - 1), b.scale, b.width, {
								name = a .. "_g_boxZone_target",
								heading = b.heading,
								debugPoly = true,
								minZ = b.coords.z - 1,
								maxZ = b.coords.z + 1,
							}, {
								options = {
									{
										num = 1,
										icon = v.interaction.Target.Icon,
										label = b.label,
										action = function()
											if b.type == "dashcam" then
												openDashcams(v.job, v.dashcamVehicles.Enable, v.dashcamVehicles.Vehicles)
											else
												openBodycams(v.job)
											end
										end,
										job = d,
									}
								},
								distance = v.interaction.Target.Distance,
							})
						end
					else
						exports['aj-target']:AddBoxZone(a .. "_g_boxZone_target", vector3(b.coords.x, b.coords.y, b.coords.z - 1), b.scale, b.width, {
							name = a .. "_g_boxZone_target",
							heading = b.heading,
							debugPoly = true,
							minZ = b.coords.z - 1,
							maxZ = b.coords.z + 1,
						}, {
							options = {
								{
									num = 1,
									icon = v.interaction.Target.Icon,
									label = b.label,
									action = function()
										if b.type == "dashcam" then
											openDashcams(v.job, v.dashcamVehicles.Enable, v.dashcamVehicles.Vehicles)
										else
											openBodycams(v.job)
										end
									end,
									job = v.job,
								}
							},
							distance = v.interaction.Target.Distance,
						})
					end
				end
			end
		end
	end
end)

closestArea = {}
local showTextUI = false
Citizen.CreateThread(function()
	while true do
		local sleep = 1000
		playerPed = PlayerPedId()
		playerCoords = GetEntityCoords(playerPed)
		if not closestArea.id then
			for k, v in pairs(Config.WatchAreas) do
				for a, b in pairs(v.areas) do
					if v.interaction.DrawText.Enable then
						local dist = #(playerCoords - b.coords)
						if dist <= v.interaction.DrawText.Distance then
							if type(v.job) == "table" then
								for c, d in pairs(v.job) do
									if d == GetPlayerJob() then
										function currentShow()
											v.interaction.DrawText.Show(b.label)
											showTextUI = true
										end
										function currentHide()
											v.interaction.DrawText.Hide()
										end
										closestArea = {id = k, distance = dist, maxDist = v.interaction.DrawText.Distance, data = {coords = b.coords, type = b.type, label = b.label, job = v.job, enableDCVehs = v.dashcamVehicles.Enable, DCVehs = v.dashcamVehicles.Vehicles}}
									end
								end
							else
								if v.job == GetPlayerJob() then
									function currentShow()
										v.interaction.DrawText.Show(b.label)
										showTextUI = true
									end
									function currentHide()
										v.interaction.DrawText.Hide()
									end
									closestArea = {id = k, distance = dist, maxDist = v.interaction.DrawText.Distance, data = {coords = b.coords, type = b.type, label = b.label, job = v.job, enableDCVehs = v.dashcamVehicles.Enable, DCVehs = v.dashcamVehicles.Vehicles}}
								end
							end
						end
					end
				end
			end
		end
		if closestArea.id then
			while true do
				playerCoords = GetEntityCoords(playerPed)
				closestArea.distance = #(closestArea.data.coords - playerCoords)
				if closestArea.distance < closestArea.maxDist then
					if IsControlJustReleased(0, 38) then
						if closestArea.data.type == "dashcam" then
							openDashcams(closestArea.data.job, closestArea.data.enableDCVehs, closestArea.data.DCVehs)
						else
							openBodycams(closestArea.data.job)
						end
					end
					if not showTextUI then
						currentShow()
					end
				else
					currentHide()
					break
				end
				Citizen.Wait(0)
			end
			showTextUI = false
			closestArea = {}
			sleep = 0
		end
		Citizen.Wait(sleep)
	end
end)

Citizen.CreateThread(function()
	while true do
		local sleep = 1000
		local playerCoords = GetEntityCoords(PlayerPedId())
        if not menuActive then
            for k, v in pairs(Config.WatchAreas) do
				for a, b in pairs(v.areas) do
					if v.interaction.Text.Enable then
						local dist = #(playerCoords - b.coords)
						if dist <= v.interaction.Text.Distance then
							if type(v.job) == "table" then
								for c, d in pairs(v.job) do
									if d == GetPlayerJob() then
										sleep = 0
										ShowFloatingHelpNotification("[E] " .. b.label, b.coords)
										if IsControlJustReleased(0, 38) then
											if b.type == "dashcam" then
												openDashcams(v.job, v.dashcamVehicles.Enable, v.dashcamVehicles.Vehicles)
											else
												openBodycams(v.job)
											end
										end
									end
								end
							else
								if v.job == GetPlayerJob() then
									sleep = 0
									ShowFloatingHelpNotification("[E] " .. b.label, b.coords)
									if IsControlJustReleased(0, 38) then
										if b.type == "dashcam" then
											openDashcams(v.job, v.dashcamVehicles.Enable, v.dashcamVehicles.Vehicles)
										else
											openBodycams(v.job)
										end
									end
								end
							end
						end
					end
				end
			end
        end
		Citizen.Wait(sleep)
	end
end)

function ShowFloatingHelpNotification(msg, coords)
    AddTextEntry('pa-FloatingHelpNotification', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('pa-FloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end

function openDashcams(job, state, vehicles)
	menuCoords = GetEntityCoords(PlayerPedId())
	local data = {}
	TriggerCallback('aj-jobcams:getDashcamList:server', function(list)
		if next(list) then
			for k, v in pairs(list) do
				if type(job) == "table" then
					for c, d in pairs(job) do
						if v.job == d then
							if state then
								for a, b in pairs(vehicles) do
									if GetHashKey(b) == v.vehModel then
										table.insert(data, {
											veh = v.veh,
											vehNetId = v.vehNetId,
											vehModel = v.vehModel,
											label = v.label,
											pId = v.pId
										})
									end
								end
							else
								table.insert(data, {
									veh = v.veh,
									vehNetId = v.vehNetId,
									vehModel = v.vehModel,
									label = v.label,
									pId = v.pId
								})
							end
						end
					end
				else
					if v.job == job then
						if state then
							for a, b in pairs(vehicles) do
								if GetHashKey(b) == v.vehModel then
									table.insert(data, {
										veh = v.veh,
										vehNetId = v.vehNetId,
										vehModel = v.vehModel,
										label = v.label,
										pId = v.pId
									})
								end
							end
						else
							table.insert(data, {
								veh = v.veh,
								vehNetId = v.vehNetId,
								vehModel = v.vehModel,
								label = v.label,
								pId = v.pId
							})
						end
					end
				end
			end
			menuActive = true
			SendNUIMessage({action = "openDashcams", list = data})
			SetNuiFocus(true, true)
		else
			Notify("No players active.", 7500, "error")
		end
	end)
end

function openBodycams(job)
	menuCoords = GetEntityCoords(PlayerPedId())
	local data = {}
	TriggerCallback('aj-jobcams:getBodycamList:server', function(list)
		if next(list) then
			for k, v in pairs(list) do
				if v.id ~= GetPlayerServerId(PlayerId()) then
					table.insert(data, {
						label = v.label,
						id = v.id
					})
				end
			end
			menuActive = true
			SendNUIMessage({action = "openBodycams", list = data})
			SetNuiFocus(true, true)
		else
			Notify("No players active.", 7500, "error")
		end
	end, job)
end

local watchingBodycam = false
local watchingDashcam = false
RegisterNUICallback('callback', function(data)
	if data.action == "watchDashcam" then
    	local myPed = PlayerPedId()
		local myCoords = GetEntityCoords(myPed)
		local targetPedCoords = nil
		DoScreenFadeOut(1000)
		Citizen.Wait(2000)
		FreezeEntityPosition(PlayerPedId(), true)
		SetEntityVisible(myPed, false)
		SetPlayerInvincible(myPed, true)
		TriggerCallback('aj-jobcams:getPlayerCoords:server', function(coords)
			targetPedCoords = vector3(coords.x, coords.y, coords.z + 20.0)
		end, data.playerId)
		while targetPedCoords == nil do Citizen.Wait(0) end
		-- Cloning Ped
		nearbyPlayers = GetPlayersInArea(GetEntityCoords(PlayerPedId()), 20.0)
		if #nearbyPlayers >= 1 and next(nearbyPlayers) ~= nil and next(nearbyPlayers) then
			TriggerServerEvent('aj-jobcams:createClonePed:server', nearbyPlayers)
		end
		SetEntityCoords(myPed, targetPedCoords)
		while true do
			Citizen.Wait(0)
			myCoords = GetEntityCoords(myPed)
			local distance = #(myCoords - targetPedCoords)
			if distance < 290.0 then break end
		end
		Citizen.Wait(1000)
		-- Funcs
		NetworkRequestControlOfNetworkId(data.netId)
		local targetVehicle = NetToVeh(data.netId)
		while not DoesEntityExist(targetVehicle) do Citizen.Wait(0) end
		SetFocusEntity(targetVehicle)
		dashCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
		local targetVehBone = GetEntityBoneIndexByName(targetVehicle, 'windscreen')
		if targetVehBone == -1 then targetVehBone = GetEntityBoneIndexByName(targetVehicle, 'windscreen_f') end
		RenderScriptCams(true, false, false, true, true)
		DoScreenFadeIn(500)
		watchingDashcam = true
		SetNuiFocus(true, true)
		while watchingDashcam do
			Citizen.Wait(0)
			local targetBonePos = GetWorldPositionOfEntityBone(targetVehicle, targetVehBone)
			local targetVehRot = GetEntityRotation(targetVehicle, 0)
			SetCamCoord(dashCam, targetBonePos.x, targetBonePos.y, targetBonePos.z)
			SetCamRot(dashCam, targetVehRot.x, targetVehRot.y, targetVehRot.z, 0)
			local vehCoords = GetEntityCoords(targetVehicle)
			local distance = #(myCoords - vehCoords)
			if distance > 290 then
				SetEntityCoords(myPed, vehCoords.x, vehCoords.y, vehCoords.z - 100.0)
			end
		end
	elseif data.action == "watchBodycam" then
		local myPed = PlayerPedId()
		local myCoords = GetEntityCoords(myPed)

		local targetPedCoords = nil
		DoScreenFadeOut(1000)
		Citizen.Wait(2000)
		FreezeEntityPosition(PlayerPedId(), true)
		SetEntityVisible(myPed, false)
		SetPlayerInvincible(myPed, true)
		TriggerCallback('aj-jobcams:getPlayerCoords:server', function(coords)
			targetPedCoords = vector3(coords.x, coords.y, coords.z + 20.0)
		end, data.playerId)
		while targetPedCoords == nil do Citizen.Wait(0) end
		-- Cloning Ped
		nearbyPlayers = GetPlayersInArea(GetEntityCoords(PlayerPedId()), 20.0)
		if #nearbyPlayers >= 1 and next(nearbyPlayers) ~= nil and next(nearbyPlayers) then
			TriggerServerEvent('aj-jobcams:createClonePed:server', nearbyPlayers)
		end
		SetEntityCoords(myPed, targetPedCoords)
		while true do
			Citizen.Wait(0)
			myCoords = GetEntityCoords(myPed)
			local distance = #(myCoords - targetPedCoords)
			if distance < 290.0 then break end
		end
		Citizen.Wait(1000)
		-- Funcs
		local targetPlayerId = GetPlayerFromServerId(data.playerId)
		local targetPed = GetPlayerPed(targetPlayerId)
		while not DoesEntityExist(targetPed) do Citizen.Wait(0) end
		SetFocusEntity(targetPed)
		bodyCam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", 1)
		AttachCamToPedBone(bodyCam, targetPed, 31086, 0.05, -0.035, -0.05, true)
		RenderScriptCams(true, false, false, true, true)
		watchingBodycam = true
		SetNuiFocus(true, true)
		DoScreenFadeIn(500)
		while watchingBodycam do
			Citizen.Wait(0)
			local pedHeading = GetEntityHeading(targetPed)
			SetCamRot(bodyCam, 0, 0, pedHeading, 2)
		end
	elseif data.action == "nuiFocus" then
		menuActive = false
		SetNuiFocus(false, false)
		watchingBodycam = false
		watchingDashcam = false
		DestroyCam(dashCam)
		DestroyCam(bodyCam)
    	RenderScriptCams(0, 0, 1, 1, 1)
		Citizen.Wait(100)
		SetTimecycleModifier("default")
		SetTimecycleModifierStrength(0.3)
		FreezeEntityPosition(PlayerPedId(), false)
		SetEntityCoords(PlayerPedId(), menuCoords.x, menuCoords.y, menuCoords.z - 1)
		SetFocusEntity(PlayerPedId())
        NetworkSetInSpectatorMode(0, PlayerPedId())
		NetworkFadeInEntity(PlayerPedId(), 0, false)
		SetPlayerInvincible(PlayerPedId(), false)
		if nearbyPlayers then
			TriggerServerEvent('aj-jobcams:deleteClonePed:server', nearbyPlayers)
		end
		DoScreenFadeIn(1000)
	end
end)

function GetPlayers(onlyOtherPlayers, returnKeyValue, returnPeds)
    local players, myPlayer = {}, PlayerId()
    local active = GetActivePlayers()
    for i = 1, #active do
        local currentPlayer = active[i]
        local ped = GetPlayerPed(currentPlayer)
        if DoesEntityExist(ped) and ((onlyOtherPlayers and currentPlayer ~= myPlayer) or not onlyOtherPlayers) then
            if returnKeyValue then
                players[currentPlayer] = {entity = ped, id = GetPlayerServerId(currentPlayer)}
            else
                players[#players + 1] = returnPeds and ped or currentPlayer
            end
        end
    end
    return players
end

function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
    local nearbyEntities = {}
    if coords then
        coords = vector3(coords.x, coords.y, coords.z)
    else
        local playerPed = PlayerPedId()
        coords = GetEntityCoords(playerPed)
    end
    for k, v in pairs(entities) do
        local distance = #(coords - GetEntityCoords(v.entity))
        if distance <= maxDistance then
            nearbyEntities[#nearbyEntities + 1] = v.id
        end
    end
    return nearbyEntities
end

function GetPlayersInArea(coords, maxDistance)
    return EnumerateEntitiesWithinDistance(GetPlayers(true, true), true, coords, maxDistance)
end

RegisterNetEvent('aj-jobcams:createClonePed:client', function(ped, coords)
	clonePed = CreatePed(0, 1885233650, coords.x, coords.y, coords.z - 1, coords.w, true, false)
	ClonePedToTarget(ped, clonePed)
	FreezeEntityPosition(clonePed, true)
	SetEntityInvincible(clonePed, true)
	SetBlockingOfNonTemporaryEvents(clonePed, true)
end)

RegisterNetEvent('aj-jobcams:deleteClonePed:client', function()
	DeletePed(clonePed)
end)

AddEventHandler('aj-deathscreen:openUI', function()
    if menuActive and menuCoords then
		SendNUIMessage({action = "closeAll"})
    end
end)

AddEventHandler('aj-deathscreen:die', function()
    if menuActive and menuCoords then
		SendNUIMessage({action = "closeAll"})
    end
end)

RegisterNetEvent('esx_ambulancejob:PlayerDead')
AddEventHandler('esx_ambulancejob:PlayerDead', function()
    if menuActive and menuCoords then
		SendNUIMessage({action = "closeAll"})
    end
end)

AddEventHandler('gameEventTriggered', function(event, data)
    if event == 'CEventNetworkEntityDamage' then
        local victim, attacker, victimDied, weapon = data[1], data[2], data[4], data[7]
		if not IsEntityAPed(victim) then return end
        if victimDied and NetworkGetPlayerIndexFromPed(victim) == PlayerId() and IsEntityDead(PlayerPedId()) and menuActive then
			SendNUIMessage({action = "closeAll"})
		end
	end
end)