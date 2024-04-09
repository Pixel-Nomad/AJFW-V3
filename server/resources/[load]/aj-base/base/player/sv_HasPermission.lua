---@param source any
---@param permission string
---@return boolean
function AJFW.Functions.HasPermission(source, permission)
    local src = source
    local license = AJFW.Functions.GetIdentifier(src, 'license')
    local Player = AJFW.Functions.GetPlayer(src)
    local permission = tostring(permission:lower())
    if permission == 'user' then
        return true
    else
        if Player then
            local pCID = Player.PlayerData.citizenid
            if AJFW.Config.Server.PermissionList[pCID] then
                if AJFW.Config.Server.PermissionList[pCID].license == license then
                    if AJFW.Config.Server.PermissionList[pCID].cid == pCID then
                        if AJFW.Config.Server.PermissionList[pCID].permission == permission or AJFW.Config.Server.PermissionList[pCID].permission == 'dev' then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end
