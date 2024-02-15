local AJFW = exports['aj-base']:GetCoreObject()

AJFW.Functions.CreateCallback('aj-scoreboard:server:GetScoreboardData', function(_, cb)
    local totalPlayers = 0
    local policeCount = 0
    local players = {}

    for _, v in pairs(AJFW.Functions.GetAJPlayers()) do
        if v then
            totalPlayers += 1

            if v.PlayerData.job.name == "police" and v.PlayerData.job.onduty then
                policeCount += 1
            end

            players[v.PlayerData.source] = {}
            players[v.PlayerData.source].optin = AJFW.Functions.IsOptin(v.PlayerData.source)
        end
    end
    cb(totalPlayers, policeCount, players)
end)

RegisterNetEvent('aj-scoreboard:server:SetActivityBusy', function(activity, bool)
    Config.IllegalActions[activity].busy = bool
    TriggerClientEvent('aj-scoreboard:client:SetActivityBusy', -1, activity, bool)
end)