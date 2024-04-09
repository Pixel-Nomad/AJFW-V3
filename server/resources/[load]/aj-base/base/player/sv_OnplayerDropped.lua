AddEventHandler('playerDropped', function(reason)
    local src = source
    if not AJFW.Players[src] then return end
    local Player = AJFW.Players[src]
    TriggerEvent('aj-log:server:CreateLog', 'joinleave', 'Dropped', 'red', '**' .. GetPlayerName(src) .. '** (' .. Player.PlayerData.license .. ') left..' .. '\n **Reason:** ' .. reason)
    Player.Functions.Save()
    AJFW.Player_Buckets[Player.PlayerData.license] = nil
    AJFW.Players[src] = nil
end)