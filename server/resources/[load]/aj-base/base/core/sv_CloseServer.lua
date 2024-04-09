RegisterNetEvent('AJFW:Server:CloseServer', function(reason)
    local src = source
    if AJFW.Functions.HasPermission(src, 'admin') then
        reason = reason or 'No reason specified'
        AJFW.Config.Server.Closed = true
        AJFW.Config.Server.ClosedReason = reason
        for k in pairs(AJFW.Players) do
            if not AJFW.Functions.HasPermission(k, AJFW.Config.Server.WhitelistPermission) then
                AJFW.Functions.Kick(k, reason, nil, nil)
            end
        end
    else
        AJFW.Functions.Kick(src, Lang:t('error.no_permission'), nil, nil)
    end
end)