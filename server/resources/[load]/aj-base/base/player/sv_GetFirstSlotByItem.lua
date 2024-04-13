function AJFW.Player.GetFirstSlotByItem(items, itemName)
    if GetResourceState('aj-inventory') == 'missing' then return end
    return exports['aj-inventory']:GetFirstSlotByItem(items, itemName)
end