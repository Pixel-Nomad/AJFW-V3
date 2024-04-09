---@param source any
---@return table
function AJFW.Functions.HasPermissionCMD(source, command)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    if Player then
        local pCID = Player.PlayerData.citizenid
        if AJFW.Config.Server.PermissionListCommands[pCID] then
            if AJFW.Config.Server.PermissionListCommands[pCID][command] then
                return true
            end
        end
    end
    return false
end