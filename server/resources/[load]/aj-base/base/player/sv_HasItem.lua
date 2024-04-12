---@param source any
---@param items table|string
---@param amount number
---@return boolean
function AJFW.Functions.HasItem(source, items, amount)
    if GetResourceState('qb-inventory') == 'missing' then return end
    return exports['aj-inventory']:HasItem(source, items, amount)
end