AJFW.Functions.CreateCallback('AJFW:Server:SpawnVehicle', function(source, cb, model, coords, warp)
    local veh = AJFW.Functions.SpawnVehicle(source, model, coords, warp)
    cb(NetworkGetNetworkIdFromEntity(veh))
end)