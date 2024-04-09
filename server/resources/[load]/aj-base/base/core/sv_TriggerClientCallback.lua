---@param name string
---@param source any
---@param cb function
---@param ... any
function AJFW.Functions.TriggerClientCallback(name, source, cb, ...)
    AJFW.ClientCallbacks[name] = cb
    TriggerClientEvent('AJFW:Client:TriggerClientCallback', source, name, ...)
end

RegisterNetEvent('AJFW:Server:TriggerClientCallback', function(name, ...)
    if AJFW.ClientCallbacks[name] then
        AJFW.ClientCallbacks[name](...)
        AJFW.ClientCallbacks[name] = nil
    end
end)