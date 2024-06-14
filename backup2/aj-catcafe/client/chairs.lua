local AJFW = exports['aj-base']:GetCoreObject()

local catseat = 0
local sitting = false

Citizen.CreateThread(function()
	for k, v in pairs(Config.Chairs) do
		exports['aj-target']:AddBoxZone("CatChair"..k, v.location, v.width, v.height, { name="CatChair"..k, heading = v.heading, debugPoly=Config.Debug, minZ = v.minZ, maxZ = v.maxZ, }, 
			{ options = { { event = "jim-catcafe:Chair", icon = "fas fa-chair", label = "Sit Down", loc = v.location, head = v.heading, seat = v.seat }, },
			  distance = v.distance
		})
	end
end)

RegisterNetEvent('jim-catcafe:Chair', function(data)
	local canSit = true
	local sitting = false
	for k, v in pairs(AJFW.Functions.GetPlayersFromCoords(data.loc, 0.6)) do
		local dist = #(GetEntityCoords(GetPlayerPed(v)) - data.loc)
		if dist <= 0.4 then TriggerEvent("AJFW:Notify", "Someone is already sitting there..") canSit = false end
	end
	if canSit then
		TaskStartScenarioAtPosition(PlayerPedId(), "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", data.loc.x, data.loc.y, data.loc.z-0.5, data.head, 0, 1, true)
		catseat = data.seat
		sitting = true
	end
	while sitting do
		local ped = PlayerPedId()
		if sitting then 
			if IsControlJustReleased(0, 202) and IsPedUsingScenario(ped, "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER") then
				sitting = false
				ClearPedTasks(ped)

				if catseat == 1 then SetEntityCoords(ped, vector3(-575.37, -1059.79, 22.34-0.5)) SetEntityHeading(ped, 90.0) end
				if catseat == 2 then SetEntityCoords(ped, vector3(-575.34, -1063.39, 22.34-0.5)) SetEntityHeading(ped, 90.0) end
				if catseat == 3 then SetEntityCoords(ped, vector3(-575.49, -1067.04, 22.34-0.5)) SetEntityHeading(ped, 90.0) end
				
				if catseat == 4 then SetEntityCoords(ped, vector3(-585.72, -1064.75, 22.34)) SetEntityHeading(ped, 270.0) end
				if catseat == 5 then SetEntityCoords(ped, vector3(-585.75, -1065.69, 22.34)) SetEntityHeading(ped, 270.0) end
				if catseat == 6 then SetEntityCoords(ped, vector3(-585.84, -1066.7, 22.34)) SetEntityHeading(ped, 270.0) end
				if catseat == 7 then SetEntityCoords(ped, vector3(-585.79, -1067.64, 22.34)) SetEntityHeading(ped, 270.0) end
				
				catseat = 0
			end
		end
		Wait(5) if not IsPedUsingScenario(ped, "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER") then sitting = false end
	end
end)

