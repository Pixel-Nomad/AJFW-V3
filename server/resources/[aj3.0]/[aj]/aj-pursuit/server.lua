local AJFW = exports['aj-base']:GetCoreObject()

local Data=  {
    ['NXN01718'] = true
}

AJFW.Commands.Add('allowheat', 'Grant PD Officer Heat Level', {{name='id',help='ID of player'},{name='Allow',help='true or false'}}, false, function(source, args)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    if Player then
        if Data[Player.PlayerData.citizenid] then
            local target = tonumber(args[1])
            local tPlayer = AJFW.Functions.GetPlayer(target)
            if tPlayer then
                if args[2] == 'true' then
                    tPlayer.Functions.SetMetaData('pursuit', true)
                elseif args[2] == 'false' then
                    tPlayer.Functions.SetMetaData('pursuit', false)
                else
                    TriggerClientEvent("AJFW:Notify", src, "only true or false", "error", 5000)
                end
            else
                TriggerClientEvent("AJFW:Notify", src, "Player is not online", "error", 5000)
            end
        else
            TriggerClientEvent("AJFW:Notify", src, "You Don't have enough perms", "error", 5000)
        end
    end
end)