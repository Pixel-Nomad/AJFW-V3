function AJFW.Commands.Refresh(source)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local suggestions = {}
    if Player then
        for command, info in pairs(AJFW.Commands.List) do
            local allowSuggestion = CheckCommand(src, Player, command)
            if allowSuggestion then
                suggestions[#suggestions + 1] = {
                    name = '/' .. command,
                    help = info.help,
                    params = info.arguments
                }
            else
                TriggerClientEvent('chat:removeSuggestion', src, '/'..command)
            end
        end
        TriggerClientEvent('chat:addSuggestions', tonumber(source), suggestions)
    end
end