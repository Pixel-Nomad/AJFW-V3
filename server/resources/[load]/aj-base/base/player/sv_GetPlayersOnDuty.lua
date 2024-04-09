---@param job string
---@return table, number
function AJFW.Functions.GetPlayersOnDuty(job)
    local players = {}
    local count = 0
    for src, Player in pairs(AJFW.Players) do
        if Player.PlayerData.job.name == job then
            if Player.PlayerData.job.onduty then
                players[#players + 1] = src
                count += 1
            end
        end
    end
    return players, count
end