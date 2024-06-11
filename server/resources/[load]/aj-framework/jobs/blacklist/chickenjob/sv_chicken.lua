local ItemList = {
    ["packagedchicken"] = math.random(200, 250),
}

RegisterNetEvent('aj-chickenjob:startChicken', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    TriggerClientEvent("AJFW:Notify", src, "You Paid $500!", "Success", 8000)
    Player.Functions.RemoveMoney('bank', 500)
    local name = ("%s %s"):format(Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname)
    exports['aj-banking']:handleTransaction(
        Player.PlayerData.citizenid,
        "Personal Account / " .. Player.PlayerData.citizenid, 
        500, 
        'paied chicken job pay', 
        Player.PlayerData.citizenid, 
        name, 
        "withdraw"
    )
end)

RegisterNetEvent('aj-chickenjob:getNewChicken', function(amount)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)

    TriggerClientEvent("AJFW:Notify", src, "You Received 5 Alive chicken!", "Success", 8000)
    Player.Functions.AddItem('alivechicken', amount)
    TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['alivechicken'], "add")
end)

RegisterNetEvent('aj-chickenjob:sell', function()
    local src = source
    local price = 0
    local Player = AJFW.Functions.GetPlayer(src)
    if Player.PlayerData.items and next(Player.PlayerData.items) then 
        for k, v in pairs(Player.PlayerData.items) do 
            if Player.PlayerData.items[k] then 
                if ItemList[Player.PlayerData.items[k].name] then 
                    price = price + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                end
            end
        end
        Player.Functions.AddMoney("cash", price, "sold-items")
        TriggerClientEvent('AJFW:Notify', src, "You have sold your items")
    else
        TriggerClientEvent('AJFW:Notify', src, "You don't have items")
    end
end)

RegisterNetEvent('aj-chickenjob:getcutChicken', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    TriggerClientEvent("AJFW:Notify", src, "Well! You slaughtered chicken.", "Success", 8000)
    Player.Functions.RemoveItem('alivechicken', 1)
    Player.Functions.AddItem('slaughteredchicken', 1)
    TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['alivechicken'], "remove")
    TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['slaughteredchicken'], "add")
end)

RegisterNetEvent('aj-chickenjob:getpackedChicken', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
 
    TriggerClientEvent("AJFW:Notify", src, "You Packed Slaughtered chicken .", "Success", 8000)
    Player.Functions.RemoveItem('slaughteredchicken', 1)
    Player.Functions.AddItem('packagedchicken', 1)
    TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['slaughteredchicken'], "remove")
    TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['packagedchicken'], "add")
end)