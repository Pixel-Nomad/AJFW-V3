local AJFW = exports['aj-base']:GetCoreObject()

RegisterNetEvent('aj-vineyard:server:getGrapes', function()
    local Player = AJFW.Functions.GetPlayer(source)
    local amount = math.random(Config.GrapeAmount.min, Config.GrapeAmount.max)
    Player.Functions.AddItem("grape", amount)
    TriggerClientEvent('inventory:client:ItemBox', source, AJFW.Shared.Items['grape'], "add")
end)

AJFW.Functions.CreateCallback('aj-vineyard:server:loadIngredients', function(source, cb)
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
    local grape = Player.Functions.GetItemByName('grapejuice')
	if Player.PlayerData.items ~= nil then
        if grape ~= nil then
            if grape.amount >= 23 then
                Player.Functions.RemoveItem("grapejuice", 23, false)
                TriggerClientEvent('inventory:client:ItemBox', source, AJFW.Shared.Items['grapejuice'], "remove")
                cb(true)
            else
                TriggerClientEvent('AJFW:Notify', source, Lang:t("error.invalid_items"), 'error')
                cb(false)
            end
        else
            TriggerClientEvent('AJFW:Notify', source, Lang:t("error.invalid_items"), 'error')
            cb(false)
        end
	else
		TriggerClientEvent('AJFW:Notify', source, Lang:t("error.no_items"), "error")
        cb(false)
	end
end)

AJFW.Functions.CreateCallback('aj-vineyard:server:grapeJuice', function(source, cb)
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
    local grape = Player.Functions.GetItemByName('grape')
	if Player.PlayerData.items ~= nil then
        if grape ~= nil then
            if grape.amount >= 16 then
                Player.Functions.RemoveItem("grape", 16, false)
                TriggerClientEvent('inventory:client:ItemBox', source, AJFW.Shared.Items['grape'], "remove")
                cb(true)
            else
                TriggerClientEvent('AJFW:Notify', source, Lang:t("error.invalid_items"), 'error')
                cb(false)
            end
        else
            TriggerClientEvent('AJFW:Notify', source, Lang:t("error.invalid_items"), 'error')
            cb(false)
        end
	else
		TriggerClientEvent('AJFW:Notify', source, Lang:t("error.no_items"), "error")
        cb(false)
	end
end)

RegisterNetEvent('aj-vineyard:server:receiveWine', function()
	local Player = AJFW.Functions.GetPlayer(tonumber(source))
    local amount = math.random(Config.WineAmount.min, Config.WineAmount.max)
	Player.Functions.AddItem("wine", amount, false)
	TriggerClientEvent('inventory:client:ItemBox', source, AJFW.Shared.Items['wine'], "add")
end)

RegisterNetEvent('aj-vineyard:server:receiveGrapeJuice', function()
	local Player = AJFW.Functions.GetPlayer(tonumber(source))
    local amount = math.random(Config.GrapeJuiceAmount.min, Config.GrapeJuiceAmount.max)
	Player.Functions.AddItem("grapejuice", amount, false)
	TriggerClientEvent('inventory:client:ItemBox', source, AJFW.Shared.Items['grapejuice'], "add")
end)
