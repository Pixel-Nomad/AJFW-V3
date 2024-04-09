---@param job any
---@return number
function AJFW.Functions.GetDutyCount(job)
    local count = 0
    for _, Player in pairs(AJFW.Players) do
        if Player.PlayerData.job.name == job then
            if Player.PlayerData.job.onduty then
                count += 1
            end
        end
    end
    return count
end