local AJFW = exports['aj-base']:GetCoreObject()

RegisterNUICallback('GetAvailableTaxiDrivers', function(_, cb)
    AJFW.Functions.TriggerCallback('aj-phone:server:GetAvailableTaxiDrivers', function(drivers)
        cb(drivers)
    end)
end)