function AJFW.Functions.GetLeoDutyCount(array, single)
    local count = 0
    if single then
        for _, Player in pairs(AJFW.Players) do
            if Player.PlayerData.job.name == array then
                if Player.PlayerData.job.onduty then
                    count = count + 1
                end
            end
        end
    else
        for i = 1, #array do
            for _, Player in pairs(AJFW.Players) do
                if Player.PlayerData.job.name == array[i] then
                    if Player.PlayerData.job.onduty then
                        count = count + 1
                    end
                end
            end
        end
    end
    return count
end