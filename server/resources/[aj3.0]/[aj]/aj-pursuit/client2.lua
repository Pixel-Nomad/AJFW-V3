local TPFW = exports['aj-base']:GetCoreObject()

local PlayerData = {}

RegisterNetEvent('AJFW:Client:OnPlayerLoaded', function()
	PlayerData = TPFW.Functions.GetPlayerData()
end)

RegisterNetEvent('AJFW:Client:OnPlayerUnload', function()
	PlayerData = {}
end)

RegisterNetEvent('AJFW:Client:OnJobUpdate', function(JobInfo)
	PlayerData.job = JobInfo
end)

RegisterNetEvent('AJFW:Player:SetPlayerData', function(val)
	PlayerData = val
end)

AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
	PlayerData = TPFW.Functions.GetPlayerData()
   end
end)

local defaultHash, defaultHash2, defaultHash3, defaultHash4 = "npolchal","npolvette","npolstang","npolchar"

RegisterNetEvent("police:Ghost:Pursuit:Mode:A", function()
	local ped = PlayerPedId()
	if (IsPedInAnyVehicle(PlayerPedId())) then
		local veh = GetVehiclePedIsIn(PlayerPedId())  
		local Driver = GetPedInVehicleSeat(veh, -1)
		local fInitialDriveForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
		local First = 'A +'
		if IsPedSittingInAnyVehicle(ped) and IsVehicleModel(veh,defaultHash) or IsVehicleModel(veh,defaultHash2) or IsVehicleModel(veh,defaultHash3)
		   or IsVehicleModel(veh,defaultHash4)  and PlayerData.metadata['pursuit'] then
			SetVehicleModKit(veh, 0)
			SetVehicleMod(veh, 46, 4, true) 
			SetVehicleMod(veh, 11, 4, true)
			SetVehicleMod(veh, 12, -1, false)
			SetVehicleMod(veh, 13, -1, false)  
			ToggleVehicleMod(veh,  18, false)          
            TPFW.Functions.Notify('New Mode : ' ..First, 'error', 3000) 
			SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveForce', 0.4470000)
			SetVehicleHandlingField(veh, 'CHandlingData', 'fDriveInertia', 1.100000)
		else
            TPFW.Functions.Notify('You are not in a HEAT vehicle', 'error', 3000) 
		end
	end
end)

RegisterNetEvent("police:Ghost:Pursuit:B:Plus", function()
    local ped = PlayerPedId()
	if (IsPedInAnyVehicle(PlayerPedId())) then
		local veh = GetVehiclePedIsIn(PlayerPedId())  
		local Driver = GetPedInVehicleSeat(veh, -1)
        local fInitialDriveForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
		local mode1 = 'B +'
        
        if IsPedSittingInAnyVehicle(ped) and IsVehicleModel(veh,defaultHash) or IsVehicleModel(veh,defaultHash2) or IsVehicleModel(veh,defaultHash3)  -- Vehicle Checks
	       or IsVehicleModel(veh,defaultHash4)  and PlayerData.metadata['pursuit'] then
            SetVehicleModKit(veh, 0)
            SetVehicleMod(veh, 46, 4, true)
            SetVehicleMod(veh, 11, 4, true)
            SetVehicleMod(veh, 12, 2, true)
            SetVehicleMod(veh, 13, 3, true)  
            ToggleVehicleMod(veh,  18, true)          
            TPFW.Functions.Notify('New Mode : ' ..mode1, 'error', 3000) 
            SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveForce', 0.4770000)
            SetVehicleHandlingField(veh, 'CHandlingData', 'fDriveInertia', 1.200000)
        else
            TPFW.Functions.Notify('You are not in a HEAT vehicle', 'error', 3000)
        end
    end
end)

