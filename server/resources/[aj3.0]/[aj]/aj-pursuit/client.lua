local AJFW = exports['aj-base']:GetCoreObject()

local PlayerData = {}

local CFGS = {
    {              -- Charger
        {
            ['fInitialDriveForce'] = 0.2700000,
            ['fDriveInertia'] = 1.000000,
            ['fTractionLossMult'] = 0.500000,
        },
        {
            ['fInitialDriveForce'] = 0.4370000,
            ['fDriveInertia'] = 1.000000,
            ['fTractionLossMult'] = 0.400000,
        },
        {
            ['fInitialDriveForce'] = 0.4470000,
            ['fDriveInertia'] = 1.100000,
            ['fTractionLossMult'] = 0.300000,
        },
        {
            ['fInitialDriveForce'] = 0.4770000,
            ['fDriveInertia'] = 1.200000,
            ['fTractionLossMult'] = 0.200000,
        },
    },
    {              -- Mustang
        {
            ['fInitialDriveForce'] = 0.2700000,
            ['fDriveInertia'] = 1.000000,
            ['fTractionLossMult'] = 0.500000,
        },
        {
            ['fInitialDriveForce'] = 0.4470000,
            ['fDriveInertia'] = 1.100000,
            ['fTractionLossMult'] = 0.400000,
        },
        {
            ['fInitialDriveForce'] = 0.4770000,
            ['fDriveInertia'] = 1.200000,
            ['fTractionLossMult'] = 0.300000,
        },
        {
            ['fInitialDriveForce'] = 0.5000000,
            ['fDriveInertia'] = 1.300000,
            ['fTractionLossMult'] = 0.200000,
        },
    },
    {              -- Challenger
        {
            ['fInitialDriveForce'] = 0.2700000,
            ['fDriveInertia'] = 1.000000,
            ['fTractionLossMult'] = 0.500000,
        },
        {
            ['fInitialDriveForce'] = 0.4470000,
            ['fDriveInertia'] = 1.100000,
            ['fTractionLossMult'] = 0.400000,
        },
        {
            ['fInitialDriveForce'] = 0.4770000,
            ['fDriveInertia'] = 1.200000,
            ['fTractionLossMult'] = 0.300000,
        },
        {
            ['fInitialDriveForce'] = 0.5670000,
            ['fDriveInertia'] = 1.300000,
            ['fTractionLossMult'] = 0.200000,
        },
    },
    {              -- Corvette
        {
            ['fInitialDriveForce'] = 0.2700000,
            ['fDriveInertia'] = 1.000000,
            ['fTractionLossMult'] = 0.500000,
        },
        {
            ['fInitialDriveForce'] = 0.4470000,
            ['fDriveInertia'] = 1.100000,
            ['fTractionLossMult'] = 0.300000,
        },
        {
            ['fInitialDriveForce'] = 0.4770000,
            ['fDriveInertia'] = 1.200000,
            ['fTractionLossMult'] = 0.200000,
        },
        {
            ['fInitialDriveForce'] = 0.5670000,
            ['fDriveInertia'] = 1.300000,
            ['fTractionLossMult'] = 0.100000,
        },
    },
}

RegisterNetEvent('AJFW:Client:OnPlayerLoaded', function()
	PlayerData = AJFW.Functions.GetPlayerData()
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
	PlayerData = AJFW.Functions.GetPlayerData()
   end
end)

local defaultHash, defaultHash2, defaultHash3, defaultHash4 = "npolchal","npolvette","npolstang","npolchar"

