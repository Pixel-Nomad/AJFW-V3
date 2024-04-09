RegisterNetEvent('Refresh:permissions',function()
    local result = MySQL.query.await('SELECT * FROM permissions', {})
    if result[1] then
        for k, v in pairs(result) do
            AJFW.Config.Server.PermissionList[v.cid] = {
                license = v.license,
                cid = v.cid,
                permission = v.permission,
                optin = true,
            }
        end
    end
end)

RegisterNetEvent('Refresh:permissions',function()
    local result = MySQL.query.await('SELECT * FROM permissionscommand', {})
    if result[1] then
        for k,v in pairs(result) do
            for l,m in pairs(v.commands) do
                AJFW.Config.Server.PermissionListCommands[v.cid] = {
                    [l] = true
                }
            end
        end
    end
end)