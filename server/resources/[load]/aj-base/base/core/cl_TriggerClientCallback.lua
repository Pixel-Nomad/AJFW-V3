function AJFW.Functions.TriggerClientCallback(name, cb, ...)
    if not AJFW.ClientCallbacks[name] then return end
    AJFW.ClientCallbacks[name](cb, ...)
end

RegisterNetEvent('AJFW:Client:TriggerClientCallback', function(name, ...)
    AJFW.Functions.TriggerClientCallback(name, function(...)
        TriggerServerEvent('AJFW:Server:TriggerClientCallback', name, ...)
    end, ...)
end)