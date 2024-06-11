AJFW.Functions.CreateCallback('aj-moneywash:server:checkWash', function(source, cb)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local blackmoney = Player.Functions.GetItemByName("blackmoney")
    local tamount = 0
    for i = 1, #Player.PlayerData.items do
        if Player.PlayerData.items[i] then 
            if Player.PlayerData.items[i].name == "blackmoney" then 
                tamount = Player.PlayerData.items[i].amount
            end
        end
    end
    if blackmoney then cb(tamount) else cb(nil) end
end)

RegisterNetEvent("aj-moneywash:server:checkInv", function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = Player.Functions.GetItemByName('blackmoney')
    if item then
        local amt = item.amount
        TriggerClientEvent('aj-moneywash:client:startTimer', src, amt)
        TriggerClientEvent('AJFW:Notify', src, 'You put the black money in the washer.', 'success')
        Player.Functions.RemoveItem('blackmoney', amt)
    else
        TriggerClientEvent('AJFW:Notify', src, 'You have no black money.', 'error') 
    end
end)


RegisterNetEvent("aj-moneywash:server:giveMoney", function(amt)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    Player.Functions.AddMoney("cash", amt)
	TriggerClientEvent('AJFW:Notify', src, "You have received your white money with 20% deduction fee of washing")
end)


AJFW.Functions.CreateUseableItem("blackkey", function(source, item)
    local Player = AJFW.Functions.GetPlayer(source)
    TriggerClientEvent("JcaobMoneyWash", source)
end)