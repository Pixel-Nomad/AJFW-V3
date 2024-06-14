-- AJFW = nil
isLoggedIn = true

local menuOpen = false
local wasOpen = false
local AJFW = exports['aj-base']:GetCoreObject()

-- Citizen.CreateThread(function() 
--     while true do
--         Citizen.Wait(10)
--         if AJFW == nil then
--             TriggerEvent("AJFW:GetObject", function(obj) AJFW = obj end)    
--             Citizen.Wait(200)
--         end
--     end
-- end)

local spawnedMushrooms = 0
local mushroomGrowth = {}
local isPickingUp, isProcessing = false, false

local f = true
local b = 0


function DrawText2D(x, y, text)  
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.3)
			SetTextColour(128, 128, 128, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			--AddTextComponentString("~w~Press ~b~[E]~w~ to pickup Cannabis")
			DrawText(x, y)

end

Citizen.CreateThread(
    function()
        local g = false
        while true do
            Citizen.Wait(1000)
            if f then
				local h = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.CircleZones.MushroomField.coords, true)
                if h < 100 and not g then
                    SpawnmushroomGrowth()
                    g = true
                elseif h > 250 and g then
                    Citizen.Wait(900000)
                    g = false
                end
            else
                Citizen.Wait(10000)
            end
        end
    end
)

RegisterNetEvent("AJFW:Client:OnPlayerLoaded")
AddEventHandler("AJFW:Client:OnPlayerLoaded", function()
	--CheckCoords()
	--[[Citizen.Wait(1000)
	local coords = GetEntityCoords(PlayerPedId())
	if GetDistanceBetweenCoords(coords, Config.CircleZones.MushroomField.coords, true) < 2000 then
		SpawnmushroomGrowth()
	end--]]
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.MushroomProcessing.coords, true) < 0.5 then

			DrawText3D(Config.CircleZones.MushroomProcessing.coords.x, Config.CircleZones.MushroomProcessing.coords.y, Config.CircleZones.MushroomProcessing.coords.z, 'Press ~r~[ E ] to process')


			if IsControlJustReleased(0, 38) and not isProcessing then
				AJFW.Functions.TriggerCallback('mushroom:ingredient', function(HasItem, type)
					if HasItem then
						ProcessMushroom()
					else
						AJFW.Functions.Notify('You dont have enough Materials', 'error')
					end
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(x,y,z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 370
	DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
	ClearDrawOrigin()
end

function ProcessMushroom()
	isProcessing = true
	local playerPed = PlayerPedId()

	
	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)

	AJFW.Functions.Progressbar("search_register", "Processing..",'red', 15000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		AJFW.Functions.TriggerCallback('mushroom:ingredient', function(HasItem, type)
			if HasItem then	
				TriggerServerEvent('aj-lsdmushroom:processMushroom')
			else
				-- print("badhe teej bannre the na xD")
				AJFW.Functions.Notify("You dont have enough Materials", "error")
				FreezeEntityPosition(PlayerPedId(),false)
			end
		end)
		
		local timeLeft = Config.Delays.MushroomProcessing / 1000

		while timeLeft > 0 do
			Citizen.Wait(1000)
			timeLeft = timeLeft - 1

			if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.MushroomProcessing.coords, false) > 4 then
				TriggerServerEvent('aj-lsdmushroom:cancelProcessing')
				break
			end
		end
		ClearPedTasks(PlayerPedId())
	end, function()
		ClearPedTasks(PlayerPedId())
	end) -- Cancel
		
	
	isProcessing = false
end



-- Mushroom Grown

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #mushroomGrowth, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(mushroomGrowth[i]), false) < 1 then
				nearbyObject, nearbyID = mushroomGrowth[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				DrawText2D(0.4, 0.8, '~w~Press ~g~[E]~w~ to pickup Mushroom')
			end

			if IsControlJustReleased(0, 38) and not isPickingUp then
				isPickingUp = true
				TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

				AJFW.Functions.Notify("wait please have patience", "error", 10000)
				AJFW.Functions.Progressbar("search_register", "Picking up Mushroom..",'red', 10000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {}, {}, {}, function() -- Done
					ClearPedTasks(PlayerPedId())
					DeleteObject(nearbyObject)

					table.remove(mushroomGrowth, nearbyID)
					spawnedMushrooms = spawnedMushrooms - 1
	
					TriggerServerEvent('aj-lsdmushroom:pickedMushroom')
					

				end, function()
					ClearPedTasks(PlayerPedId())
				end) -- Cancel

				isPickingUp = false
			end
		else
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(mushroomGrowth) do
			DeleteObject(v)
		end
	end
end)

function SpawnmushroomGrowth()
	
	math.randomseed(GetGameTimer())
	-- print(math.randomseed(GetGameTimer()))
    local random = math.random(15, 25)
	-- print(random)
    RequestModel(3267161942)
    while not HasModelLoaded(3267161942) do
        Citizen.Wait(1)
    end
    while b < random do
		Citizen.Wait(1)
		local D = GenerateMushroomCoords()
		-- print(D)
		local DD = D.z+3
		-- print(D.x,D.y,D.z,DD)
		

		local E = CreateObject(3267161942, D.x + math.random(-15,15), D.y + math.random(-15,15), DD, false, false, true)
		-- print(E)
        PlaceObjectOnGroundProperly(E)
        FreezeEntityPosition(E, true)
        table.insert(mushroomGrowth, E)
        b = b + 1
    end
end

function ValidateMushroomCoord(growthCoords)
	if spawnedMushrooms > 0 then
		
		local validate = true

		for k, v in pairs(mushroomGrowth) do
			if GetDistanceBetweenCoords(growthCoords, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(growthCoords, Config.CircleZones.MushroomField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateMushroomCoords()
	while true do
		Citizen.Wait(1)

		local mushroomCoordX, mushroomCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)
		-- print(Config.CircleZones.MushroomField.coords.x, modX, Config.CircleZones.MushroomField.coords.y, modY)

		mushroomCoordX = Config.CircleZones.MushroomField.coords.x + 10
		mushroomCoordY = Config.CircleZones.MushroomField.coords.y + 10

		local coordZ = GetCoordZ(mushroomCoordX, mushroomCoordY)
		-- print(coordZ)
		local coord = vector3(mushroomCoordX, mushroomCoordY, coordZ)

		if ValidateMushroomCoord(coord) then
			return coord
		end
	end
end


function GetCoordZ(x, y)
	local groundCheckHeights = { 150.0,151.0,152.0,153.0,154.0, 155.0,156.0,158.0,159.0, 160.0,161.0,162.0,163.0,164.0, 165.0,166.0,167.0,168.0,169.0, 170.0, 171.0, 172.0, 173.0, 174.0, 175.0, 176.0, 177.0, 178.0, 179.0, 180.0, 185.0}
    -- local groundCheckHeights = { 1.0, 2.0, 3.0, 4.0, 5.0, 6.0 }
	for i, height in ipairs(groundCheckHeights) do
        local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

        if foundGround then
            return z
        end
    end

    return 150.0
end
