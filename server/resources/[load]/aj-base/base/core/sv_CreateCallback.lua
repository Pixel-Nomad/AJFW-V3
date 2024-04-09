---@param name string
---@param cb function
function AJFW.Functions.CreateCallback(name, cb)
    AJFW.ServerCallbacks[name] = cb
end