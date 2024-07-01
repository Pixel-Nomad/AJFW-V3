local Chickens = {}
local Catched = 0
local Working = false
local Packing = false
local props = {}
local blips = {}
local busy = false
    
blips['Start'] = Modular:CreateBlip({
    ID          = 'jobs_blacklist_chickenjob_start',
    Type        = 'Coords',
    Coords      = Config.Jobs['Blacklist']['Chicken']['Start'],
    Sprite      = 463,
    Display     = 4,
    Scale       = 0.8,
    Color       = 46,
    ShortRange  = true,
    Title       = 'Chicken Farm',
})

blips['Portion'] = Modular:CreateBlip({
    ID          = 'jobs_blacklist_chickenjob_portion',
    Type        = 'Coords',
    Coords      = vector3(Config.Jobs['Blacklist']['Chicken']['Portions'][1].x,Config.Jobs['Blacklist']['Chicken']['Portions'][1].y,Config.Jobs['Blacklist']['Chicken']['Portions'][1].z),
    Sprite      = 463,
    Display     = 4,
    Scale       = 0.8,
    Color       = 46,
    ShortRange  = true,
    Title       = 'Slaughterhouse',
})

blips['Sell'] = Modular:CreateBlip({
    ID          = 'jobs_blacklist_chickenjob_sell',
    Type        = 'Coords',
    Coords      = Config.Jobs['Blacklist']['Chicken']['Sell'],
    Sprite      = 431,
    Display     = 4,
    Scale       = 0.8,
    Color       = 46,
    ShortRange  = true,
    Title       = 'Chicken Dealer',
})

local function DrawText3D(x, y, z, text)
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

local function JobStart()
    DoScreenFadeOut(500)
	Wait(500)
    SetEntityCoordsNoOffset(PlayerPedId(), 2385.963, 5047.333, 46.400, 0, 0, 1)
    RequestModel(GetHashKey('a_c_hen'))
	while not HasModelLoaded(GetHashKey('a_c_hen')) do
	    Wait(1)
	end
    for i = 1, #Config.Jobs['Blacklist']['Chicken']['Chickens'] do
        Chickens[i] = CreatePed(26, 'a_c_hen', Config.Jobs['Blacklist']['Chicken']['Chickens'][i], true, false)
        TaskReactAndFleePed(Chickens[i], PlayerPedId())
    end
    Wait(500)
    DoScreenFadeIn(500)
    Working = true
end

local function TryCatch(i)
    AJFW.Functions.RequestAnimDict('move_jump')
    TaskPlayAnim(PlayerPedId(), 'move_jump', 'dive_start_run', 8.0, -8.0, -1, 0, 0.0, 0, 0, 0)
	Wait(600)
	SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
    Wait(1000)
    local chance = math.random(1,100)
    if chance <= 60 then
        AJFW.Functions.Notify("You managed to catch 1 chicken!", "success")
        DeleteEntity(Chickens[i])
        Catched = Catched + 1
    else
        AJFW.Functions.Notify("The chicken escaped your arms!", "error")
    end
end

local function SellChicken()
	AJFW.Functions.TriggerCallback('AJFW:HasItem', function(result)
		if result then
			local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(GlobalPlayerPedID, 0.0, 0.9, -0.98))
			props['sellbox'] = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z,  true,  true, true)
			SetEntityHeading(props['sellbox'], GetEntityHeading(GlobalPlayerPedID))
			AJFW.Functions.RequestAnimDict('amb@medic@standing@tendtodead@idle_a')
			TaskPlayAnim(PlayerPedId(), 'amb@medic@standing@tendtodead@idle_a', 'idle_a', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
			AJFW.Functions.Progressbar("Cut-", "Selling..", 10000, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {}, {}, {}, function()
				AJFW.Functions.TriggerCallback('AJFW:HasItem', function(result1)
					if result1 then	
						TriggerServerEvent("aj-chickenjob:sell")
					else
						AJFW.Functions.Notify("You have nothing to sell!", "error")
						-- FreezeEntityPosition(GlobalPlayerPedID,false)
					end
				end, 'packagedchicken')
				ClearPedTasks(GlobalPlayerPedID)
				DeleteEntity(props['sellbox'])
			end, function() -- Cancel
				AJFW.Functions.RequestAnimDict('amb@medic@standing@tendtodead@exit')
				TaskPlayAnim(PlayerPedId(), 'amb@medic@standing@tendtodead@exit', 'exit', 8.0, -8.0, -1, 1, 0.0, 0, 0, 0)
				ClearPedTasks(GlobalPlayerPedID)
				DeleteEntity(props['sellbox'])
				-- FreezeEntityPosition(GlobalPlayerPedID,false)
			end)
		else
			AJFW.Functions.Notify("You have nothing to sell!", "error")
		end
	end, 'packagedchicken')
