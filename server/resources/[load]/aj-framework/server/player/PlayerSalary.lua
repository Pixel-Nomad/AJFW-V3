local aaaaa = 'Player/PlayerSalary'


RegisterNetEvent('AJFW:Player:UpdatePlayerPayment', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local payment = Player.PlayerData.job.payment
    if Player.PlayerData.job and Player.PlayerData.job.payment > 0 then
        if AJFW.Config.Money.OnlyPayWhenDuty then
            if Player.PlayerData.job.onduty then
                Player.Functions.AddMoney('bank', payment)
                -- local salary = MySQL.prepare.await('SELECT salary FROM players WHERE citizenid = ?',{Player.PlayerData.citizenid})
                -- local final = salary + payment
                -- MySQL.query('UPDATE players SET salary = ? WHERE citizenid = ?',{final, Player.PlayerData.citizenid})
                -- Player.Functions.AddMoney('bank', payment)
                TriggerClientEvent('AJFW:Notify', Player.PlayerData.source, 'Salary Received')
            else
                local aa = payment / 100
                local bb = aa * AJFW.Config.Money.Percent
                Player.Functions.AddMoney('bank', bb)
                -- local salary = MySQL.prepare.await('SELECT salary FROM players WHERE citizenid = ?',{Player.PlayerData.citizenid})
                -- local final = salary + bb
                -- Player.Functions.AddMoney('bank', payment)
                -- MySQL.query('UPDATE players SET salary = ? WHERE citizenid = ?',{final, Player.PlayerData.citizenid})
                TriggerClientEvent('AJFW:Notify', Player.PlayerData.source, 'Salary Received')
            end
        else
            Player.Functions.AddMoney('bank', payment)
            TriggerClientEvent('AJFW:Notify', Player.PlayerData.source, 'Salary Received collect it from Life Invader')
        end
    end
end)