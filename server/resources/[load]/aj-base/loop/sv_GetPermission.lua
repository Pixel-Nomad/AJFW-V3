CreateThread(function() -- Add ace to node for perm checking
    local permissions = AJFW.Config.Server.Permissions
    for i = 1, #permissions do
        local permission = permissions[i]
        ExecuteCommand(('add_ace ajfw.%s %s allow'):format(permission, permission))
    end
end)

CreateThread(function()
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

CreateThread(function()
    local result = MySQL.query.await('SELECT * FROM permissionscommand', {})
    if result[1] then
        for k,v in pairs(result) do
            local table = json.decode(v.commands)
            for l,m in pairs(table) do
                AJFW.Config.Server.PermissionListCommands[v.cid] = {
                    [l] = true
                }
            end
        end
    end
end)