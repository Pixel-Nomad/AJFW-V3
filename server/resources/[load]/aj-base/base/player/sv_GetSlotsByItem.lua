function AJFW.Player.GetSlotsByItem(items, itemName)
    if GetResourceState('aj-inventory') == 'missing' then return end
    return exports['aj-inventory']:GetSlotsByItem(items, itemName)
end