RegisterNetEvent("police:Ghost:Pursuit:SPlusMode", function()
    local ped = PlayerPedId()
	if (IsPedInAnyVehicle(PlayerPedId())) then
		local veh = GetVehiclePedIsIn(PlayerPedId())  
		local Driver = GetPedInVehicleSeat(veh, -1)
        local fInitialDriveForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
		local mode2 = 'S +'
        
        if IsPedSittingInAnyVehicle(ped) and IsVehicleModel(veh,defaultHash) or IsVehicleModel(veh,defaultHash2) or IsVehicleModel(veh,defaultHash3) and PlayerData.metadata['pursuit'] then
            SetVehicleModKit(veh, 0)
            SetVehicleMod(veh, 46, 4, true)
            SetVehicleMod(veh, 11, 4, true)
            SetVehicleMod(veh, 12, 2, true)
            SetVehicleMod(veh, 13, 3, true)  
            ToggleVehicleMod(veh,  18, true)          
            TPFW.Functions.Notify('New Mode : ' ..mode2, 'error', 3000) 
            SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveForce', 0.5670000)
            SetVehicleHandlingField(veh, 'CHandlingData', 'fDriveInertia', 1.300000)
        else
            TPFW.Functions.Notify('You are not in a HEAT vehicle', 'error', 3000)
        end
    end
end)

RegisterNetEvent("police:pursuitmodeOff", function()
    local ped = PlayerPedId()
	if (IsPedInAnyVehicle(PlayerPedId(), true)) then
		local veh = GetVehiclePedIsIn(PlayerPedId(),false)  
		local Driver = GetPedInVehicleSeat(veh, -1)
        local fInitialDriveForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
		if IsPedSittingInAnyVehicle(ped) and IsVehicleModel(veh,defaultHash) or IsVehicleModel(veh,defaultHash2) or IsVehicleModel(veh,defaultHash3) or IsVehicleModel(veh,defaultHash4)  and PlayerData.metadata['pursuit'] then
            SetVehicleModKit(veh, 0)
            SetVehicleMod(veh, 46, 4, false)
            SetVehicleMod(veh, 13, -1, false)
            SetVehicleMod(veh, 12, -1, false)
            SetVehicleMod(veh, 11, -1, false)
            ToggleVehicleMod(veh,  18, false)
            TPFW.Functions.Notify('Pursuit Mode Disabled', 'error', 3000)
            SetVehicleHandlingField(veh, 'CHandlingData', 'fInitialDriveForce', 0.3050000)
            SetVehicleHandlingField(veh, 'CHandlingData', 'fDriveInertia', 1.00000)
        else
            TPFW.Functions.Notify('You are not in a HEAT vehicle', 'error', 3000)
        end
    end
end)
local mode = 0
local allow = true
local lastVehicle = nil


exports['aj-base']:CreateBind('Pursuit', nil, 'Police: Pusuit Mode +', '', function()
    local ped = PlayerPedId()
	local veh = GetVehiclePedIsIn(ped,false)
    if IsPedSittingInAnyVehicle(ped) and IsVehicleModel(veh,defaultHash) or IsVehicleModel(veh,defaultHash2) or IsVehicleModel(veh,defaultHash3) or IsVehicleModel(veh,defaultHash4)  and PlayerData.metadata['pursuit'] then
        if (not IsPauseMenuActive()) then 
            if allow then
                lastVehicle = veh
                allow = false
                if mode == 0 then
                    mode = 1
                    TriggerEvent('police:Ghost:Pursuit:Mode:A') --1
                    Citizen.Wait(1500)
                    TriggerEvent('police:Ghost:Pursuit:Mode:A') --1
                    TriggerEvent('hud:client:pursuitmode', 33)
                    Citizen.Wait(1500)
                elseif mode == 1 then
                    -- if not IsVehicleModel(veh,defaultHash4) then
                        mode = 2
                        TriggerEvent('police:Ghost:Pursuit:B:Plus') --2
                        Citizen.Wait(1500)
                        TriggerEvent('police:Ghost:Pursuit:B:Plus') --2
                        TriggerEvent('hud:client:pursuitmode', 50)
                        Citizen.Wait(1500)
                    -- else
                    --     mode = 0
                    --     TriggerEvent('police:pursuitmodeOff') --0
                    --     Citizen.Wait(1500)
                    --     TriggerEvent('police:pursuitmodeOff') --0
                    --     TriggerEvent('hud:client:pursuitmode', 0)
                    --     Citizen.Wait(1500)
                    -- end
                elseif mode == 2 then
                    if not IsVehicleModel(veh,defaultHash3) and not IsVehicleModel(veh,defaultHash4) then
                        mode = 3
                        TriggerEvent('police:Ghost:Pursuit:SPlusMode') --3
                        Citizen.Wait(1500)
                        TriggerEvent('police:Ghost:Pursuit:SPlusMode') --3
                        TriggerEvent('hud:client:pursuitmode', 100)
                        Citizen.Wait(1500)
                    else
                        mode = 0
                        TriggerEvent('police:pursuitmodeOff') --0
                        Citizen.Wait(1500)
                        TriggerEvent('police:pursuitmodeOff') --0
                        TriggerEvent('hud:client:pursuitmode', 0)
                        Citizen.Wait(1500)
                    end
                elseif mode == 3 then
                    mode = 0
                    TriggerEvent('police:pursuitmodeOff') --0
                    Citizen.Wait(1500)
                    TriggerEvent('police:pursuitmodeOff') --0
                    TriggerEvent('hud:client:pursuitmode', 0)
                    Citizen.Wait(1500)
                end
                Citizen.Wait(15)
                allow = true
            end
        end
    end
end)

