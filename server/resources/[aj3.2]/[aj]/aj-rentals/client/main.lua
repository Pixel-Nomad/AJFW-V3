local AJFW = exports['aj-base']:GetCoreObject()
local Rented = false
local rentedcal = nil

local PlayerData = {}

local function CheckFuckingCar(coords)
    local veh = 1000
    local retval, out = FindFirstVehicle()
    local check
    repeat
        local dist = GetDistanceBetweenCoords(GetEntityCoords(out), coords.x, coords.y, coords.z)
        if dist < veh then
            veh = dist
        end
        check, out = FindNextVehicle(retval, out)
    until not check
    EndFindVehicle(retval)
    return veh
end

RegisterNetEvent('AJFW:Client:OnPlayerLoaded', function()
    PlayerData = AJFW.Functions.GetPlayerData()
end)

AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
    PlayerData = AJFW.Functions.GetPlayerData()
   end
end)

RegisterNetEvent('AJFW:Client:OnPlayerUnload', function()
    PlayerData = {}
end)

RegisterNetEvent('AJFW:Player:SetPlayerData', function(val)
    PlayerData = val
end)

RegisterNetEvent('aj-rental:openMenu', function(k)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local tpos = Config.Data[k]['location']
    local dist = #(pos - tpos)
    if dist < 10 then
        local menu = {
            {
                header = 'Rental Vehicles',
                isMenuHeader = true,
            },
            {
                header = 'Return Vehicle ',
                txt = 'Return your rented vehicle.',
                params = {
                    event = 'aj-rental:return',
                    args = {
                        key = k,
                    }
                }
            },
        }
        for l,m in pairs(Config.Data[k]['vehicles']) do
            menu[#menu + 1] = {
                header = m.label,
                txt = '$' .. m.price,
                params = {
                    event = 'aj-rental:spawncar',
                    args = {
                        key = k,
                        model = l,
                        money = m.price,
                    }
                }
            }
        end
        exports['aj-menu']:showHeader(menu)
    end
end)

RegisterNetEvent('aj-rental:spawncar', function(data)
    local k = data.key
    local money = data.money
    local model = data.model
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local tpos = Config.Data[k]['location']
    local dist = #(pos - tpos)
    if Config.Data[k]['vehicles'][model].licence then
        if PlayerData.metadata['licences']['driver'] then
            if dist < 10 then
                local vehnear = AJFW.Functions.CheckFuckingCar(Config.Data[k]['vehicleSpawn'])
                if vehnear < 5 then
                    AJFW.Functions.Notify('There is a vehicle at the spot', 'error', 3000)
                else
                    if rented then
                        AJFW.Functions.Notify('You already have a vehicle rented.', 'error') 
                    else
                        AJFW.Functions.SpawnVehicle(model, function(vehicle)
                            SetVehicleNumberPlateText(vehicle, "RENT"..tostring(math.random(1000, 9999)))
                            exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'body', 1000.0)
                            exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'engine', 1000.0)
                            exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'fuel', 100)
                            exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'clutch', 100)
                            exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'brakes', 100)
                            exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'axle', 100)
                            exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'radiator', 100)
                            SetEntityHeading(vehicle, Config.Data[k]['vehicleSpawn'].w)
                            TaskWarpPedIntoVehicle(ped, vehicle, -1)
                            exports['aj-fuel']:SetFuel(vehicle, 100.0)
                            TriggerEvent('vehiclekeys:client:SetOwner', GetVehicleNumberPlateText(vehicle))
                            SetVehicleEngineOn(vehicle, true, true)
                            SetEntityAsMissionEntity(vehicle, true, true)
                            rented = true
                        end, Config.Data[k]['vehicleSpawn'], true)
                        Wait(1000)
                        local vehicle = GetVehiclePedIsIn(ped, false)
                        local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                        vehicleLabel = GetLabelText(vehicleLabel)
                        local plate = GetVehicleNumberPlateText(vehicle)
                        TriggerServerEvent('aj-rental:rentalpapers', plate, vehicleLabel, money)
                        rentedcar = vehicle
                    end
                end
            end
        end
    else
        if dist < 10 then
            local vehnear = AJFW.Functions.CheckFuckingCar(Config.Data[k]['vehicleSpawn'])
            if vehnear < 5 then
                AJFW.Functions.Notify('There is a vehicle at the spot', 'error', 3000)
            else
                if rented then
                    AJFW.Functions.Notify('You already have a vehicle rented.', 'error') 
                else
                    AJFW.Functions.SpawnVehicle(model, function(vehicle)
                        SetVehicleNumberPlateText(vehicle, "RENT"..tostring(math.random(1000, 9999)))
                        exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'body', 1000.0)
                        exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'engine', 1000.0)
                        exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'fuel', 100)
                        exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'clutch', 100)
                        exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'brakes', 100)
                        exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'axle', 100)
                        exports['aj-mechanicjob']:SetVehicleStatus(AJFW.Functions.GetPlate(vehicle), 'radiator', 100)
                        SetEntityHeading(vehicle, Config.Data[k]['vehicleSpawn'].w)
                        TaskWarpPedIntoVehicle(ped, vehicle, -1)
                        exports['aj-fuel']:SetFuel(vehicle, 100.0)
                        TriggerEvent('vehiclekeys:client:SetOwner', GetVehicleNumberPlateText(vehicle))
                        SetVehicleEngineOn(vehicle, true, true)
                        SetEntityAsMissionEntity(vehicle, true, true)
                        rented = true
                    end, Config.Data[k]['vehicleSpawn'], true)
                    Wait(1000)
                    local vehicle = GetVehiclePedIsIn(ped, false)
                    local vehicleLabel = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
                    vehicleLabel = GetLabelText(vehicleLabel)
                    local plate = GetVehicleNumberPlateText(vehicle)
                    TriggerServerEvent('aj-rental:rentalpapers', plate, vehicleLabel, money)
                    rentedcar = vehicle
                end
            end
        end
    end
