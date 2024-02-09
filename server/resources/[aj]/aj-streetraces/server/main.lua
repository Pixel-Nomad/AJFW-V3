local AJFW = exports['aj-base']:GetCoreObject()

local Races = {}

RegisterNetEvent('aj-streetraces:NewRace', function(RaceTable)
    local src = source
    local RaceId = math.random(1000, 9999)
    local xPlayer = AJFW.Functions.GetPlayer(src)
    if xPlayer.Functions.RemoveMoney('cash', RaceTable.amount, 'streetrace-created') then
        Races[RaceId] = RaceTable
        Races[RaceId].creator = src
        Races[RaceId].joined[#Races[RaceId].joined + 1] = src
        TriggerClientEvent('aj-streetraces:SetRace', -1, Races)
        TriggerClientEvent('aj-streetraces:SetRaceId', src, RaceId)
        TriggerClientEvent('AJFW:Notify', src, 'You joined the race for ' .. Config.Currency .. Races[RaceId].amount .. '.', 'success')
        UpdateRaceInfo(Races[RaceId])
    else
        TriggerClientEvent('AJFW:Notify', src, 'You do not have ' .. Config.Currency .. RaceTable.amount .. '.', 'error')
    end
end)

RegisterNetEvent('aj-streetraces:RaceWon', function(RaceId)
    local src = source
    local xPlayer = AJFW.Functions.GetPlayer(src)
    xPlayer.Functions.AddMoney('cash', Races[RaceId].pot, 'race-won')
    TriggerClientEvent('AJFW:Notify', src, 'You won the race and ' .. Config.Currency .. Races[RaceId].pot .. ',- recieved', 'success')
    TriggerClientEvent('aj-streetraces:SetRace', -1, Races)
    TriggerClientEvent('aj-streetraces:RaceDone', -1, RaceId, GetPlayerName(src))
end)

RegisterNetEvent('aj-streetraces:JoinRace', function(RaceId)
    local src = source
    local xPlayer = AJFW.Functions.GetPlayer(src)
    local zPlayer = AJFW.Functions.GetPlayer(Races[RaceId].creator)
    if zPlayer ~= nil then
        if xPlayer.Functions.RemoveMoney('cash', Races[RaceId].amount, 'streetrace-joined') then
            Races[RaceId].pot = Races[RaceId].pot + Races[RaceId].amount
            Races[RaceId].joined[#Races[RaceId].joined + 1] = src
            TriggerClientEvent('aj-streetraces:SetRace', -1, Races)
            TriggerClientEvent('aj-streetraces:SetRaceId', src, RaceId)
            TriggerClientEvent('AJFW:Notify', src, 'You joined the race', 'primary')
            TriggerClientEvent('AJFW:Notify', Races[RaceId].creator, GetPlayerName(src) .. ' Joined the race', 'primary')
            UpdateRaceInfo(Races[RaceId])
        else
            TriggerClientEvent('AJFW:Notify', src, 'You dont have enough cash', 'error')
        end
    else
        TriggerClientEvent('AJFW:Notify', src, 'The person wo made the race is offline!', 'error')
        Races[RaceId] = {}
    end
end)

AJFW.Commands.Add(Config.Commands.CreateRace, 'Start A Street Race', { { name = 'amount', help = 'The Stake Amount For The Race.' } }, false, function(source, args)
    local src = source
    local amount = tonumber(args[1])

    if not amount then return TriggerClientEvent('AJFW:Notify', src, 'Usage: /'..Config.Commands.CreateRace..' [AMOUNT]', 'error') end
    if amount < Config.MinimumStake then
        return TriggerClientEvent('AJFW:Notify', src, 'The minimum stake is '..Config.Currency..Config.MinimumStake, 'error')
    end
    if amount > Config.MaximumStake then
        return TriggerClientEvent('AJFW:Notify', src, 'The maximum stake is '..Config.Currency..Config.MaximumStake, 'error')
    end
    
    
    if GetJoinedRace(src) == 0 then
        TriggerClientEvent('aj-streetraces:CreateRace', src, amount)
    else
        TriggerClientEvent('AJFW:Notify', src, 'You Are Already In A Race', 'error')
    end
end)

AJFW.Commands.Add(Config.Commands.CancelRace, 'Stop The Race You Created', {}, false, function(source, _)
    CancelRace(source)
end)

AJFW.Commands.Add(Config.Commands.QuitRace, 'Leave A Race', {}, false, function(source, _)
    local src = source
    local RaceId = GetJoinedRace(src)
    if RaceId ~= 0 then
        if GetCreatedRace(src) ~= RaceId then
            local xPlayer = AJFW.Functions.GetPlayer(src)
            xPlayer.Functions.AddMoney('cash', Races[RaceId].amount, 'Race Quit')

            Races[RaceId].pot = Races[RaceId].pot - Races[RaceId].amount
            TriggerClientEvent('aj-streetraces:SetRace', -1, Races)
            
            TriggerClientEvent('aj-streetraces:StopRace', src)
            RemoveFromRace(src)
            TriggerClientEvent('AJFW:Notify', src, 'You Have Stepped Out Of The Race!', 'error')
            UpdateRaceInfo(Races[RaceId])
        else
            TriggerClientEvent('AJFW:Notify', src, '/' .. Config.Commands.CancelRace .. ' To Stop The Race', 'error')
        end
    else
        TriggerClientEvent('AJFW:Notify', src, 'You Are Not In A Race ', 'error')
    end
end)

AJFW.Commands.Add(Config.Commands.StartRace, 'Start The Race', {}, false, function(source)
    local src = source
    local RaceId = GetCreatedRace(src)

    if RaceId ~= 0 then
        Races[RaceId].started = true
        TriggerClientEvent('aj-streetraces:SetRace', -1, Races)
        TriggerClientEvent('aj-streetraces:StartRace', -1, RaceId)
    else
        TriggerClientEvent('AJFW:Notify', src, 'You Have Not Started A Race', 'error')
    end
end)

function CancelRace(source)
    local RaceId = GetCreatedRace(source)
    local Player = AJFW.Functions.GetPlayer(source)

    if RaceId ~= 0 then
        for key in pairs(Races) do
            if Races[key] ~= nil and Races[key].creator == source then
                if not Races[key].started then
                    for _, iden in pairs(Races[key].joined) do
                        local xdPlayer = AJFW.Functions.GetPlayer(iden)
                        xdPlayer.Functions.AddMoney('cash', Races[key].amount, 'Race')
                        TriggerClientEvent('AJFW:Notify', xdPlayer.PlayerData.source, 'Race Has Ended, You Got Back ' .. Config.Currency .. Races[key].amount .. '', 'error')
                        TriggerClientEvent('aj-streetraces:StopRace', xdPlayer.PlayerData.source)
                    end
                else
                    TriggerClientEvent('AJFW:Notify', Player.PlayerData.source, 'The Race Has Already Started', 'error')
                end
                TriggerClientEvent('AJFW:Notify', source, 'Race Stopped!', 'error')
                Races[key] = nil
            end
        end
        TriggerClientEvent('aj-streetraces:SetRace', -1, Races)
    else
        TriggerClientEvent('AJFW:Notify', source, 'You Have Not Started A Race!', 'error')
    end
end

function UpdateRaceInfo(race)
    for _, src in pairs(race.joined) do
        TriggerClientEvent('aj-streetraces:UpdateRaceInfo', src, #race.joined, race.pot)
    end
end

function RemoveFromRace(identifier)
    for key in pairs(Races) do
        if Races[key] ~= nil and not Races[key].started then
            for i, iden in pairs(Races[key].joined) do
                if iden == identifier then
                    table.remove(Races[key].joined, i)
                end
            end
        end
    end
end

function GetJoinedRace(identifier)
    for key in pairs(Races) do
        if Races[key] ~= nil and not Races[key].started then
            for _, iden in pairs(Races[key].joined) do
                if iden == identifier then
                    return key
                end
            end
        end
    end
    return 0
end

function GetCreatedRace(identifier)
    for key in pairs(Races) do
        if Races[key] ~= nil and Races[key].creator == identifier and not Races[key].started then
            return key
        end
    end
    return 0
end
