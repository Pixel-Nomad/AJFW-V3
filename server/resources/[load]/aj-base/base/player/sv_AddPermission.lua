---@param source any
---@param permission string
function AJFW.Functions.AddPermission(source, permission)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local plicense = Player.PlayerData.license
    local pCID = Player.PlayerData.citizenid
    if Player then
        AJFW.Config.Server.PermissionList[pCID] = {
            license = plicense,
            cid = pCID,
            permission = permission:lower(),
        }
        MySQL.query.await('DELETE FROM permissions WHERE cid = ?', { pCID })

        MySQL.insert('INSERT INTO permissions (name, license, cid, permission) VALUES (?, ?, ?, ?)', {
            GetPlayerName(src),
            plicense,
            pCID,
            permission:lower()
        })

        Player.Functions.UpdatePlayerData()
        TriggerClientEvent('AJFW:Client:OnPermissionUpdate', src, permission)
    end
end