RegisterNetEvent("police:Ghost:Pursuit:Mode:A", function()
	local ped = PlayerPedId()
	if (IsPedInAnyVehicle(PlayerPedId(), true)) then
		local veh = GetVehiclePedIsIn(PlayerPedId(),false)  
		local Driver = GetPedInVehicleSeat(veh, -1)
		local fInitialDriveForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
		
        if IsPedSittingInAnyVehicle(ped) and IsVehicleModel(veh,defaultHash) or IsVehicleModel(veh,defaultHash2) or IsVehicleModel(veh,defaultHash3)
		   or IsVehicleModel(veh,defaultHash4)  and PlayerData.metadata['pursuit'] then
			SetVehicleModKit(veh, 0)
			SetVehicleMod(veh, 46, 4, true) 
			SetVehicleMod(veh, 11, 4, true)
			SetVehicleMod(veh, 12, -1, false)
			SetVehicleMod(veh, 13, -1, false)  
			ToggleVehicleMod(veh,  18, false)          
            AJFW.Functions.Notify('Pursuit Mode : Level 1', 'error', 3000) 
			local objects = {}
            if IsVehicleModel(veh,"npolchar") then
                objects = CFGS[1][2]
            elseif IsVehicleModel(veh,"npolstang") then
                objects = CFGS[2][2]
            elseif IsVehicleModel(veh,"npolchal") then
                objects = CFGS[3][2]
            elseif IsVehicleModel(veh,"npolvette") then
                objects = CFGS[4][2]
            end
            for k,v in pairs(objects) do
                SetVehicleHandlingField(veh, 'CHandlingData', k, v)
            end
		else
            AJFW.Functions.Notify('You are not in a HEAT vehicle', 'error', 3000) 
		end
	end
end)

RegisterNetEvent("police:Ghost:Pursuit:B:Plus", function()
    local ped = PlayerPedId()
	if (IsPedInAnyVehicle(PlayerPedId(), true)) then
		local veh = GetVehiclePedIsIn(PlayerPedId(),false)  
		local Driver = GetPedInVehicleSeat(veh, -1)
        local fInitialDriveForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
        
        if IsPedSittingInAnyVehicle(ped) and IsVehicleModel(veh,defaultHash) or IsVehicleModel(veh,defaultHash2) or IsVehicleModel(veh,defaultHash3)  -- Vehicle Checks
	       or IsVehicleModel(veh,defaultHash4)  and PlayerData.metadata['pursuit'] then
            SetVehicleModKit(veh, 0)
            SetVehicleMod(veh, 46, 4, true)
            SetVehicleMod(veh, 11, 4, true)
            SetVehicleMod(veh, 12, 2, true)
            SetVehicleMod(veh, 13, 3, true)  
            ToggleVehicleMod(veh,  18, true)     
            AJFW.Functions.Notify('Pursuit Mode : Level 2', 'error', 3000)        
            local objects = {}
            if IsVehicleModel(veh,"npolchar") then
                objects = CFGS[1][3]
            elseif IsVehicleModel(veh,"npolstang") then
                objects = CFGS[2][3]
            elseif IsVehicleModel(veh,"npolchal") then
                objects = CFGS[3][3]
            elseif IsVehicleModel(veh,"npolvette") then
                objects = CFGS[4][3]
            end
            for k,v in pairs(objects) do
                SetVehicleHandlingField(veh, 'CHandlingData', k, v)
            end
        else
            AJFW.Functions.Notify('You are not in a HEAT vehicle', 'error', 3000)
        end
    end
end)

RegisterNetEvent("police:Ghost:Pursuit:SPlusMode", function()
    local ped = PlayerPedId()
	if (IsPedInAnyVehicle(PlayerPedId(), true)) then
		local veh = GetVehiclePedIsIn(PlayerPedId(),false)  
		local Driver = GetPedInVehicleSeat(veh, -1)
        local fInitialDriveForce = GetVehicleHandlingFloat(veh, 'CHandlingData', 'fInitialDriveForce')
        
        if IsPedSittingInAnyVehicle(ped) and IsVehicleModel(veh,defaultHash) or IsVehicleModel(veh,defaultHash2) or IsVehicleModel(veh,defaultHash3) 
           or IsVehicleModel(veh,defaultHash4) and PlayerData.metadata['pursuit'] then
            SetVehicleModKit(veh, 0)
            SetVehicleMod(veh, 46, 4, true)
            SetVehicleMod(veh, 11, 4, true)
            SetVehicleMod(veh, 12, 2, true)
            SetVehicleMod(veh, 13, 3, true)  
            ToggleVehicleMod(veh,  18, true)             
            AJFW.Functions.Notify('Pursuit Mode : Level 3', 'error', 3000)   
            local objects = {}
            if IsVehicleModel(veh,"npolchar") then
                objects = CFGS[1][4]
            elseif IsVehicleModel(veh,"npolstang") then
                objects = CFGS[2][4]
            elseif IsVehicleModel(veh,"npolchal") then
                objects = CFGS[3][4]
            elseif IsVehicleModel(veh,"npolvette") then
                objects = CFGS[4][4]
            end
            for k,v in pairs(objects) do
                SetVehicleHandlingField(veh, 'CHandlingData', k, v)
            end
        else
            AJFW.Functions.Notify('You are not in a HEAT vehicle', 'error', 3000)
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
            AJFW.Functions.Notify('Pursuit Mode Disabled', 'error', 3000)
            local objects = {}
            if IsVehicleModel(veh,"npolchar") then
                objects = CFGS[1][1]
            elseif IsVehicleModel(veh,"npolstang") then
                objects = CFGS[2][1]
            elseif IsVehicleModel(veh,"npolchal") then
                objects = CFGS[3][1]
            elseif IsVehicleModel(veh,"npolvette") then
                objects = CFGS[4][1]
            end
            for k,v in pairs(objects) do
                SetVehicleHandlingField(veh, 'CHandlingData', k, v)
            end
        else
            AJFW.Functions.Notify('You are not in a HEAT vehicle', 'error', 3000)
        end
    end
end)
local mode = 0
local allow = true

