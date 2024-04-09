function HelpCommand(src,Player,command)
    local isDev         = AJFW.Functions.HasPermission(src, 'dev')
    local isOwner       = AJFW.Functions.HasPermission(src, 'owner')
    local isManager     = AJFW.Functions.HasPermission(src, 'manager')
    local is_h_admin    = AJFW.Functions.HasPermission(src, 'h-admin')
    local isAdmin       = AJFW.Functions.HasPermission(src, 'admin')
    local is_c_admin    = AJFW.Functions.HasPermission(src, 'c-admin')
    local is_s_mod      = AJFW.Functions.HasPermission(src, 's-mod')
    local isMod         = AJFW.Functions.HasPermission(src, 'mod')
    local isCommand     = AJFW.Functions.HasPermissionCMD(src, command)
    local isJob         = Player.PlayerData.job.name
    local isLeo         = Player.PlayerData.job.type
    local Templates     = ''
    for k,_ in pairs (AJFW.Commands.List) do
        if AJFW.Commands.List[k].permission == 'dev' then
            if isDev  or isCommand then
                Templates = Templates..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 'owner' then
            if isOwner or isDev  or isCommand then
                Templates = Templates..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 'manager' then
            if isManager or isOwner or isDev  or isCommand then
                Templates = Templates..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 'h-admin' then
            if is_h_admin or isManager or isOwner or isDev  or isCommand then
                Templates = Templates..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 'admin' then
            if isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
                Templates = Templates..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 'c-admin' then
            if is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
                Templates = Templates..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 's-mod' then
            if is_s_mod or is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
                Templates = Templates..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 'mod' then
            if isMod or is_s_mod or is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
                Templates = Templates..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == isJob then
            if AJFW.Commands.List[k].permission == isJob then
                Templates = Templates..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == isLeo then
            if AJFW.Commands.List[k].permission == isLeo then
                Templates = Templates..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 'user' then
            Templates = Templates..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
        end
    end
    Templates = Templates..'Press <strong>[ PageUP ]</strong> and <strong>[ PageDown ]</strong> on your <strong>keyboard</strong> to scroll in chat'
    TriggerClientEvent('chat:addMessage',src, {
        template = "<div class=chat-message server'>"..Templates.."</div>",
        args = {Templates}
    })
end