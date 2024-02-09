-- Vehicles
RegisterServerEvent('aj-framework:enteringVehicle', function(veh,seat,modelName,netid)
    local src = source
    local data = {
        vehicle = veh,
        seat = seat,
        name = modelName,
        netid = netid,
        event = 'Entering'
    }
    TriggerClientEvent('AJFW:Client:VehicleInfo', src, data)
end)

RegisterServerEvent('aj-framework:enteredVehicle', function(veh,seat,modelName,netid)
    local src = source
    local data = {
        vehicle = veh,
        seat = seat,
        name = modelName,
        netid = netid,
        event = 'Entered'
    }
    TriggerClientEvent('AJFW:Client:VehicleInfo', src, data)
end)

RegisterServerEvent('aj-framework:enteringAborted', function()
    local src = source
    TriggerClientEvent('AJFW:Client:AbortVehicleEntering', src)
end)

RegisterServerEvent('aj-framework:leftVehicle', function(veh,seat,modelName,netid)
    local src = source
    local data = {
        vehicle = veh,
        seat = seat,
        name = modelName,
        netid = netid,
        event = 'Left'
    }
    TriggerClientEvent('AJFW:Client:VehicleInfo', src, data)
end)