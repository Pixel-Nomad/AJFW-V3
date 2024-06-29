-- Functions

local function findVehFromPlateAndLocate(plate)
    local gameVehicles = AJFW.Functions.GetVehicles()
    for i = 1, #gameVehicles do
        local vehicle = gameVehicles[i]
        if DoesEntityExist(vehicle) then
            if AJFW.Functions.GetPlate(vehicle) == plate then
                local vehCoords = GetEntityCoords(vehicle)
                SetNewWaypoint(vehCoords.x, vehCoords.y)
                return true
            end
        end
    end
end

-- NUI Callback

RegisterNUICallback('SetupGarageVehicles', function(_, cb)
    local vehicles = lib.callback.await('aj-phone:server:GetGarageVehicles', false)
    cb(vehicles)
end)

RegisterNUICallback('gps-vehicle-garage', function(data, cb)
    local veh = data.veh
    if Config.Garage == 'jdev' then
        exports['aj-garages']:TrackVehicleByPlate(veh.plate)
        TriggerEvent('aj-phone:client:CustomNotification',
            "GARAGE",
            "GPS Marker Set!",
            "fas fa-car",
            "#e84118",
            5000
        )
        cb("ok")
    elseif Config.Garage == 'AJFW' then
        --Deprecated
        if veh.state == 'In' then
            if veh.parkingspot then
                SetNewWaypoint(veh.parkingspot.x, veh.parkingspot.y)
                AJFW.Functions.Notify("Your vehicle has been marked", "success")
            end
        elseif veh.state == 'Out' and findVehFromPlateAndLocate(veh.plate) then
            AJFW.Functions.Notify("Your vehicle has been marked", "success")
        else
            AJFW.Functions.Notify("This vehicle cannot be located", "error")
        end
        cb("ok")
    end
end)

RegisterNUICallback('sellVehicle', function(data, cb)
    TriggerServerEvent('aj-phone:server:sendVehicleRequest', data)
    cb("ok")
end)

-- Events

RegisterNetEvent('aj-phone:client:sendVehicleRequest', function(data, seller)
    local success = exports['aj-phone']:PhoneNotification("VEHICLE SALE", 'Purchase '..data.plate..' for $'..data.price, 'fas fa-map-pin', '#b3e0f2', "NONE", 'fas fa-check-circle', 'fas fa-times-circle')
    if success then
        TriggerServerEvent("aj-phone:server:sellVehicle", data, seller, 'accepted')
    else
        TriggerServerEvent("aj-phone:server:sellVehicle", data, seller, 'denied')
    end
end)

RegisterNetEvent('aj-phone:client:updateGarages', function()
    SendNUIMessage({
        action = "UpdateGarages",
    })
end)
