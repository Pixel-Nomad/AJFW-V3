---@param citizenid string
---@return table?
function AJFW.Functions.GetOfflinePlayerByCitizenId(citizenid)
    return AJFW.Player.GetOfflinePlayer(citizenid)
end