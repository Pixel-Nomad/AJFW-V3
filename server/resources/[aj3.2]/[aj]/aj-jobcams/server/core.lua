Core = nil
CoreName = nil
CoreReady = false
Citizen.CreateThread(function()
    for k, v in pairs(Cores) do
        if GetResourceState(v.ResourceName) == "starting" or GetResourceState(v.ResourceName) == "started" then
            CoreName = v.ResourceName
            Core = v.GetFramework()
            CoreReady = true
        end
    end
end)

function GetPlayer(source)
    if CoreName == "aj-base" or CoreName == "ajx_core" then
        local player = Core.Functions.GetPlayer(source)
        return player
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(source)
        return player
    end
end

function GetPlayerJob(source)
    local src = tonumber(source)
    if CoreName == "aj-base" or CoreName == "ajx_core" then
        local player = Core.Functions.GetPlayer(src)
        if player then
            return player.PlayerData.job
        else
            return false
        end
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(src)
        if player then
            return player.job
        else
            return false
        end
    end
end

function GetPlayerLicense(source)
    local src = tonumber(source)
    if CoreName == "aj-base" or CoreName == "ajx_core" then
        local player = Core.Functions.GetPlayer(src)
        return player.PlayerData.citizenid
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(src)
        return player.getIdentifier()
    end
end

function GetCharName(source, charName)
    local src = tonumber(source)
    if charName then
        if CoreName == "aj-base" or CoreName == "ajx_core" then
            local player = Core.Functions.GetPlayer(src)
            return player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
        elseif CoreName == "es_extended" then
            local player = Core.GetPlayerFromId(src)
            return player.getName()
        end
    else
        return GetPlayerName(src)
    end
end

function Notify(source, text, length, type)
    local src = tonumber(source)
    if CoreName == "aj-base" or CoreName == "ajx_core" then
        Core.Functions.Notify(src, text, type, length)
    elseif CoreName == "es_extended" then
        local player = Core.GetPlayerFromId(src)
        player.showNotification(text)
    end
end

function HasItem(source)
    local src = tonumber(source)
    if Config.BodycamItem.Enable then
        if CoreName == "aj-base" or CoreName == "ajx_core" then
            -- OX Inventory
            local hasOX = GetResourceState('ox_inventory') == 'started'
            if hasOX then
                if exports["ox_inventory"]:GetItem(src, Config.BodycamItem.ItemName, nil, false) then
                    return true
                end
            end
            -- QS Inventory
            local hasQs = GetResourceState('qs-inventory') == 'started'
            if hasQs then
                local items = exports['qs-inventory']:GetInventory(src)
                for item, data in pairs(items) do
                    if item == Config.BodycamItem.ItemName then
                        return true
                    end
                end
            end
            -- aj Inventory
            local ajPlayer = Core.Functions.GetPlayer(src)
            for _, item in pairs(ajPlayer.PlayerData.items) do
                if item.name == Config.BodycamItem.ItemName then
                    return true
                end
            end
            return false
        elseif CoreName == "es_extended" then
            -- OX Inventory
            local hasOX = GetResourceState('ox_inventory') == 'started'
            if hasOX then
                if exports["ox_inventory"]:GetItem(src, Config.BodycamItem.ItemName, nil, false) then
                    return true
                end
            end
            -- QS Inventory
            local hasQs = GetResourceState('qs-inventory') == 'started'
            if hasQs then
                local items = exports['qs-inventory']:GetInventory(src)
                for item, data in pairs(items) do
                    if item == Config.BodycamItem.ItemName then
                        return true
  
                    end
                end
            end
            -- ESX Inventory
            local hasItem = Core.SearchInventory(Config.BodycamItem.ItemName, 1) >= 1
            if hasItem then
                return true
            end
            return false
        end
    else
        return true
    end
end

Config.ServerCallbacks = {}
function CreateCallback(name, cb)
    Config.ServerCallbacks[name] = cb
end

function TriggerCallback(name, source, cb, ...)
    if not Config.ServerCallbacks[name] then return end
    Config.ServerCallbacks[name](source, cb, ...)
end

RegisterNetEvent('ac-jobcams:server:triggerCallback', function(name, ...)
    local src = source
    TriggerCallback(name, src, function(...)
        TriggerClientEvent('ac-jobcams:client:triggerCallback', src, name, ...)
    end, ...)
end)