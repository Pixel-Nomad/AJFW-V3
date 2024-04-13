---@param source any
---@param item string
function AJFW.Functions.UseItem(source, item)
    if GetResourceState('aj-inventory') == 'missing' then return end
    exports['aj-inventory']:UseItem(source, item)
end