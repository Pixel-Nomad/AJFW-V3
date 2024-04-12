function AJFW.Player.GetSlotsByItem(items, itemName)
    if GetResourceState('qb-inventory') == 'missing' then return end
    return exports['aj-inventory']:GetSlotsByItem(items, itemName)
end