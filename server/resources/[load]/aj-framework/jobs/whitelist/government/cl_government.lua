local loop = false

local function DrawText3Ds(coords, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function VehicleList()
    local Menu = {
        {
            isMenuHeader = true,
            header = 'GPS'
        },
    }
    for i = 1 , #Config.Jobs['Whitelist']['Government']['Vehicles'] do
        Menu[#Menu + 1] = {
            header = Config.Jobs['Whitelist']['Government']['Vehicles'][i].label,
            params = {
                event = 'aj-governments:client:Spawnvehicle',
                args = {
                    model = Config.Jobs['Whitelist']['Government']['Vehicles'][i].model
                }
            }
        }
    end
    ModularUI:openMenu(Menu)
end

local function SpawnVehicle(model)
    local coords = Config.Jobs['Whitelist']['Government']['Vehicle']
    AJFW.Functions.SpawnVehicle(model, function(veh)
        SetVehicleNumberPlateText(veh, "GOV"..tostring(math.random(1000, 9999)))
        exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(veh), 'body', 1000.0)
        exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(veh), 'engine', 1000.0)
        exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(veh), 'fuel', 100)
        exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(veh), 'clutch', 100)
        exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(veh), 'brakes', 100)
        exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(veh), 'axle', 100)
        exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(veh), 'radiator', 100)
        SetEntityHeading(veh, coords.w)
        exports['aj-fuel']:SetFuel(veh, 100.0)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", AJFW.Functions.GetPlate(veh))
        SetVehicleCustomPrimaryColour(veh, 0, 0, 0)
        SetVehicleEngineOn(veh, true, true)
        SetVehicleDirtLevel(veh)
        SetVehicleUndriveable(veh, false)
        WashDecalsFromVehicle(veh, 1.0)
    end, coords, true)
end

