function AJFW.Functions.TriggerCallback(name, cb, ...)
    AJFW.ServerCallbacks[name] = cb
    TriggerServerEvent('AJFW:Server:TriggerCallback', name, ...)
end

RegisterNetEvent('AJFW:Client:TriggerCallback', function(name, ...)
    if AJFW.ServerCallbacks[name] then
        AJFW.ServerCallbacks[name](...)
        AJFW.ServerCallbacks[name] = nil
    end
end)