local AJFW = exports['aj-base']:GetCoreObject()

local Cache = {} 

local CacheExpire = 2

local Player_Cache = {}

RegisterNetEvent('aj-transactions:server:GetPlayerTransactions', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    if Player then
        local cid = Player.PlayerData.citizenid
        if not Cache[cid] then
            Cache[cid] = os.time()
            local time = os.time()
            local data = exports['aj-Banking']:getAccountTransactions(cid)
            local link = exports['aj-transactions']:CreateSheet(cid, time, data)
            if not Player_Cache[cid] then
                Player_Cache[cid] = {}
            end
            Player_Cache[cid][#Player_Cache[cid]+1] = link
            TriggerClientEvent('aj-clipboard', src, link)
            TriggerClientEvent("AJFW:Notify", src, "Link Copied To Clipboard use CTRL + V to paste somewhere", "primary", 7000)
        else
            TriggerClientEvent("AJFW:Notify", src, "Hey! You just got your export check back again", "error", 7000)
        end
    end
end)

RegisterNetEvent('aj-transactions:server:GetAccountTransactions', function(data)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    if Player then
        local cid = Player.PlayerData.citizenid
        if not Cache[data.account] or not Cache[data.account][cid] then
            Cache[data.account] = Cache[data.account] or {}
            Cache[data.account][cid] = os.time()
            local time = os.time()
            local data = exports['aj-Banking']:getAccountTransactions(data.account)
            local link = exports['aj-transactions']:CreateSheet(cid, time, data)
            if not Player_Cache[cid] then
                Player_Cache[cid] = {}
            end
            Player_Cache[cid][#Player_Cache[cid]+1] = link
            TriggerClientEvent('aj-clipboard', src, link)
            TriggerClientEvent("AJFW:Notify", src, "Link Copied To Clipboard use CTRL + V to paste somewhere", "primary", 7000)
        else
            TriggerClientEvent("AJFW:Notify", src, "Hey! You just got your export check back again", "error", 7000)
        end
    end
end)

CreateThread(function()
    while true do
        Wait(5000)
        for k,v in pairs(Cache) do
            if type(Cache[k]) == 'number' then
                local initialTime = Cache[k]
                local currentTime = os.time()
                local elapsedSeconds = os.difftime(currentTime, initialTime)
                local oneHourInSeconds = CacheExpire*60*60
                if elapsedSeconds >= oneHourInSeconds then
                    Cache[k] = nil
                end
            elseif type(Cache[k]) == 'table' then
                for l,m in pairs(Cache[k]) do
                    if type(Cache[k][l]) == 'number' then
                        local initialTime = Cache[k][l]
                        local currentTime = os.time()
                        local elapsedSeconds = os.difftime(currentTime, initialTime)
                        local oneHourInSeconds = CacheExpire*60*60
                        if elapsedSeconds >= oneHourInSeconds then
                            Cache[k][l] = nil
                        end
                    end
                end
            end
        end
    end
end)