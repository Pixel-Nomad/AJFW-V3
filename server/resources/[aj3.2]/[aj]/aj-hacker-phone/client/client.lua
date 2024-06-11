local AJFW = exports['aj-base']:GetCoreObject()
local AJHackerPhoneStatus = false

CreateThread(function()
    while true do
        local sleep = 500 
        if AJHackerPhoneStatus then
			sleep = 5 
			DisableControlAction(0, 1, true) -- disable mouse look
			DisableControlAction(0, 2, true) -- disable mouse look
			DisableControlAction(0, 3, true) -- disable mouse look
			DisableControlAction(0, 4, true) -- disable mouse look
			DisableControlAction(0, 5, true) -- disable mouse look
			DisableControlAction(0, 6, true) -- disable mouse look
			DisableControlAction(0, 263, true) -- disable melee
			DisableControlAction(0, 264, true) -- disable melee
			DisableControlAction(0, 257, true) -- disable melee
			DisableControlAction(0, 140, true) -- disable melee
			DisableControlAction(0, 141, true) -- disable melee
			DisableControlAction(0, 142, true) -- disable melee
			DisableControlAction(0, 143, true) -- disable melee
			DisableControlAction(0, 177, true) -- disable escape
			DisableControlAction(0, 200, true) -- disable escape
			DisableControlAction(0, 202, true) -- disable escape
			DisableControlAction(0, 322, true) -- disable escape
			DisableControlAction(0, 245, true) -- disable chat
			DisableControlAction(0, 24, true) -- disable
        end
    Wait(sleep)
    end
end)

RegisterNetEvent("aj-hackerphone:client:openphone",function(name)
	if not AJHackerPhoneStatus then 
		SetNuiFocusKeepInput(true)
		SetNuiFocus(true,true)
		SendNUIMessage({nuimessage = 'open', name = name})
		DoPhoneAnimationHacker('cellphone_text_in')
		Wait(250)
		newPhonePropHacker()
		AJHackerPhoneStatus = true
	end
end)

RegisterNetEvent("aj-hackerphone:client:targetinfornui", function(targetinfo)
    SendNUIMessage({nuimessage = "userlists", uinfo = targetinfo})
end)

RegisterNetEvent("aj-hackerphone:client:centralchip", function()
	local ped = PlayerPedId()
	local pos = GetEntityCoords(ped)
	local chipcoords = vec3(2810.22, 1489.86, 24.73)
	local dist = #(pos - chipcoords)
	if dist < 2 then 
		Anim()
		exports['aj-hacks']:Scrambler(function(success)
			if success then
				SendNUIMessage({nuimessage = "cbool"})
				ClearPedTasks(ped)
				AJFW.Functions.Notify('Central cart connected', "success")
				TriggerServerEvent('aj-hackerphone:server:removeitem',"centralchip")
			else
				ClearPedTasks(ped)
				AJFW.Functions.Notify('Failed to connect', "error")
			end
		end, "numeric", 30, 2)
	else
		AJFW.Functions.Notify('Not near power station', "error")
	end
end)

RegisterNetEvent("aj-hackerphone:client:vehicletracker", function()
	local vehicle = AJFW.Functions.GetClosestVehicle()
	if vehicle ~= nil and vehicle ~= 0 then
		local ped = PlayerPedId()
		local pos = GetEntityCoords(ped)
		local vehpos = GetEntityCoords(vehicle)
		local vehicleinfo = {
			["plate"] = AJFW.Functions.GetPlate(vehicle),
			["vehname"] = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)):lower(),
			["vehengine"] = GetVehicleEngineHealth(vehicle),
			["vehicle"] = vehicle
		}
		if #(pos - vehpos) < 2 then
			Anim()
			exports['aj-hacks']:Circle(function(success)
				if success then
					SendNUIMessage({nuimessage = 'vbool', vehicleinfo = vehicleinfo})
					ClearPedTasks(ped)
					AJFW.Functions.Notify('Tracker connected to vehicle', "success")
					TriggerServerEvent('aj-hackerphone:server:removeitem',"tracker")
				else
					ClearPedTasks(ped)
					AJFW.Functions.Notify('Failed to connect', "error")
				end
			end, 5, 10)
		else
			AJFW.Functions.Notify('No cars nearby', "error")
		end
    end
end)

RegisterNetEvent("aj-hackerphone:client:notify", function()
    SendNUIMessage({nuimessage = 'error'})
end)

RegisterNUICallback("aj-hackerphone:nuicallback:targetinformation", function()
    TriggerServerEvent('aj-hackerphone:server:targetinformation')
end)

RegisterNUICallback("aj-hackerphone:broken:vehicle", function(vehicle)
	local vehpos = GetEntityCoords(vehicle)
	AddExplosion(vehpos.x, vehpos.y, vehpos.z, 7, 0.5, true, false, true)
end)

RegisterNUICallback('aj-hackerphone:nuicallback:blackout', function()
    TriggerServerEvent('aj-weathersync:server:toggleBlackout')
end)

RegisterNUICallback("aj-hackerphone:nuicallback:cam", function(camid)
	TriggerEvent("police:client:ActiveCamera", tonumber(camid))
end)

RegisterNUICallback("aj-hackerphone:nuicallback:escape", function()
	SetNuiFocusKeepInput(false)
    SetNuiFocus(false,false)
	DoPhoneAnimationHacker('cellphone_text_out')
	Wait(400)
	StopAnimTask(PlayerPedId(), lib, libanim, 2.5)
	deletePhoneHacker()
	lib = nil
	libanim = nil
    AJHackerPhoneStatus = false
end)

function Anim()
	while not HasAnimDictLoaded("anim@amb@clubhouse@tutorial@bkr_tut_ig3@") do
        RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
        Wait(5)
    end
	TaskPlayAnim(PlayerPedId(), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@', 'machinic_loop_mechandplayer' , 3.0, 3.0, -1, 1, 0, false, false, false)
end