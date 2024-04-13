function AJFW.Player.SaveInventory(source)
    if GetResourceState('aj-inventory') == 'missing' then return end
    exports['aj-inventory']:SaveInventory(source, false)
end