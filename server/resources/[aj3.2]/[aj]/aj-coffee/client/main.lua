local AJFW = exports['aj-base']:GetCoreObject()

local PlayerData = {}
local loop = false
local showText = false
local Menu = nil

local function CheckPlayers(vehicle)
    for i = -1, 5,1 do                
        seat = GetPedInVehicleSeat(vehicle,i)
        if seat ~= 0 then
            TaskLeaveVehicle(seat,vehicle,4)
            SetVehicleDoorsLocked(vehicle)
            Wait(1500)
            AJFW.Functions.DeleteVehicle(vehicle)
        end
   end
   if showText then
        exports['aj-text']:HideText(4)
        showText = false
    end
end

local function SpawnListVehicle(model)
    local coords = Config.Locations["vehicle"]
    local plate = "AC"..math.random(1111, 9999)
    -- local vehNear = AJFW.Functions.CheckFuckingCar(coords)
    -- if vehNear > 5 then
        -- AJFW.Functions.Notify('There is a vehicle at the spot', 'error', 3000)
    -- else
        AJFW.Functions.SpawnVehicle(model, function(veh)
            SetVehicleNumberPlateText(veh, "ACBV"..tostring(math.random(1000, 9999)))
            SetEntityHeading(veh, coords.a)
            exports['aj-fuel']:SetFuel(veh, 100.0)
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
            SetVehicleEngineOn(veh, true, true)
        end, coords, true)
        exports['aj-text']:ChangeText(
            '[E] Hide The Vehicle ',
            99, 62, 35,0.7,
            4,
            50
        )
    -- end
end

local function VehicleList()
    Menu = MenuV:CreateMenu(false,"Coffee Garage", 'topright', 135, 57, 0, 'size-125', 'none', 'menuv')
    for k,v in pairs(Config.Vehicles) do
        Menu:AddButton({
            icon = '☕',
            label = v,
            select = function(btn)
            MenuV:CloseAll()
            SpawnListVehicle(k)
            end
        })
    end
    MenuV:OpenMenu(Menu)
end

local function CoffeeVehicle()
    CreateThread(function()
        while loop do
            sleep = 1500
            if PlayerData.job.onduty then
                sleep = 1000
                local ped = PlayerPedId()
                local pos = GetEntityCoords(ped)
                local vehicleloc = Config.Locations['vehicle']
                local coords = vector3(vehicleloc.x, vehicleloc.y, vehicleloc.z)
                local dist = #(pos - coords)
                if dist < 20 then
                    sleep = 5
                    DrawMarker(2, vehicleloc.x, vehicleloc.y, vehicleloc.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 210, 50, 9, 255, false, false, false, true, false, false, false)
                    if dist < 1 then
                        if IsPedInAnyVehicle(ped, false) then
                            if not showText then
                                exports['aj-text']:DrawText(
                                    '[E] Hide the vehicle',
                                    99, 62, 35,0.7,
                                    4,
                                    50
                                )
                                showText = true
                            end
                            if IsControlJustPressed(0, 38) then
                                CheckPlayers(GetVehiclePedIsIn(ped))
                            end
                        else
                            if not showText then
                                exports['aj-text']:DrawText(
                                    '[E] Grab vehicle',
                                    99, 62, 35,0.7,
                                    4,
                                    50
                                )
                                showText = true
                            end
                            if IsControlJustPressed(0, 38) then
                                VehicleList()
                            end
                        end
                    else
                        if showText then
                            exports['aj-text']:HideText(4)
                            showText = false
                        end
                    end
                end
            end
            Wait(sleep)
        end
    end)
end

RegisterNetEvent('AJFW:Client:OnPlayerLoaded', function()
    PlayerData = AJFW.Functions.GetPlayerData()
    if PlayerData.job.name == 'beanmachine' then
        if not loop then
            loop = true
            CoffeeVehicle()
        end
    end
end)

RegisterNetEvent('AJFW:Client:OnPlayerUnload', function()
    loop = false
    PlayerData = {}
end)

RegisterNetEvent('AJFW:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
    if PlayerData.job.name == 'beanmachine' then
        if not loop then
            loop = true
            CoffeeVehicle()
        end
    else
        if loop then
            loop = false
        end
    end
end)

RegisterNetEvent('aj-coffee:stash', function(data)
    TriggerEvent("inventory:client:SetCurrentStash", "coffeestash")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "coffeestash", {
        maxweight = 10000000,
        slots = 500,
    })
end)

RegisterNetEvent('aj-coffee:order', function(data)
    TriggerEvent("inventory:client:SetCurrentStash", "open_coffeestash")
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "open_coffeestash", {
        maxweight = 4000000,
        slots = 500,
    })
end)

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
    exports['aj-target']:RemoveZone("bennystorage")
    exports['aj-target']:RemoveZone("bennyorder")
   end
end)

CreateThread(function()
    exports['aj-target']:AddBoxZone("bennystorage", vector3(-631.90, 228.60, 81.88), 0.7, 1.5, {
        name="Coffee",
        heading=359.61,
        debugPoly=false,
        minZ=80.94834,
        maxZ=82.97834,
        }, {
            options = {
                {
                    type = "client",
                    event = "aj-coffee:stash",
                    icon = "fas fa-box",
                    label = "Open Storage",
                    job = 'beanmachine',
                },
            },
            distance = 1.0
        }
    )
    exports['aj-target']:AddBoxZone("bennyorder", vector3(-634.39, 235.32, 81.88), 0.7, 1.5, {
        name="Coffee",
        heading=275.53,
        debugPoly=false,
        minZ=81.94834,
        maxZ=82.27834,
        }, {
            options = {
                {
                    type = "client",
                    event = "aj-coffee:order",
                    icon = "fas fa-box",
                    label = "Take Order",
                    job = all,
                },
            },
            distance = 2.0
        }
    )
end)