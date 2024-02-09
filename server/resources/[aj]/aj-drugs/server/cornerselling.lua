local StolenDrugs = {}

local function getAvailableDrugs(source)
    local AvailableDrugs = {}
    local Player = AJFW.Functions.GetPlayer(source)

    if not Player then return nil end

    for k in pairs(Config.DrugsPrice) do
        local item = Player.Functions.GetItemByName(k)

        if item then
            AvailableDrugs[#AvailableDrugs + 1] = {
                item = item.name,
                amount = item.amount,
                label = AJFW.Shared.Items[item.name]['label']
            }
        end
    end
    return table.type(AvailableDrugs) ~= 'empty' and AvailableDrugs or nil
end

AJFW.Functions.CreateCallback('aj-drugs:server:cornerselling:getAvailableDrugs', function(source, cb)
    cb(getAvailableDrugs(source))
end)

RegisterNetEvent('aj-drugs:server:giveStealItems', function(drugType, amount)
    local Player = AJFW.Functions.GetPlayer(source)

    if not Player or StolenDrugs == {} then return end

    for k, v in pairs(StolenDrugs) do
        if drugType == v.item and amount == v.amount then
            Player.Functions.AddItem(drugType, amount)
            table.remove(StolenDrugs, k)
        end
    end
end)

RegisterNetEvent('aj-drugs:server:sellCornerDrugs', function(drugType, amount, price)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local availableDrugs = getAvailableDrugs(src)

    if not availableDrugs or not Player then return end

    local item = availableDrugs[drugType].item

    local hasItem = Player.Functions.GetItemByName(item)
    if hasItem.amount >= amount then
        TriggerClientEvent('AJFW:Notify', src, Lang:t('success.offer_accepted'), 'success')
        Player.Functions.RemoveItem(item, amount)
        Player.Functions.AddMoney('cash', price, 'sold-cornerdrugs')
        TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[item], 'remove')
        TriggerClientEvent('aj-drugs:client:refreshAvailableDrugs', src, getAvailableDrugs(src))
    else
        TriggerClientEvent('aj-drugs:client:cornerselling', src)
    end
end)

RegisterNetEvent('aj-drugs:server:robCornerDrugs', function(drugType, amount)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local availableDrugs = getAvailableDrugs(src)

    if not availableDrugs or not Player then return end

    local item = availableDrugs[drugType].item

    Player.Functions.RemoveItem(item, amount)
    table.insert(StolenDrugs, { item = item, amount = amount })
    TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[item], 'remove')
    TriggerClientEvent('aj-drugs:client:refreshAvailableDrugs', src, getAvailableDrugs(src))
end)
