function CallCommands(src,Player,command,args)
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
        if isDev  or isCommand then
            if (AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and args[#AJFW.Commands.List[command].arguments] == nil) then
                TriggerClientEvent('AJFW:Notify', src, 'All arguments must be filled out!', 'error')
            else
                AJFW.Commands.List[command].callback(src, args)
            end
        else
            TriggerClientEvent('AJFW:Notify', src, 'No Access To This Command', 'error')
        end
    elseif AJFW.Commands.List[command].permission == 'owner' then
        if isOwner or isDev  or isCommand then
            if (AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and args[#AJFW.Commands.List[command].arguments] == nil) then
                TriggerClientEvent('AJFW:Notify', src, 'All arguments must be filled out!', 'error')
            else
                AJFW.Commands.List[command].callback(src, args)
            end
        else
            TriggerClientEvent('AJFW:Notify', src, 'No Access To This Command', 'error')
        end
    elseif AJFW.Commands.List[command].permission == 'manager' then
        if isManager or isOwner or isDev  or isCommand then
            if (AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and args[#AJFW.Commands.List[command].arguments] == nil) then
                TriggerClientEvent('AJFW:Notify', src, 'All arguments must be filled out!', 'error')
            else
                AJFW.Commands.List[command].callback(src, args)
            end
        else
            TriggerClientEvent('AJFW:Notify', src, 'No Access To This Command', 'error')
        end
    elseif AJFW.Commands.List[command].permission == 'h-admin' then
        if is_h_admin or isManager or isOwner or isDev  or isCommand then
            if (AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and args[#AJFW.Commands.List[command].arguments] == nil) then
                TriggerClientEvent('AJFW:Notify', src, 'All arguments must be filled out!', 'error')
            else
                AJFW.Commands.List[command].callback(src, args)
            end
        else
            TriggerClientEvent('AJFW:Notify', src, 'No Access To This Command', 'error')
        end
    elseif AJFW.Commands.List[command].permission == 'admin' then
        if isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
            if (AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and args[#AJFW.Commands.List[command].arguments] == nil) then
                TriggerClientEvent('AJFW:Notify', src, 'All arguments must be filled out!', 'error')
            else
                AJFW.Commands.List[command].callback(src, args)
            end
        else
            TriggerClientEvent('AJFW:Notify', src, 'No Access To This Command', 'error')
        end
    elseif AJFW.Commands.List[command].permission == 'c-admin' then
        if is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev  then
            if (AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and args[#AJFW.Commands.List[command].arguments] == nil) then
                TriggerClientEvent('AJFW:Notify', src, 'All arguments must be filled out!', 'error')
            else
                AJFW.Commands.List[command].callback(src, args)
            end
        else
            TriggerClientEvent('AJFW:Notify', src, 'No Access To This Command', 'error')
        end
    elseif AJFW.Commands.List[command].permission == 's-mod' then
        if is_s_mod or is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
            if (AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and args[#AJFW.Commands.List[command].arguments] == nil) then
                TriggerClientEvent('AJFW:Notify', src, 'All arguments must be filled out!', 'error')
            else
                AJFW.Commands.List[command].callback(src, args)
            end
        else
            TriggerClientEvent('AJFW:Notify', src, 'No Access To This Command', 'error')
        end
    elseif AJFW.Commands.List[command].permission == 'mod' then
        if isMod or is_s_mod or is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
            if (AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and args[#AJFW.Commands.List[command].arguments] == nil) then
                TriggerClientEvent('AJFW:Notify', src, 'All arguments must be filled out!', 'error')
            else
                AJFW.Commands.List[command].callback(src, args)
            end
        else
            TriggerClientEvent('AJFW:Notify', src, 'No Access To This Command', 'error')
        end
    elseif AJFW.Commands.List[command].permission == isLeo then
        if AJFW.Commands.List[command].permission == isLeo then
            if (AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and args[#AJFW.Commands.List[command].arguments] == nil) then
                TriggerClientEvent('AJFW:Notify', src, 'All arguments must be filled out!', 'error')
            else
                AJFW.Commands.List[command].callback(src, args)
            end
        else
            TriggerClientEvent('AJFW:Notify', src, 'No Access To This Command', 'error')
        end
    elseif AJFW.Commands.List[command].permission == isJob then
        if AJFW.Commands.List[command].permission == isJob then
            if (AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and args[#AJFW.Commands.List[command].arguments] == nil) then
                TriggerClientEvent('AJFW:Notify', src, 'All arguments must be filled out!', 'error')
            else
                AJFW.Commands.List[command].callback(src, args)
            end
        else
            TriggerClientEvent('AJFW:Notify', src, 'No Access To This Command', 'error')
        end
    elseif AJFW.Commands.List[command].permission == 'user' then
        if (AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and args[#AJFW.Commands.List[command].arguments] == nil) then
            TriggerClientEvent('AJFW:Notify', src, 'All arguments must be filled out!', 'error')
        else
            AJFW.Commands.List[command].callback(src, args)
        end
    end
end

RegisterNetEvent('AJFW:CallCommand', function(command, args)
    local src = source
    if AJFW.Commands.List[command] then
        local Player = AJFW.Functions.GetPlayer(src)
        if Player then
            CallCommands(src,Player,command,args)
        end
    end
end)