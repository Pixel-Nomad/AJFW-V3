RegisterNetEvent('aj-mugshots:server:triggerSuspect', function(suspect, index)
    TriggerClientEvent('aj-mugshots:client:trigger', suspect, index)
end)