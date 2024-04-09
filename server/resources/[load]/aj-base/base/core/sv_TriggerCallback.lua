---@param name string
---@param source any
---@param cb function
---@param ... any
function AJFW.Functions.TriggerCallback(name, source, cb, ...)
    if not AJFW.ServerCallbacks[name] then return end
    AJFW.ServerCallbacks[name](source, cb, ...)
end

RegisterNetEvent('AJFW:Server:TriggerCallback', function(name, ...)
    local src = source
    AJFW.Functions.TriggerCallback(name, src, function(...)
        TriggerClientEvent('AJFW:Client:TriggerCallback', src, name, ...)
    end, ...)
end)