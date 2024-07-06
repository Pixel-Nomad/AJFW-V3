local aaaaa = 'Jobs/Billing'



AJFW.Commands.Add("createbill", "Create a bill to send to another player", {{name="id", help="Player ID"},{name="amount", help="Value of the bill"},{name="reason", help="Reason for the bill"}}, false, function(source, args)
    Player = AJFW.Functions.GetPlayer(source)
    OtherPlayer = AJFW.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        if Player.PlayerData.job.type == "leo" or Config.BillingAccess[Player.PlayerData.job.name] then
            if OtherPlayer then
                name = Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname
                playerId = tonumber(args[1])
                price = tonumber(args[2])
                citizenid = Player.PlayerData.citizenid
                table.remove(args, 1)
                table.remove(args, 1)
                local reason = table.concat(args, " ")
                TriggerClientEvent("billing:client:sendBillingMail", playerId, name, price, reason,citizenid)
            else
                TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player is not online")
            end
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "You are not authorised to this command!")
        end
    end
end)

RegisterNetEvent('billing:server:PayBill')
AddEventHandler('billing:server:PayBill',function(data)
    Player = AJFW.Functions.GetPlayer(source)
    OtherPlayer = AJFW.Functions.GetPlayerByCitizenId(data[2])
    if Player then
       Balance = Player.PlayerData.money["bank"]
       
       if Balance - data[1] >= 0 then
            Player.Functions.RemoveMoney("bank",data[1], "", true)
            local name = ("%s %s"):format(Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname)
            exports['aj-Banking']:handleTransaction(
                Player.PlayerData.citizenid,
                "Personal Account / " .. Player.PlayerData.citizenid, 
                data[1], 
                "paid-bill", 
                Player.PlayerData.citizenid,
                OtherPlayer.PlayerData.citizenid,
                "withdraw"
            )
            if OtherPlayer then
                OtherPlayer.Functions.AddMoney("bank",data[1], "", true)
                exports['aj-Banking']:handleTransaction(
                    OtherPlayer.PlayerData.citizenid,
                    "Personal Account / " .. OtherPlayer.PlayerData.citizenid, 
                    data[1], 
                    "recieved-bill", 
                    OtherPlayer.PlayerData.citizenid,
                    Player.PlayerData.citizenid,
                    "deposit"
                )
                TriggerClientEvent("AJFW:Notify",OtherPlayer.PlayerData.source, "You received $"..data[1].." from "..Player.PlayerData.charinfo.firstname.. " ".. Player.PlayerData.charinfo.lastname , "success")
            end
       end
    end
end)

AJFW.Commands.Add("sendmail", "Create a Mail to send to another player", {{name="id", help="Player ID"},{name="reason", help="Reason for the mail"}}, false, function(source, args)
    Player = AJFW.Functions.GetPlayer(source)
    OtherPlayer = AJFW.Functions.GetPlayer(tonumber(args[1]))
    if Player then
        if OtherPlayer then
            name = Player.PlayerData.charinfo.firstname..""..Player.PlayerData.charinfo.lastname
            playerId = tonumber(args[1])
            citizenid = Player.PlayerData.citizenid
            table.remove(args, 1)
            local reason = table.concat(args, " ")
            TriggerClientEvent("billing:client:sendBillingMail1", playerId, name, reason, citizenid)
        else
            TriggerClientEvent('chatMessage', source, "SYSTEM", "error", "Player is not online")
        end
    end
end)