exports['aj-base']:CreateBind('Pursuit2', nil, 'Police: Pusuit Mode -', '', function()
    local ped = PlayerPedId()
	local veh = GetVehiclePedIsIn(ped,false)
    if IsPedSittingInAnyVehicle(ped) and IsVehicleModel(veh,defaultHash) or IsVehicleModel(veh,defaultHash2) or IsVehicleModel(veh,defaultHash3) or IsVehicleModel(veh,defaultHash4)  and PlayerData.metadata['pursuit'] then
        if (not IsPauseMenuActive()) then 
            if allow then
                allow = false
                if mode == 0 then
                    if not IsVehicleModel(veh,defaultHash3) and not IsVehicleModel(veh,defaultHash4) then
                        mode = 3
                        TriggerEvent('police:Ghost:Pursuit:SPlusMode')
                        Citizen.Wait(1500)
                        TriggerEvent('police:Ghost:Pursuit:SPlusMode')
                        TriggerEvent('hud:client:pursuitmode', 100)
                        Citizen.Wait(1500)
                    else
                        mode = 2
                        TriggerEvent('police:Ghost:Pursuit:B:Plus')
                        Citizen.Wait(1500)
                        TriggerEvent('police:Ghost:Pursuit:B:Plus')
                        TriggerEvent('hud:client:pursuitmode', 50)
                        Citizen.Wait(1500)
                    end
                elseif mode == 3 then
                    if not IsVehicleModel(veh,defaultHash4) then
                        mode = 2
                        TriggerEvent('police:Ghost:Pursuit:B:Plus')
                        Citizen.Wait(1500)
                        TriggerEvent('police:Ghost:Pursuit:B:Plus')
                        TriggerEvent('hud:client:pursuitmode', 50)
                        Citizen.Wait(1500)
                    else
                        mode = 1
                        TriggerEvent('police:Ghost:Pursuit:Mode:A')
                        Citizen.Wait(1500)
                        TriggerEvent('police:Ghost:Pursuit:Mode:A')
                        TriggerEvent('hud:client:pursuitmode', 33)
                        Citizen.Wait(1500)
                    end
                elseif mode == 2 then
                    mode = 1
                    TriggerEvent('police:Ghost:Pursuit:Mode:A')
                    Citizen.Wait(1500)
                    TriggerEvent('police:Ghost:Pursuit:Mode:A')
                    TriggerEvent('hud:client:pursuitmode', 33)
                    Citizen.Wait(1500)
                elseif mode == 1 then
                    mode = 0
                    TriggerEvent('police:pursuitmodeOff')
                    Citizen.Wait(1500)
                    TriggerEvent('police:pursuitmodeOff')
                    TriggerEvent('hud:client:pursuitmode', 0)
                    Citizen.Wait(1500)
                end
                Citizen.Wait(15)
                allow = true
            end
        end
    end
end)