function CheckCommand(src,Player,command)
    local allowSuggestion = false
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
    if AJFW.Commands.List[command].permission == 'dev' then
        if isDev or isCommand then
            allowSuggestion = true
        end
    elseif AJFW.Commands.List[command].permission == 'owner' then
        if isOwner or isDev or isCommand then
            allowSuggestion = true
        end
    elseif AJFW.Commands.List[command].permission == 'manager' then
        if isManager or isOwner or isDev  or isCommand then
            allowSuggestion = true
        end
    elseif AJFW.Commands.List[command].permission == 'h-admin' then
        if is_h_admin or isManager or isOwner or isDev  or isCommand then
            allowSuggestion = true
        end
    elseif AJFW.Commands.List[command].permission == 'admin' then
        if isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
            allowSuggestion = true
        end
    elseif AJFW.Commands.List[command].permission == 'c-admin' then
        if is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
            allowSuggestion = true
        end
    elseif AJFW.Commands.List[command].permission == 's-mod' then
        if is_s_mod or is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
            allowSuggestion = true
        end
    elseif AJFW.Commands.List[command].permission == 'mod' then
        if isMod or is_s_mod or is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
            allowSuggestion = true
        end
    elseif AJFW.Commands.List[command].permission == isLeo then
        allowSuggestion = true
    elseif AJFW.Commands.List[command].permission == isJob then
        allowSuggestion = true
    elseif AJFW.Commands.List[command].permission == 'user' then
        allowSuggestion = true
    end
    return allowSuggestion
end
