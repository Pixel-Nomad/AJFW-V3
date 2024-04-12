function AJFW.Player.SaveInventory(source)
    if GetResourceState('qb-inventory') == 'missing' then return end
    exports['aj-inventory']:SaveInventory(source, false)
end