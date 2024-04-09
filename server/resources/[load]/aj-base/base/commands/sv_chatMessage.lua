AddEventHandler('chatMessage', function(_, _, message)
    if string.sub(message, 1, 1) == '/' then
        CancelEvent()
        return
    end
end)

AddEventHandler('chatMessage', function(source, n, message)
    local src = source
    if string.sub(message, 1, 1) == '/' then
        local args = AJFW.Shared.SplitStr(message, ' ')
        local command = string.gsub(args[1]:lower(), '/', '')
        CancelEvent()
        if AJFW.Commands.List[command] then
            local Player = AJFW.Functions.GetPlayer(src)
            if Player then
                table.remove(args, 1)
                CallCommands(src,Player,command,args)
            end
        elseif command == 'help' or command == 'HELP' then
            local Player = AJFW.Functions.GetPlayer(src)
            if Player then
                HelpCommand(src,Player,command)
            end
        end
    end
end)