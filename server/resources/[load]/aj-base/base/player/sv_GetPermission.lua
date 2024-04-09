---@param source any
---@return table
function AJFW.Functions.GetPermission(source)
    local src = source
    local license = AJFW.Functions.GetIdentifier(src, 'license')
    local Player = AJFW.Functions.GetPlayer(src)
    if license then
        if Player then
            local pCID = Player.PlayerData.citizenid
            if AJFW.Config.Server.PermissionList[pCID] then
                if AJFW.Config.Server.PermissionList[pCID].license == license then
                    if AJFW.Config.Server.PermissionList[pCID].cid == pCID then
                        return AJFW.Config.Server.PermissionList[pCID].permission
                    end
                end
            end
        end
    end
    return 'user'
end