exports['aj-framework']:CreateBind('Pursuit', nil, 'Police: Pusuit Mode +', '', function()
    local ped = PlayerPedId()
	local veh = GetVehiclePedIsIn(ped,false)
    if IsPedSittingInAnyVehicle(ped) and IsVehicleModel(veh,defaultHash) or IsVehicleModel(veh,defaultHash2) or IsVehicleModel(veh,defaultHash3) or IsVehicleModel(veh,defaultHash4)  and PlayerData.metadata['pursuit'] then
        if (not IsPauseMenuActive()) then 
            if PlayerData.metadata['pursuit'] and allow then
                allow = false
                if mode == 0 then
                    mode = 1
                    TriggerEvent('police:Ghost:Pursuit:Mode:A') --1
                    Citizen.Wait(1500)
                    TriggerEvent('police:Ghost:Pursuit:Mode:A') --1
                    TriggerEvent('hud:client:pursuitmode', 33)
                    Citizen.Wait(1500)
                elseif mode == 1 then
                    mode = 2
                    TriggerEvent('police:Ghost:Pursuit:B:Plus') --2
                    Citizen.Wait(1500)
                    TriggerEvent('police:Ghost:Pursuit:B:Plus') --2
                    TriggerEvent('hud:client:pursuitmode', 66)
                    Citizen.Wait(1500)
                elseif mode == 2 then
                    mode = 3
                    TriggerEvent('police:Ghost:Pursuit:SPlusMode') --3
                    Citizen.Wait(1500)
                    TriggerEvent('police:Ghost:Pursuit:SPlusMode') --3
                    TriggerEvent('hud:client:pursuitmode', 100)
                    Citizen.Wait(1500)
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

exports['aj-framework']:CreateBind('Pursuit2', nil, 'Police: Pusuit Mode -', '', function()
    local ped = PlayerPedId()
	local veh = GetVehiclePedIsIn(ped,false)
    if IsPedSittingInAnyVehicle(ped) and IsVehicleModel(veh,defaultHash) or IsVehicleModel(veh,defaultHash2) or IsVehicleModel(veh,defaultHash3) or IsVehicleModel(veh,defaultHash4)  and PlayerData.metadata['pursuit'] then
        if (not IsPauseMenuActive()) then 
            if PlayerData.metadata['pursuit'] and allow then
                allow = false
                if mode == 0 then
                    mode = 3
                    TriggerEvent('police:Ghost:Pursuit:SPlusMode')
                    Citizen.Wait(1500)
                    TriggerEvent('police:Ghost:Pursuit:SPlusMode')
                    TriggerEvent('hud:client:pursuitmode', 100)
                    Citizen.Wait(1500)
                elseif mode == 3 then
                    mode = 2
                    TriggerEvent('police:Ghost:Pursuit:B:Plus')
                    Citizen.Wait(1500)
                    TriggerEvent('police:Ghost:Pursuit:B:Plus')
                    TriggerEvent('hud:client:pursuitmode', 66)
                    Citizen.Wait(1500)
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