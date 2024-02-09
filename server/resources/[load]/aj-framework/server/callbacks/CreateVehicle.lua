AJFW.Functions.CreateCallback('AJFW:Server:CreateVehicle', function(source, cb, model, coords, warp)
    local veh = AJFW.Functions.CreateAutomobile(source, model, coords, warp)
    cb(NetworkGetNetworkIdFromEntity(veh))
end)