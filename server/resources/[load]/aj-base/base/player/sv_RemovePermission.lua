---@param source any
---@param permission string
function AJFW.Functions.RemovePermission(source, permission)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local license = Player.PlayerData.license
    local pCID = Player.PlayerData.citizenid
    if Player then
        AJFW.Config.Server.PermissionList[pCID] = nil
        MySQL.query('DELETE FROM permissions WHERE cid = ?', { pCID })
        Player.Functions.UpdatePlayerData()
    end
end