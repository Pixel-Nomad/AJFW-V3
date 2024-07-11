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
    local Templates     = {
        ['dev'] = "",
        ['owner'] = "",
        ['manager'] = "",
        ['h-admin'] = "",
        ['admin'] = "",
        ['c-admin'] = "",
        ['s-mod'] = "",
        ['mod'] = "",
        ['job'] = "",
        ['leo'] = "",
        ['user'] = "",
    }
    for k,_ in pairs (AJFW.Commands.List) do
        if AJFW.Commands.List[k].permission == 'dev' then
            if isDev  or isCommand then
                Templates['dev'] = Templates['dev']..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 'owner' then
            if isOwner or isDev  or isCommand then
                Templates['owner'] = Templates['owner']..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 'manager' then
            if isManager or isOwner or isDev  or isCommand then
                Templates['manager'] = Templates['manager']..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 'h-admin' then
            if is_h_admin or isManager or isOwner or isDev  or isCommand then
                Templates['h-admin'] = Templates['h-admin']..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 'admin' then
            if isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
                Templates['admin'] = Templates['admin']..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 'c-admin' then
            if is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
                Templates['c-admin'] = Templates['c-admin']..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 's-mod' then
            if is_s_mod or is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
                Templates['s-mod'] = Templates['s-mod']..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 'mod' then
            if isMod or is_s_mod or is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
                Templates['mod'] = Templates['mod']..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == isJob then
            if AJFW.Commands.List[k].permission == isJob then
                Templates['job'] = Templates['job']..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == isLeo then
            if AJFW.Commands.List[k].permission == isLeo then
                Templates['leo'] = Templates['leo']..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 'user' then
            Templates['user'] = Templates['user']..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
        end
    end
    local final_Template = ''
    if Templates['dev'] ~= '' then
        final_Template = final_Template.."========= DEV =========<br><br>"
        final_Template = final_Template..Templates['dev']..'<br><br>'
    end
    if Templates['owner'] ~= '' then
        final_Template = final_Template.."========= OWNER =========<br><br>"
        final_Template = final_Template..Templates['owner']..'<br><br>'
    end
    if Templates['manager'] ~= '' then
        final_Template = final_Template.."========= MANAGER =========<br><br>"
        final_Template = final_Template..Templates['manager']..'<br><br>'
    end
    if Templates['h-admin'] ~= '' then
        final_Template = final_Template.."========= H-ADMIN =========<br><br>"
        final_Template = final_Template..Templates['h-admin']..'<br><br>'
    end
    if Templates['admin'] ~= '' then
        final_Template = final_Template.."========= ADMIN =========<br><br>"
        final_Template = final_Template..Templates['admin']..'<br><br>'
    end
    if Templates['c-admin'] ~= '' then
        final_Template = final_Template.."========= C-ADMIN =========<br><br>"
        final_Template = final_Template..Templates['c-admin']..'<br><br>'
    end
    if Templates['s-mod'] ~= '' then
        final_Template = final_Template.."========= S-MOD =========<br><br>"
        final_Template = final_Template..Templates['s-mod']..'<br><br>'
    end
    if Templates['mod'] ~= '' then
        final_Template = final_Template.."========= MOD =========<br><br>"
        final_Template = final_Template..Templates['mod']..'<br><br>'
    end
    if Templates['job'] ~= '' then
        final_Template = final_Template.."========= JOB =========<br><br>"
        final_Template = final_Template..Templates['job']..'<br><br>'
    end
    if Templates['leo'] ~= '' then
        final_Template = final_Template.."========= LEO =========<br><br>"
        final_Template = final_Template..Templates['leo']..'<br><br>'
    end
    if Templates['user'] ~= '' then
        final_Template = final_Template.."========= USER =========<br><br>"
        final_Template = final_Template..Templates['user']..'<br><br>'
    end
    final_Template = final_Template..'Press <strong>[ PageUP ]</strong> and <strong>[ PageDown ]</strong> on your <strong>keyboard</strong> to scroll in chat'
    TriggerClientEvent('chat:addMessage',src, {
        template = "<div class=chat-message server'>"..final_Template.."</div>",
        args = {final_Template}
    })
end