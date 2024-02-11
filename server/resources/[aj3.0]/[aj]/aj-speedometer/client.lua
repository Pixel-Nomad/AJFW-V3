local isHide = false

local carRPM, carSpeed, carGear, carIL, carAcceleration, carHandbrake, carBrakeABS, carLS_r, carLS_o, carLS_h, carFuel, carIndicators, carEngineHp, carLights

local isMPH = false


RegisterNetEvent('On:Vehicle:SpeedSettingUpdate', function(toggle)
	isMPH = toggle
end)

RegisterNetEvent('On:Vehicle:AdvancedSpeedometer',function(toggle)
	if toggle then
		isHide = false
	else
		SendNUIMessage({HideHud = true})
		isHide = true
	end
end)

CreateThread(function()
	while true do
		Wait(10)

		playerPed = PlayerPedId()
		
		if playerPed and IsPedInAnyVehicle(playerPed) and not isHide then
			
			playerCar = GetVehiclePedIsIn(playerPed, false)
			
			if playerCar and GetPedInVehicleSeat(playerCar, -1) == playerPed then
				local NcarRPM                      = GetVehicleCurrentRpm(playerCar)
				local NcarSpeed                    = GetEntitySpeed(playerCar)
				local NcarGear                     = GetVehicleCurrentGear(playerCar)
				local NcarIL                       = GetVehicleIndicatorLights(playerCar)
				local NcarAcceleration             = IsControlPressed(0, 71)
				local NcarHandbrake                = GetVehicleHandbrake(playerCar)
				local NcarBrakeABS                 = (GetVehicleWheelSpeed(playerCar, 0) <= 0.0) and (NcarSpeed > 0.0)
				local NcarLS_r, NcarLS_o, NcarLS_h = GetVehicleLightsState(playerCar)
				local veh 						   = GetVehiclePedIsUsing(playerPed)-- need for fuel
				local fuel 						   = math.floor(exports['aj-fuel']:GetFuel(playerCar)) --fuel start
				local engineHp                     = GetVehicleEngineHealth(veh) --engine hp
				local _, lightsOne, lightsTwo = GetVehicleLightsState(veh)
				local lightsState

				--indicators start
				local indicatorsState 			   = GetVehicleIndicatorLights(veh)
				if indicatorsState == 0 then
					indicatorsState = 'off'
				elseif indicatorsState == 1 then
					indicatorsState = 'left'
				elseif indicatorsState == 2 then
					indicatorsState = 'right'
				elseif indicatorsState == 3 then
					indicatorsState = 'both'
				end
				if (lightsOne == 1 and lightsTwo == 0) then
					lightsState = 1;
				elseif (lightsOne == 1 and lightsTwo == 1) or (lightsOne == 0 and lightsTwo == 1) then
					lightsState = 2;
				else
					lightsState = 0;
				end
				
				local shouldUpdate = false
				
				if NcarRPM ~= carRPM or NcarSpeed ~= carSpeed or NcarGear ~= carGear or NcarIL ~= carIL or NcarAcceleration ~= carAcceleration 
					or NcarHandbrake ~= carHandbrake or NcarBrakeABS ~= carBrakeABS or NcarLS_r ~= carLS_r or NcarLS_o ~= carLS_o or NcarLS_h ~= carLS_h or fuel ~= carFuel or indicatorsState ~= carIndicators 
					or engineHp ~= carEngineHp or  lightsState ~= carLights then
					shouldUpdate = true
				end
				
				if shouldUpdate then
					carRPM          = NcarRPM
					carGear         = NcarGear
					carSpeed        = NcarSpeed
					carIL           = NcarIL
					carAcceleration = NcarAcceleration
					carHandbrake    = NcarHandbrake
					carBrakeABS     = NcarBrakeABS
					carLS_r         = NcarLS_r
					carLS_o         = NcarLS_o
					carLS_h         = NcarLS_h
					carFuel			= fuel
					carIndicators   = indicatorsState
					carEngineHp     = engineHp
					carLights       = lightsState
					CurrentCarSpeed = carSpeed * 3.6
					if isMPH then
						CurrentCarSpeed = carSpeed * 2.23694
					end
  					SendNUIMessage({
						ShowHud                = true,
						CurrentCarRPM          = carRPM,
						CurrentCarGear         = carGear,
						CurrentCarSpeed        = carSpeed,
						CurrentCarKmh          = CurrentCarSpeed,
						isMPH = isMPH,
						CurrentCarIL           = carIL,
						CurrentCarAcceleration = carAcceleration,
						CurrentCarHandbrake    = carHandbrake,
						CurrentCarABS          = GetVehicleWheelBrakePressure(playerCar, 0) > 0 and not carBrakeABS,
						CurrentCarLS_r         = carLS_r,
						CurrentCarLS_o         = carLS_o,
						CurrentCarLS_h         = carLS_h,
						currentcarFuel		   = carFuel,
						currentcarIndicators   = carIndicators,
						currentcarEngineHp     = carEngineHp,
						currentcarLights 	   = carLights,
						PlayerID               = GetPlayerServerId(GetPlayerIndex())
						
					})
				else
					Wait(100)
				end

			else
				SendNUIMessage({HideHud = true})
			end
		else
			SendNUIMessage({HideHud = true})
			Wait(100)
		end
	end
end)