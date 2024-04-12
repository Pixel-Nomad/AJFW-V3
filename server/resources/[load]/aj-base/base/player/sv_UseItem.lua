---@param source any
---@param item string
function AJFW.Functions.UseItem(source, item)
    if GetResourceState('qb-inventory') == 'missing' then return end
    exports['aj-inventory']:UseItem(source, item)
end