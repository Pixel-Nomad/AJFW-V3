RegisterNetEvent('AJFW:Server:OpenServer', function()
    local src = source
    if AJFW.Functions.HasPermission(src, 'admin') then
        AJFW.Config.Server.Closed = false
    else
        AJFW.Functions.Kick(src, Lang:t('error.no_permission'), nil, nil)
    end
end)

