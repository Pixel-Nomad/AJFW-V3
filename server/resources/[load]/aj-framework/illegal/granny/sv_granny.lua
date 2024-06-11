RegisterNetEvent('aj-grandmas:server:HealSomeShit', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)

    TriggerClientEvent("AJFW:Notify", src, "You Were Billed For $4,000 For Medical Services & Expenses", "Success", 8000)
    local name = ("%s %s"):format(Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname)
    exports['aj-banking']:handleTransaction(
        Player.PlayerData.citizenid,
        "Personal Account / " .. Player.PlayerData.citizenid, 
        4000, 
        'unknown payment', 
        Player.PlayerData.citizenid, 
        name, 
        "withdraw"
    )
end)