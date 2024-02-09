local aaaaa = 'Player/onToggleDuty'


RegisterNetEvent('AJFW:ToggleDuty', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    if Player.PlayerData.job.onduty then
        Player.Functions.SetJobDuty(false)
        TriggerClientEvent('AJFW:Notify', src, 'You are now off duty!')
    else
        Player.Functions.SetJobDuty(true)
        TriggerClientEvent('AJFW:Notify', src, 'You are now on duty!')
    end
    TriggerEvent('AJFW:Server:SetDuty', src, Player.PlayerData.job.onduty)
    TriggerClientEvent('AJFW:Client:SetDuty', src, Player.PlayerData.job.onduty)
end)