end)

RegisterNetEvent('aj-rental:return', function(data)
    local key = data.key
    if rented then
        if not IsPedInAnyVehicle(PlayerPedId(), true) then
            AJFW.Functions.TriggerCallback('AJFW:HasItem', function(result)
                if result then
                    local currentcar = AJFW.Functions.GetClosestVehicle()
                    if currentcar then 
                        if currentcar == rentedcar then
                            AJFW.Functions.Notify('Returned vehicle!', 'success')
                            TriggerServerEvent('aj-rental:removepapers')
                            TriggerServerEvent('aj-rentals:server:depositpayout', key)
                            local health = GetVehicleEngineHealth(rentedcar)  ---Health check test.
                            if Config.HealthCheack then
                                TriggerServerEvent('aj-rentals:server:healthcheck', health, key)
                            end
                            NetworkFadeOutEntity(rentedcar, true,false)
                            Citizen.Wait(2000)
                            AJFW.Functions.DeleteVehicle(rentedcar)
                            rented = false
                        else
                            AJFW.Functions.Notify('Please bring the vehicle back in order to return it.', 'error') 
                        end
                    end
                else
                    AJFW.Functions.Notify("You don't have Rental papers..", "error")
                end
            end, "rentalpapers")
        else
            AJFW.Functions.Notify("Get out of vehicle and Submit", "error")
        end
    else 
        AJFW.Functions.Notify('No vehicle to return', 'error')
    end
end)

CreateThread(function()
    RequestModel(GetHashKey('a_m_y_business_03'))
    while not HasModelLoaded(GetHashKey('a_m_y_business_03')) do
        Wait(1)
    end
    for k,v in pairs(Config.Data) do
        local startLoc = CircleZone:Create(Config.Data[k]['location'], 2.0, {
            name='rental',
            debugPoly=false,
            useZ=true, 
        })

        startLoc:onPlayerInOut(function(isPointInside)
            if isPointInside then
                TriggerEvent('aj-rental:openMenu', k)
            else
                exports['aj-menu']:closeMenu()
            end
        end)

        local VehicleRental = AddBlipForCoord(Config.Data[k]['location']) 
        SetBlipSprite (VehicleRental, 56)
        SetBlipDisplay(VehicleRental, 4)
        SetBlipScale  (VehicleRental, 0.5)
        SetBlipAsShortRange(VehicleRental, true)
        SetBlipColour(VehicleRental, 77)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Vehicle Rental")
        EndTextCommandSetBlipName(VehicleRental)

        local created_ped = CreatePed(5, GetHashKey('a_m_y_business_03') , Config.Data[k]['location'], Config.Data[k]['heading'], false, true)
        FreezeEntityPosition(created_ped, true)
        SetEntityInvincible(created_ped, true)
        SetBlockingOfNonTemporaryEvents(created_ped, true)
        TaskStartScenarioInPlace(created_ped, 'WORLD_HUMAN_CLIPBOARD', 0, true)
    end
end)