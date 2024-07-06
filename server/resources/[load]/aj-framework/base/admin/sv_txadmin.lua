local aaaaa = 'Base/Admin'

 

local txAdmin = {}
txAdmin.Commands = {}
txAdmin.CommandsIndex = {}
txAdmin.Commands.list = {}

local function SplitStr(str, delimiter)
    local result = { }
    local from = 1
    local delim_from, delim_to = string.find(str, delimiter, from)
    while delim_from do
		result[#result+1] = string.sub(str, from, delim_from - 1)
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from)
    end
	result[#result+1] = string.sub(str, from)
    return result
end

function txAdmin.Commands.Add(name, callback)
    txAdmin.CommandsIndex[#txAdmin.CommandsIndex + 1] = name:lower()
    txAdmin.Commands.list[name:lower()] = {
        name = name:lower(),
        callback = callback
    }
end

txAdmin.Commands.Add('txrevive', function(args)
    if args[1] then
        if tostring(args[1]) ~= 'all'  then
            local Player = AJFW.Functions.GetPlayer(tonumber(args[1]))
            if Player then
                Player.Functions.SetMetaData('stress', 0)
                TriggerClientEvent('hud:client:UpdateStress', Player.PlayerData.source, 0)
                TriggerClientEvent('hospital:client:Revive', Player.PlayerData.source)
                print('Revived '..args[1])
            else
                print('Player Not Online!')
            end
        elseif tostring(args[1]) == 'all' then
            local Players = AJFW.Functions.GetPlayers()
            for _,v in pairs(Players) do
                local Player = AJFW.Functions.GetPlayer(tonumber(v))
                if Player then
                    Player.Functions.SetMetaData('stress', 0)
                    TriggerClientEvent('hud:client:UpdateStress', Player.PlayerData.source, 0)
                    TriggerClientEvent('hospital:client:Revive', Player.PlayerData.source)
                    print('Revived '..v)
                end
            end
        end
    else
        print('Enter Player ID or type all')
    end
end)

txAdmin.Commands.Add('txmoney', function(args)
    if args[1] then
        local Player = AJFW.Functions.GetPlayer(tonumber(args[1]))
        if Player then
            if tostring(args[2]) == 'add' or tostring(args[2]) == 'remove' or tostring(args[2]) == 'set' then
                if tostring(args[2]) == 'add' then
                    if tostring(args[3]) == 'cash' or tostring(args[3]) == 'bank' or tostring(args[3]) == 'crypto' then 
                        print(args[4])
                        if tonumber(args[4]) > 0 then
                            Player.Functions.AddMoney(tostring(args[3]), tonumber(args[4]), "", true)
                            if tostring(args[3]) == 'bank' then
                                local name = ("%s %s"):format(Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname)
                                exports['aj-Banking']:handleTransaction(
                                    Player.PlayerData.citizenid,
                                    "Personal Account / " .. Player.PlayerData.citizenid, 
                                    tonumber(args[4]), 
                                    'God-Gifted', 
                                    name, 
                                    Player.PlayerData.citizenid, 
                                    "deposit"
                                )
                            end
                            print('Player ID: '.. args[1])
                            print('Method: '.. args[2])
                            print('Type: '.. args[3])
                            print('Amount: '.. args[4])
                        else
                            print('money must be greater than 0')
                        end
                    else
                        print('cash / bank / crypto. only')
                    end
                elseif tostring(args[2]) == 'remove' then
                    if tostring(args[3]) == 'cash' or tostring(args[3]) == 'bank' or tostring(args[3]) == 'crypto' then 
                        if tonumber(args[4]) > 0 then
                            Player.Functions.RemoveMoney(tostring(args[3]), tonumber(args[4]), "", true)
                            if tostring(args[3]) == 'bank' then
                                local name = ("%s %s"):format(Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname)
                                exports['aj-Banking']:handleTransaction(
                                    Player.PlayerData.citizenid,
                                    "Personal Account / " .. Player.PlayerData.citizenid, 
                                    tonumber(args[4]), 
                                    'Ghost Came and Take Your Money', 
                                    Player.PlayerData.citizenid, 
                                    name, 
                                    "withdraw"
                                )
                            end
                            print('Player ID: '.. args[1])
                            print('Method: '.. args[2])
                            print('Type: '.. args[3])
                            print('Amount: '.. args[4])
                        else
                            print('money must be greater than 0')
                        end
                    else
                        print('cash / bank / crypto')
                    end
                elseif tostring(args[2]) == 'set' then
                    if tostring(args[3]) == 'cash' or tostring(args[3]) == 'bank' or tostring(args[3]) == 'crypto' then 
                        if tonumber(args[4]) > 0 then
                            Player.Functions.SetMoney(tostring(args[3]), tonumber(args[4]))
                            print('Player ID: '.. args[1])
                            print('Method: '.. args[2])
                            print('Type: '.. args[3])
                            print('Amount: '.. args[4])
                        else
                            print('money must be greater than 0')
                        end
                    else
                        print('cash / bank / crypto')
                    end
                end
            else
                print('add / remove / set')
            end
        else
            print('Player Not Online!')
        end
    else
        print('Enter Player ID')
    end
end)

txAdmin.Commands.Add('txjob', function(args)
    if args[1] then
        local Player = AJFW.Functions.GetPlayer(tonumber(args[1]))
        if Player then
            if tostring(args[2]) == 'set' or tostring(args[2]) == 'reset'then
                if tostring(args[2]) == 'set' then
                    if AJFW.Shared.Jobs[tostring(args[3])] then
                        if AJFW.Shared.Jobs[tostring(args[3])].grades[tostring(args[4])] then
                            Player.Functions.SetJob(tostring(args[3]), tonumber(args[4]))
                            print('Player ID: '.. args[1])
                            print('Method: '.. args[2])
                            print('Job: '.. args[3])
                            print('Amount: '.. AJFW.Shared.Jobs[tostring(args[3])].grades[tostring(args[4])].name)
                        else
                            print('Invalid Grade')
                        end
                    else
                        print('Invalid Job')
                    end
                elseif tostring(args[2]) == 'reset' then
                    Player.Functions.SetJob('unemployed', 0)
                    print('Player ID: '.. args[1])
                    print('Method: '.. args[2])
                    print('Job: '.. 'unemployed')
                    print('Amount: '.. AJFW.Shared.Jobs['unemployed'].grades['0'].name)
                end
            else
                print('set or reset only')
            end
        else
            print('Player Not Online!')
        end
    else
        print('Enter Player ID')
    end
end)

txAdmin.Commands.Add('txreloadperms', function(args)
    TriggerEvent('Refresh:permissions')
end)

txAdmin.Commands.Add('getcommandsplz', function(args)
    local tabless = {}
    local a = '[ \n'
    local count = 0
    for k, v in pairs(AJFW.Commands.List) do
        count = count + 1
        print(count)
        a = a .. "   {\n"
        a = a .. "      name: '"..k.."',\n"
        a = a .. "      help: '"..v.help.."',\n"
        if type(v.permission) == 'string' then
            a = a .. "      perms: '"..v.permission.."',\n"
        else
            a = a .. "      perms: 'user',\n"
        end
        if type(v.arguments) == 'table' then
            if #v.arguments > 0 then
                a = a .. "      require: 'YES',\n"
                a = a .. "      args: [{\n"
                for j = 1 , #v.arguments do
                    if v.arguments[j].name then
                        a = a .. "          name:'"..v.arguments[j].name.."',\n"
                        a = a .. "          help:'"..v.arguments[j].help.."',\n"
                    end
                end
                a = a .. "      }]\n"
            else
                a = a .. "      require: 'NO',\n"
                a = a .. "      args: null,\n"
            end
        else
            a = a .. "      require: 'NO',\n"
            a = a .. "      args: null,\n"
        end
        a = a .. "   },"
    end
    a = a .. "]"
    print(a)
end)

for i = 1, #txAdmin.CommandsIndex do
    RegisterCommand(txAdmin.CommandsIndex[i], function(a,b,c)
        if a == 0 then
            local args = SplitStr(c, ' ')
            local command = string.gsub(args[1]:lower(), '/', '')
            if txAdmin.Commands.list[command] then
                txAdmin.Commands.list[command].callback(b)
            end
        end
    end)
end