Config.Chairs = {
	--Downstairs--
	--Booth1
	{ location = vector3(-573.04, -1058.81, 22.5), heading = 180.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 1 },
	{ location = vector3(-573.92, -1058.82, 22.5), heading = 180.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 1 },
	{ location = vector3(-573.06, -1060.7, 22.5), heading = 0.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 1 },
	{ location = vector3(-573.91, -1060.72, 22.5), heading = 0.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 1 },
	--Booth2
	{ location = vector3(-572.98, -1062.46, 22.5), heading = 180.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 2 },
	{ location = vector3(-573.84, -1062.45, 22.5), heading = 180.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 2 },
	{ location = vector3(-573.05, -1064.37, 22.5), heading = 0.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 2 },
	{ location = vector3(-573.89, -1064.37, 22.5), heading = 0.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 2 },
	--Booth3
	{ location = vector3(-573.0, -1066.11, 22.5), heading = 180.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 3 },
	{ location = vector3(-573.9, -1066.1, 22.5), heading = 180.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 3 },
	{ location = vector3(-573.07, -1068.03, 22.5), heading = 0.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 3 },
	{ location = vector3(-573.87, -1068.01, 22.5), heading = 0.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7, seat = 3 },
	--Fireside
	{ location = vector3(-580.84, -1051.22, 22.35), heading = 277.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7 },
	{ location = vector3(-579.78, -1052.51, 22.35), heading = 329.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7 },
	{ location = vector3(-577.61, -1052.6, 22.35), heading = 35.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7 },
	{ location = vector3(-576.86, -1051.03, 22.35), heading = 108.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 2.7 },
	--Center
	{ location = vector3(-579.72, -1062.12, 22.35), heading = 0.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 1.7 },
	{ location = vector3(-580.7, -1062.55, 22.35), heading = 45.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 1.7 },
	{ location = vector3(-581.02, -1063.46, 22.35), heading = 90.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 1.7 },
	{ location = vector3(-580.64, -1064.45, 22.35), heading = 135.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 1.7 },
	{ location = vector3(-579.71, -1064.79, 22.35), heading = 180.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 1.7 },
	{ location = vector3(-578.67, -1064.47, 22.35), heading = 225.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 1.7 },
	{ location = vector3(-578.33, -1063.39, 22.35), heading = 270.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 1.7 },
	{ location = vector3(-578.76, -1062.34, 22.35), heading = 315.75, width = 0.6, height = 0.6, minZ = 21.0, maxZ = 22.45, distance = 1.7 },
	--Stools
	{ location = vector3(-586.18, -1064.68, 22.6), heading = 90.75, width = 0.6, height = 0.6, minZ = 21.45, maxZ = 22.45, distance = 1.7, seat = 4 },
	{ location = vector3(-586.17, -1065.69, 22.6), heading = 90.75, width = 0.6, height = 0.6, minZ = 21.45, maxZ = 22.45, distance = 1.7, seat = 5 },
	{ location = vector3(-586.15, -1066.68, 22.6), heading = 90.75, width = 0.6, height = 0.6, minZ = 21.45, maxZ = 22.45, distance = 1.7, seat = 6 },
	{ location = vector3(-586.17, -1067.69, 22.6), heading = 90.75, width = 0.6, height = 0.6, minZ = 21.45, maxZ = 22.45, distance = 1.7, seat = 7 },
	--Boss sofa
	{ location = vector3(-591.21, -1049.06, 22.35), heading = 180.75, width = 0.6, height = 0.6, minZ = 21.45, maxZ = 22.45, distance = 1.7 },
	{ location = vector3(-589.95, -1049.06, 22.35), heading = 180.75, width = 0.6, height = 0.6, minZ = 21.45, maxZ = 22.45, distance = 1.7 },
	--Boss Room1
	{ location = vector3(-598.44, -1050.99, 22.35), heading = 270.0, width = 0.6, height = 0.6, minZ = 21.45, maxZ = 22.45, distance = 1.7 },
	{ location = vector3(-598.45, -1050.1, 22.35), heading = 270.0, width = 0.6, height = 0.6, minZ = 21.45, maxZ = 22.45, distance = 1.7 },
	{ location = vector3(-596.26, -1053.52, 22.35), heading = 0, width = 0.6, height = 0.6, minZ = 21.45, maxZ = 22.45, distance = 1.7 },
	--Upstairs
	--Sofa1
	{ location = vector3(-573.72, -1052.29, 26.61), heading = 270.0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	{ location = vector3(-573.73, -1053.45, 26.61), heading = 270.0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	--Corner Sofa
	{ location = vector3(-569.68, -1066.56, 26.62), heading = 90.0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	{ location = vector3(-569.7, -1068.13, 26.62), heading = 90.0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	{ location = vector3(-570.97, -1069.42, 26.62), heading = 0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	{ location = vector3(-572.61, -1069.4, 26.62), heading = 0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	--Boss Room 2
	{ location = vector3(-577.09, -1065.14, 26.61), heading = 165.0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	{ location = vector3(-578.82, -1065.24, 26.61), heading = 200.0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	{ location = vector3(-578.24, -1067.83, 26.61), heading = 0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	--Boss Room 3
	{ location = vector3(-577.0, -1062.6, 26.61), heading = 0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	{ location = vector3(-579.1, -1061.28, 26.61), heading = 270.0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	{ location = vector3(-577.39, -1057.87, 26.61), heading = 180.0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },
	{ location = vector3(-578.59, -1057.9, 26.61), heading = 180.0, width = 0.6, height = 0.6, minZ=25.61, maxZ=27.0, distance = 1.7 },

	---------MCD
	-----table 1
	{ location = vector3(76.51, 283.05, 110.21), heading = 165.7, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(75.61, 283.31, 110.21), heading = 165.7, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(74.83, 281.23, 110.21), heading = 340.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(75.69, 280.95, 110.21), heading = 340.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	-----table 2
	{ location = vector3(74.84, 279.48, 110.21), heading = 250.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(74.51, 278.68, 110.21), heading = 250.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(76.98, 278.77, 110.21), heading = 70.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(76.68, 277.85, 110.21), heading = 70.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	-----table 3
	{ location = vector3(77.52, 277.65, 110.21), heading = 250.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(77.78, 278.42, 110.21), heading = 250.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(79.74, 276.84, 110.21), heading = 70.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(80.04, 277.65, 110.21), heading = 70.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	-----table 4
	{ location = vector3(84.53, 274.99, 110.21), heading = 250.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(84.84, 275.86, 110.21), heading = 250.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(86.73, 274.25, 110.21), heading = 70.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(87.01, 275.01, 110.21), heading = 70.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	-----table 5
	{ location = vector3(87.87, 274.77, 110.21), heading = 250.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(87.53, 273.85, 110.21), heading = 250.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(90.04, 274.0, 110.21), heading = 70.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(89.8, 273.15, 110.21), heading = 70.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	-----table 6
	{ location = vector3(90.42, 278.06, 110.21), heading = 165.7, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(91.19, 277.72, 110.21), heading = 165.7, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(89.58, 275.85, 110.21), heading = 340.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(90.45, 275.51, 110.21), heading = 340.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	-----table 7
	{ location = vector3(81.57, 290.87, 110.21), heading = 250.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(81.9, 291.76, 110.21), heading = 250.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(83.78, 290.18, 110.21), heading = 70.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(84.05, 291.03, 110.21), heading = 70.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	-----table 8
	{ location = vector3(84.92, 290.66, 110.21), heading = 250.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(84.63, 289.8, 110.21), heading = 250.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(86.79, 289.06, 110.21), heading = 70.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(87.11, 289.9, 110.21), heading = 70.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },	
	-----table 9
	{ location = vector3(84.32, 279.17, 110.21), heading = 290.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(84.92, 280.95, 110.21), heading = 200.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(86.65, 280.37, 110.21), heading = 110.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(86.08, 278.53, 110.21), heading = 20.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	-----table 10
	{ location = vector3(85.68, 285.14, 110.21), heading = 110.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(83.42, 283.98, 110.21), heading = 290.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(85.05, 283.26, 110.21), heading = 20.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(83.91, 285.75, 110.21), heading = 200.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	-----table 11
	{ location = vector3(81.13, 281.08, 110.21), heading = 20.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(79.33, 281.64, 110.21), heading = 290.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(79.79, 283.42, 110.21), heading = 200.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(81.62, 282.97, 110.21), heading = 110.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	------office
	{ location = vector3(80.95, 297.02, 110.21), heading = 250.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(81.45, 298.45, 110.21), heading = 250.0, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(83.12, 299.25, 110.21), heading = 165.7, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },
	{ location = vector3(84.38, 298.78, 110.21), heading = 165.7, width = 0.6, height = 0.6, minZ=109.30, maxZ=110.21, distance = 1.7 },

	--------Court House Judge Chair
	{ location = vector3(-517.9, -175.11, 38.55), heading = 120.0, width = 0.6, height = 0.6, minZ=38.00, maxZ=39.00, distance = 1.7 },

}

AddEventHandler('onResourceStop', function(r) 
	if r == GetCurrentResourceName() then for k, v in pairs(Config.Chairs) do exports['aj-target']:RemoveZone("CatChair"..k) end
	end 
end)