end

local function Cut(i)
    AJFW.Functions.TriggerCallback('AJFW:HasItem', function(result)
		if result then
			AJFW.Functions.RequestAnimDict('anim@amb@business@coc@coc_unpack_cut_left@')
			FreezeEntityPosition(GlobalPlayerPedID,true)
			TaskPlayAnim(PlayerPedId(), 'anim@amb@business@coc@coc_unpack_cut_left@', "coke_cut_v1_coccutter", 3.0, -8, -1, 63, 0, 0, 0, 0 )
            local PedCoords = GetEntityCoords(GlobalPlayerPedID)
			props['knife'] = CreateObject(GetHashKey('prop_knife'), PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
			AttachEntityToEntity(props['knife'], GlobalPlayerPedID, GetPedBoneIndex(GlobalPlayerPedID, 0xDEAD), 0.13, 0.14, 0.09, 40.0, 0.0, 0.0, false, false, false, false, 2, true)
            SetEntityHeading(GlobalPlayerPedID, Config.Jobs['Blacklist']['Chicken']['Portions'][i].w)
            props['chicken'] = CreateObject(GetHashKey('prop_int_cf_chick_01'), Config.Jobs['Blacklist']['Chicken']['Portions-chicken'][i], true, true, true)
			SetEntityRotation(props['chicken'],90.0, 0.0, -45.0, 1,true)
            AJFW.Functions.Progressbar("Cut-", "Slaughtering..", 15000, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {}, {}, {}, function()
                AJFW.Functions.TriggerCallback('AJFW:HasItem', function(result1)
                    if result1 then	
                        AJFW.Functions.Notify("Now Pack slaughtered chicken!", "primary")
                        TriggerServerEvent("aj-chickenjob:getcutChicken")
                    else
                        AJFW.Functions.Notify("You dont have any chickens!", "error")
                        FreezeEntityPosition(GlobalPlayerPedID,false)
                    end
                end, 'alivechicken')
                FreezeEntityPosition(GlobalPlayerPedID,false)
                DeleteEntity(props['knife'])
                DeleteEntity(props['chicken'])
			end, function() -- Cancel
				FreezeEntityPosition(GlobalPlayerPedID,false)
				DeleteEntity(props['knife'])
				DeleteEntity(props['chicken'])
				ClearPedTasks(GlobalPlayerPedID)
			end)
		else
			AJFW.Functions.Notify("You dont have any chickens!", "error")
		end
	end, 'alivechicken')
end

local function StartPacking()
    AJFW.Functions.TriggerCallback('AJFW:HasItem', function(result)
		if result then
            Packing = true
			SetEntityHeading(GlobalPlayerPedID, 40.0)
			local PedCoords = GetEntityCoords(GlobalPlayerPedID)
			props['steak'] = CreateObject(GetHashKey('prop_cs_steak'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
			AttachEntityToEntity(props['steak'], GlobalPlayerPedID, GetPedBoneIndex(GlobalPlayerPedID, 0x49D9), 0.15, 0.0, 0.01, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
			props['box'] = CreateObject(GetHashKey('prop_cs_clothes_box'),PedCoords.x, PedCoords.y,PedCoords.z, true, true, true)
			AttachEntityToEntity(props['box'], GlobalPlayerPedID, GetPedBoneIndex(GlobalPlayerPedID, 57005), 0.13, 0.0, -0.16, 250.0, -30.0, 0.0, false, false, false, false, 2, true)
			AJFW.Functions.RequestAnimDict("anim@heists@ornate_bank@grab_cash_heels")
			TaskPlayAnim(PlayerPedId(), "anim@heists@ornate_bank@grab_cash_heels", "grab", 8.0, -8.0, -1, 1, 0, false, false, false)
			FreezeEntityPosition(GlobalPlayerPedID, true)
			AJFW.Functions.Progressbar("wash-", "Packing..", 20000, false, true, {
				disableMovement = true,
				disableCarMovement = true,
				disableMouse = false,
				disableCombat = true,
			}, {}, {}, {}, function()
                AJFW.Functions.TriggerCallback('AJFW:HasItem', function(result4)
                    if result4 then
                        TriggerServerEvent("aj-chickenjob:getpackedChicken")
                        AJFW.Functions.Notify("Keep packing the chicken or go to the vehicle and store it.", "primary")
                    else
                        AJFW.Functions.Notify("You have nothing to pack!", "error")
                        FreezeEntityPosition(GlobalPlayerPedID,false)
                    end
                end, 'slaughteredchicken')
                ClearPedTasks(GlobalPlayerPedID)
                DeleteEntity(props['steak'])
                DeleteEntity(props['box'])
			end, function() -- Cancel
				ClearPedTasks(GlobalPlayerPedID)
                DeleteEntity(props['steak'])
                DeleteEntity(props['box'])
				FreezeEntityPosition(GlobalPlayerPedID, false)
			end)
		else
		
		AJFW.Functions.Notify("You have nothing to pack!", "error")
		end
	end, 'slaughteredchicken')
end

local function StopPacking()
    FreezeEntityPosition(GlobalPlayerPedID, false)
	local idk = true
	local x,y,z = table.unpack(GetEntityCoords(GlobalPlayerPedID))
	props['box2'] = CreateObject(GetHashKey('hei_prop_heist_box'), x, y, z+0.2,  true,  true, true)
	AttachEntityToEntity(props['box2'], GlobalPlayerPedID, GetPedBoneIndex(PlayerPedId(), 60309), 0.025, 0.08, 0.255, -145.0, 290.0, 0.0, true, true, false, true, 1, true)
    Packing = false
    while idk do
        Wait(250)
        local coords = GetEntityCoords(GlobalPlayerPedID)
        AJFW.Functions.RequestAnimDict('anim@heists@box_carry@')
		if not IsEntityPlayingAnim(PlayerPedId(), "anim@heists@box_carry@", "idle", 3 ) and idk == true then
		    TaskPlayAnim(PlayerPedId(), 'anim@heists@box_carry@', "idle", 3.0, -8, -1, 63, 0, 0, 0, 0 )
		end
		idk = false
		AJFW.Functions.Notify("You stopped packing!", "error")
		AJFW.Functions.RequestAnimDict('anim@heists@narcotics@trash')
		TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@trash', "throw_a", 3.0, -8, -1, 63, 0, 0, 0, 0 )
		Wait(900)
		ClearPedTasks(GlobalPlayerPedID)
		DeleteEntity(props['box2'])
	end
end

CreateThread(function()
    while true do
        local sleep = 2500
        if LocalPlayer.state.isLoggedIn then
            sleep = 1500
            local pos = GetEntityCoords(GlobalPlayerPedID)
            if not Working and not Packing then
                for k,v in pairs(Config.Jobs['Blacklist']['Chicken']) do
                    if k == 'Start' then
                        local target = Config.Jobs['Blacklist']['Chicken']['Start']
                        local dist = #(pos - target)
                        if dist <= 5 then
                            sleep = 5
                            DrawMarker(27, target.x, target.y, target.z-0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 255, 255, 200, 0, 0, 0, 0)
                            if dist <= 1.5 then
                                DrawText3D(target.x, target.y, target.z, "~g~[E]~w~ To Catch chickens")
                                if IsControlJustPressed(0, 38) then
                                    DisableControlAction(0, 20, true)
                                    TriggerServerEvent("aj-chickenjob:startChicken")
                                    JobStart()
                                end
                            end
                        end
                    elseif k == 'Sell' then
                        local target = Config.Jobs['Blacklist']['Chicken']['Sell']
                        local dist = #(pos - target)
                        if dist <= 5.0 then
                            sleep = 5
                            if dist <= 2.0 then
                                DrawText3D(target.x, target.y, target.z+0.1, "[E] Sell Packed Chickens")
                                if IsControlJustPressed(0, 38) and not busy then
                                    SellChicken()
                                end
                            end
                        end
                    elseif k == 'Portions' then
                        for i = 1, #Config.Jobs['Blacklist']['Chicken']['Portions'] do
                            local target = vector3(Config.Jobs['Blacklist']['Chicken']['Portions'][i].x, Config.Jobs['Blacklist']['Chicken']['Portions'][i].y, Config.Jobs['Blacklist']['Chicken']['Portions'][i].z)
                            local dist = #(pos - target)
                            if dist <= 5 then
                                sleep = 5
		                        DrawMarker(27, Config.Jobs['Blacklist']['Chicken']['Portions'][i].x, Config.Jobs['Blacklist']['Chicken']['Portions'][i].y, Config.Jobs['Blacklist']['Chicken']['Portions'][i].z-0.97, 0, 0, 0, 0, 0, 0, 0.90, 0.90, 0.90, 255, 255, 255, 200, 0, 0, 0, 0)
                                if dist <= 2.0 then
		                            DrawText3D(Config.Jobs['Blacklist']['Chicken']['Portions'][i].x, Config.Jobs['Blacklist']['Chicken']['Portions'][i].y, Config.Jobs['Blacklist']['Chicken']['Portions'][i].z, "~g~[E]~w~ To portion the chicken")
                                    if IsControlJustPressed(0, 38) and not busy then
                                        Cut(i)
                                    end
                                end
                            end
                        end
                    elseif k == 'Packings' then
                        for i = 1, #Config.Jobs['Blacklist']['Chicken']['Packings'] do
                            local target = Config.Jobs['Blacklist']['Chicken']['Packings'][i]
                            local dist = #(pos - target)
                            if dist <= 5 then
                                sleep = 5
                                if dist <= 2.0 then
                                    DrawText3D(target.x, target.y, target.z, "~g~[E]~w~ To pack chicken")
                                    if IsControlJustPressed(0, 38) and not busy then
                                        StartPacking()
                                    end
                                end
                            end
                        end
                    end
                end
            elseif Working then
                sleep = 5
                for i = 1, #Chickens do
                    local target = GetEntityCoords(Chickens[i])
                    local dist = #(pos-target)
                    if #Config.Jobs['Blacklist']['Chicken']['Chickens'] <= Catched then
                        Working = false
                        Catched = 0
                        DisableControlAction(0, 20, false)
                        AJFW.Functions.Notify("Take Alived Chiken To Process Area ..", "primary")
		                TriggerServerEvent("aj-chickenjob:getNewChicken", #Config.Jobs['Blacklist']['Chicken']['Chickens'])
                    else
                        if dist <= 1.0 then
                            DrawText3D(target.x, target.y, target.z+0.5, "~o~[E]~b~ Catch the chicken")
                            if IsControlJustPressed(0, 38) then
                                TryCatch(i)
                            end
                        end
                    end
                end
            elseif Packing and not busy then
                for i = 1, #Config.Jobs['Blacklist']['Chicken']['Packings'] do
                    local target = Config.Jobs['Blacklist']['Chicken']['Packings'][i]
                    local dist = #(pos - target)
                    if dist <= 5 then
                        sleep = 5
                        if dist <= 2.0 then
                            DrawText3D(target.x, target.y, target.z, "First Cancel your current task")
		                    DrawText3D(target.x, target.y, target.z+0.1, "~g~[G]~w~ To stop packing")
                            if IsControlJustPressed(0, 47) then
                                StopPacking()
                            end
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)