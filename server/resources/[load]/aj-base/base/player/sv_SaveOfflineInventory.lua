function AJFW.Player.SaveOfflineInventory(PlayerData)
    if GetResourceState('aj-inventory') == 'missing' then return end
    exports['aj-inventory']:SaveInventory(PlayerData, true)
end