function AJFW.Player.GetTotalWeight(items)
    if GetResourceState('aj-inventory') == 'missing' then return end
    return exports['aj-inventory']:GetTotalWeight(items)
end