function AJFW.Functions.GetPlayerData(cb)
    if not cb then return AJFW.PlayerData end
    cb(AJFW.PlayerData)
end