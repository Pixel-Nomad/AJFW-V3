---@param citizenid string
---@return table?
function AJFW.Functions.GetPlayerByCitizenId(citizenid)
    for src in pairs(AJFW.Players) do
        if AJFW.Players[src].PlayerData.citizenid == citizenid then
            return AJFW.Players[src]
        end
    end
    return nil
end