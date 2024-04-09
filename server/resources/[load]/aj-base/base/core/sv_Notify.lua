---@param source any
---@param text string
---@param type string
---@param length number
function AJFW.Functions.Notify(source, text, type, length)
    TriggerClientEvent('AJFW:Notify', source, text, type, length)
end