local function StartLoop_government()
    if not loop then
        loop = true
        CreateThread(function()
            while loop do
                local sleep = 2500
                if LocalPlayer.state.isLoggedIn then
                    if PlayerJob.name == 'government' then
                        sleep = 1500
                        local pos = GetEntityCoords(GlobalPlayerPedID)
                        for k,v in pairs(Config.Jobs['Whitelist']['Government']) do
                            if k == 'Vehicle' then
                                local target = vector3( Config.Jobs['Whitelist']['Government']['Vehicle'].x,Config.Jobs['Whitelist']['Government']['Vehicle'].y,Config.Jobs['Whitelist']['Government']['Vehicle'].z)
                                local dist = #(pos - target)
                                if dist <= 10 then
                                    sleep = 5
                                    DrawMarker(2, target, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)
                                    if dist <=1.5 then
                                        DrawText3Ds(target, '[E] vehicle')
                                        if IsControlJustPressed(0, 38) then
                                            if IsPedInAnyVehicle(GlobalPlayerPedID) then
                                                DeleteVehicle(GetVehiclePedIsIn(GlobalPlayerPedID))
                                            else
                                                VehicleList()
                                            end
                                        end
                                    end
                                end
                            elseif k == 'stash' then
                                local target = Config.Jobs['Whitelist']['Government']['stash']
                                local dist = #(pos - target)
                                if dist <= 5 then
                                    sleep = 5
                                    DrawMarker(2, target, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)
                                    if dist <= 1 then
                                        DrawText3Ds(target, "[E] Open Stash")
                                        if IsControlJustPressed(0, 38) then
                                            TriggerEvent("inventory:client:SetCurrentStash", "governmentstash")
                                            TriggerServerEvent("inventory:server:OpenInventory", "stash", "governmentstash", {
                                                maxweight = 4000000,
                                                slots = 500,
                                            })
                                        end
                                    end
                                end
                            elseif k == 'Private' then
                                for i = 1, #Config.Jobs['Whitelist']['Government']['Private'] do
                                    if type(Config.Jobs['Whitelist']['Government']['Private'][i]["Name"]) == 'table' then
                                        for j = 1, #Config.Jobs['Whitelist']['Government']['Private'][i]["Name"] do
                                            if PlayerJob.grade.name == Config.Jobs['Whitelist']['Government']['Private'][i]["Name"][j] then
                                                local target = Config.Jobs['Whitelist']['Government']['Private'][i]["Coords"]
                                                local dist = #(pos-target)
                                                if dist <= 5 then
                                                    sleep = 5
                                                    if dist <= 1 then
                                                        DrawText3Ds(target, Config.Jobs['Whitelist']['Government']['Private'][i]["text"])
                                                        if IsControlJustPressed(0, 38) then
                                                            TriggerServerEvent("inventory:server:OpenInventory", "stash", Config.Jobs['Whitelist']['Government']['Private'][i]["Secret"]..AJFW.Functions.GetPlayerData().citizenid)
                                                            TriggerEvent("inventory:client:SetCurrentStash", Config.Jobs['Whitelist']['Government']['Private'][i]["Secret"]..AJFW.Functions.GetPlayerData().citizenid)
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    else
                                        if PlayerJob.grade.name == Config.Jobs['Whitelist']['Government']['Private'][i]["Name"] then
                                            local target = Config.Jobs['Whitelist']['Government']['Private'][i]["Coords"]
                                            local dist = #(pos-target)
                                            if dist <= 5 then
                                                sleep = 5
                                                if dist <= 1 then
                                                    DrawText3Ds(target, Config.Jobs['Whitelist']['Government']['Private'][i]["text"])
                                                    if IsControlJustPressed(0, 38) then
                                                        TriggerServerEvent("inventory:server:OpenInventory", "stash", Config.Jobs['Whitelist']['Government']['Private'][i]["Secret"]..AJFW.Functions.GetPlayerData().citizenid)
                                                        TriggerEvent("inventory:client:SetCurrentStash", Config.Jobs['Whitelist']['Government']['Private'][i]["Secret"]..AJFW.Functions.GetPlayerData().citizenid)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            elseif k == 'Armory' then
                                for i = 1, #Config.Jobs['Whitelist']['Government']['Armory'] do
                                    if type(Config.Jobs['Whitelist']['Government']['Armory'][i]["Name"]) == 'table' then
                                        for j = 1, #Config.Jobs['Whitelist']['Government']['Armory'][i]["Name"] do
                                            if PlayerJob.grade.name == Config.Jobs['Whitelist']['Government']['Armory'][i]["Name"][j] then
                                                local target = Config.Jobs['Whitelist']['Government']['Armory'][i]["Coords"]
                                                local dist = #(pos-target)
                                                if dist <= 5 then
                                                    sleep = 5
                                                    if dist <= 1 then
                                                        DrawText3Ds(target, Config.Jobs['Whitelist']['Government']['Armory'][i]["text"])
                                                        if IsControlJustPressed(0, 38) then
                                                            TriggerServerEvent("inventory:server:OpenInventory", "shop", 'police', Config.Jobs['Whitelist']['Government']['ArmoryItems'][Config.Jobs['Whitelist']['Government']['Armory'][i]["Secret"]])
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    else
                                        if PlayerJob.grade.name == Config.Jobs['Whitelist']['Government']['Armory'][i]["Name"] then
                                            local target = Config.Jobs['Whitelist']['Government']['Armory'][i]["Coords"]
                                            local dist = #(pos-target)
                                            if dist <= 5 then
                                                sleep = 5
                                                if dist <= 1 then
                                                    DrawText3Ds(target, Config.Jobs['Whitelist']['Government']['Armory'][i]["text"])
                                                    if IsControlJustPressed(0, 38) then
                                                        TriggerServerEvent("inventory:server:OpenInventory", "shop", 'police', Config.Jobs['Whitelist']['Government']['ArmoryItems'][Config.Jobs['Whitelist']['Government']['Armory'][i]["Secret"]])
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                Wait(sleep)
            end
        end)
    end
end

local function StopLoop_government()
    if loop then
        loop = false
    end
end

exports('StartLoop_government',StartLoop_government)
exports('StopLoop_government',StopLoop_government)

RegisterNetEvent('aj-governments:client:Spawnvehicle', function(data)
    SpawnVehicle(data.model)
end)

RegisterNetEvent('government:ToggleDuty', function()
    TriggerServerEvent("AJFW:ToggleDuty")
end)