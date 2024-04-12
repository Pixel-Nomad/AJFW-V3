function AJFW.Player.GetTotalWeight(items)
    if GetResourceState('qb-inventory') == 'missing' then return end
    return exports['aj-inventory']:GetTotalWeight(items)
end