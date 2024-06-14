local AJFW = exports['aj-base']:GetCoreObject()

-- Eventos

RegisterNetEvent('aj-farm:server:ComprarFertilizante', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_fertilizante'
    local dinheiro = 'bank'
    local quantidade = 1
    local preco = 10

    Player.Functions.RemoveMoney(dinheiro, preco)
    Player.Functions.AddItem(item, quantidade)
end)

RegisterNetEvent('aj-farm:server:ComprarPa', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_pa'
    local dinheiro = 'bank'
    local quantidade = 1
    local preco = 50

    Player.Functions.RemoveMoney(dinheiro, preco)
    Player.Functions.AddItem(item, quantidade)
end)

RegisterNetEvent('aj-farm:server:ComprarTomate', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_tomate'
    local dinheiro = 'bank'
    local quantidade = 1
    local preco = 20

    Player.Functions.RemoveMoney(dinheiro, preco)
    Player.Functions.AddItem(item, quantidade)
end)

RegisterNetEvent('aj-farm:server:ComprarTrigo', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_trigo'
    local dinheiro = 'bank'
    local quantidade = 1
    local preco = 20

    Player.Functions.RemoveMoney(dinheiro, preco)
    Player.Functions.AddItem(item, quantidade)
end)

RegisterNetEvent('aj-farm:server:ComprarBatatas', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_batatas'
    local dinheiro = 'bank'
    local quantidade = 1
    local preco = 20

    Player.Functions.RemoveMoney(dinheiro, preco)
    Player.Functions.AddItem(item, quantidade)
end)

RegisterNetEvent('aj-farm:server:ComprarPepino', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_pepino'
    local dinheiro = 'bank'
    local quantidade = 1
    local preco = 20

    Player.Functions.RemoveMoney(dinheiro, preco)
    Player.Functions.AddItem(item, quantidade)
end)

RegisterNetEvent('aj-farm:server:ComprarCebola', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_cebola'
    local dinheiro = 'bank'
    local quantidade = 1
    local preco = 20

    Player.Functions.RemoveMoney(dinheiro, preco)
    Player.Functions.AddItem(item, quantidade)
end)

RegisterNetEvent('aj-farm:server:ComprarCove', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_cove'
    local dinheiro = 'bank'
    local quantidade = 1
    local preco = 20

    Player.Functions.RemoveMoney(dinheiro, preco)
    Player.Functions.AddItem(item, quantidade)
end)

RegisterNetEvent('aj-farm:server:ComprarAlface', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_alface'
    local dinheiro = 'bank'
    local quantidade = 1
    local preco = 20

    Player.Functions.RemoveMoney(dinheiro, preco)
    Player.Functions.AddItem(item, quantidade)
end)

RegisterNetEvent('aj-farm:server:ComprarCenora', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_cenora'
    local dinheiro = 'bank'
    local quantidade = 1
    local preco = 20

    Player.Functions.RemoveMoney(dinheiro, preco)
    Player.Functions.AddItem(item, quantidade)
end)

RegisterNetEvent('aj-farm:server:ComprarBeterraba', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_beterraba'
    local dinheiro = 'bank'
    local quantidade = 1
    local preco = 20

    Player.Functions.RemoveMoney(dinheiro, preco)
    Player.Functions.AddItem(item, quantidade)
end)

RegisterNetEvent('aj-farm:server:ComprarNabo', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_nabo'
    local dinheiro = 'bank'
    local quantidade = 1
    local preco = 20

    Player.Functions.RemoveMoney(dinheiro, preco)
    Player.Functions.AddItem(item, quantidade)
end)

RegisterNetEvent('aj-farm:server:ComprarCogumelos', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_cogumelos'
    local dinheiro = 'bank'
    local quantidade = 1
    local preco = 20

    Player.Functions.RemoveMoney(dinheiro, preco)
    Player.Functions.AddItem(item, quantidade)
end)

RegisterNetEvent('aj-farm:server:ComprarRegador', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_regador'
    local dinheiro = 'bank'
    local quantidade = 1
    local preco = 10

    Player.Functions.RemoveMoney(dinheiro, preco)
    Player.Functions.AddItem(item, quantidade)
end)

RegisterNetEvent('aj-farm:server:ComprarTesoura', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_tesoura'
    local dinheiro = 'bank'
    local quantidade = 1
    local preco = 20

    Player.Functions.RemoveMoney(dinheiro, preco)
    Player.Functions.AddItem(item, quantidade)
end)

RegisterNetEvent('aj-farm:server:EncherRegador', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local farm_regador = Player.Functions.GetItemByName('farm_regador')
    local item = 'farm_regador'
    local item2 = 'farm_regador_cheio'
    local quantidade = 1

    if farm_regador ~= nil then

        Player.Functions.RemoveItem(item, quantidade)
        Player.Functions.AddItem(item2, quantidade)
    else
        TriggerClientEvent("AJFW:Notify", src, "You need a empty water can...", "error")
    end
end)

-- Items

AJFW.Functions.CreateUseableItem('farm_trigo', function(source, item)
    TriggerClientEvent("aj-farm:client:startPlanting", source, 'farm_trigo') 
end)

AJFW.Functions.CreateUseableItem('farm_tomate', function(source, item)
    TriggerClientEvent("aj-farm:client:startPlanting", source, 'farm_tomate') 
end)

AJFW.Functions.CreateUseableItem('farm_batatas', function(source, item)
    TriggerClientEvent("aj-farm:client:startPlanting", source, 'farm_batatas') 
end)

AJFW.Functions.CreateUseableItem('farm_nabo', function(source, item)
    TriggerClientEvent("aj-farm:client:startPlanting", source, 'farm_nabo') 
end)

AJFW.Functions.CreateUseableItem('farm_cebola', function(source, item)
    TriggerClientEvent("aj-farm:client:startPlanting", source, 'farm_cebola') 
end)

AJFW.Functions.CreateUseableItem('farm_cove', function(source, item)
    TriggerClientEvent("aj-farm:client:startPlanting", source, 'farm_cove') 
end)

AJFW.Functions.CreateUseableItem('farm_alface', function(source, item)
    TriggerClientEvent("aj-farm:client:startPlanting", source, 'farm_alface') 
end)

AJFW.Functions.CreateUseableItem('farm_cenora', function(source, item)
    TriggerClientEvent("aj-farm:client:startPlanting", source, 'farm_cenora') 
end)

AJFW.Functions.CreateUseableItem('farm_pepino', function(source, item)
    TriggerClientEvent("aj-farm:client:startPlanting", source, 'farm_pepino') 
end)

AJFW.Functions.CreateUseableItem('farm_cogumelos', function(source, item)
    TriggerClientEvent("aj-farm:client:startPlanting", source, 'farm_cogumelos') 
end)

AJFW.Functions.CreateUseableItem('farm_beterraba', function(source, item)
    TriggerClientEvent("aj-farm:client:startPlanting", source, 'farm_beterraba') 
end)



-- Plantas

CreateThread(function()
    updatePlants()
end)

function updatePlants()
    SetTimeout(Config.GrowRate * 1000, function()
        updatePlants()
    end)
    --DEAD PLANTS
    MySQL.query("SELECT id FROM player_plants WHERE (water = 0 OR food = 0) AND rate = 0",{},function(id)
        for _, v in ipairs(id) do
            MySQL.update('DELETE FROM player_plants WHERE id = ?', {v.id}, function()
                TriggerClientEvent("aj-farm:client:DeleteEntity", -1)  
            end)
        end
    end)
    -- ALIVE PLANT REDUCTION
    MySQL.update("UPDATE `player_plants` SET `stage`=`stage` + (0.01 * `rate`) , `food` = `food` - (0.02 * `rate`), `water` = `water` -  (0.02 * `rate`) WHERE water >= 2 OR food >= 2",{},
    function()
        TriggerClientEvent("aj-farm:client:growthUpdate", -1)
    end)
    -- GROW PLANTS
    MySQL.query("SELECT id, stage FROM player_plants WHERE (stage >= 30 AND stage <= 31) OR (stage >= 80 AND stage <= 81)",{},
    function(info)
        for _, v in ipairs(info) do
            TriggerClientEvent("aj-farm:client:growPlant", -1, v.id, v.stage)
        end
    end)
end

function addPlant(seed, coords, id)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local zone = nil
    MySQL.insert('INSERT INTO player_plants (coords, seed, stage, rate, water, food) VALUES (?, ?, ?, ?, ?, ?)',{
        json.encode({x = coords[1], y = coords[2], z = coords[3]}),
        seed,
        0,
        10,
        10,
        10
    },function(id)
        TriggerClientEvent("aj-farm:client:addPlant", src, seed, coords, id)
    end)
end

RegisterNetEvent("aj-farm:server:addPlantToDatabase",function(seed, coords)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    addPlant(seed, coords, src)
    Player.Functions.RemoveItem(seed, 1)
	TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[seed], "remove", 1)
end)

RegisterNetEvent("aj-farm:server:deletePlant",function(id)
    MySQL.update('DELETE FROM player_plants WHERE id = ?', {id})
end)

RegisterNetEvent("aj-farm:server:updatePlant",function(id, info)
    MySQL.update('UPDATE player_plants SET stage = ?, rate = ?, food = ?, water = ? WHERE id = ?',{info.stage, info.rate, info.food, info.water, id})
end)

AJFW.Functions.CreateCallback("aj-farm:server:getInfo",function(source, cb)
    MySQL.query('SELECT * FROM player_plants WHERE 1',{}, function(infoPlants)
        local plants = {}
        for _, v in ipairs(infoPlants) do
            local coords = json.decode(v.coords) or {x = 0, y = 0, z = 0}
            local data = {stage = v.stage, rate = v.rate, water = v.water, food = v.food} 
            coords = vector3(coords.x, coords.y, coords.z)
            plants[v.id] = {seed = v.seed, coords = coords, info = data}
        end
        cb(plants)
    end)
end)

AJFW.Functions.CreateCallback("aj-farm:server:getPlant",function(source, cb, id)
    MySQL.query("SELECT stage,rate,food,water FROM player_plants WHERE id = @id LIMIT 1",{["@id"] = id},function(info)
        local data = {stage = info[1].stage, rate = info[1].rate, water = info[1].water, food = info[1].food}
        cb(data)
    end)
end)

RegisterNetEvent("aj-farm:server:addAlimento", function(seed, info)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src) 
    local amount = 3 * tonumber(info.stage) / 100
    local semente = seed
    local quantidade = Config.PlantAlimentsQuantity
    
    if semente == 'farm_trigo' then
        Player.Functions.AddItem('farm_trigo_colhido', quantidade)
    elseif semente == 'farm_tomate' then
        Player.Functions.AddItem('farm_tomate_colhido', quantidade)
    elseif semente == 'farm_nabo' then
        Player.Functions.AddItem('farm_nabo_colhido', quantidade)
    elseif semente == 'farm_batatas' then
        Player.Functions.AddItem('farm_batatas_colhido', quantidade)
    elseif semente == 'farm_pepino' then
        Player.Functions.AddItem('farm_pepino_colhido', quantidade)
    elseif semente == 'farm_cebola' then
        Player.Functions.AddItem('farm_cebola_colhido', quantidade)
    elseif semente == 'farm_cove' then
        Player.Functions.AddItem('farm_cove_colhido', quantidade)
    elseif semente == 'farm_alface' then
        Player.Functions.AddItem('farm_alface_colhido', quantidade)
    elseif semente == 'farm_cenora' then
        Player.Functions.AddItem('farm_cenora_colhido', quantidade)
    elseif semente == 'farm_cogumelos' then
        Player.Functions.AddItem('farm_cogumelos_colhido', quantidade)
    end
end)

-- Ordenhar Vacas

RegisterNetEvent('aj-farm:server:OrdenharVacas', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local Item = 'farm_leite'
    local quantidade = Config.MilkQuantity

    Player.Functions.AddItem(Item, quantidade)
end)

-- Processo

RegisterNetEvent('aj-farm:server:ProcessarTomate', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_tomate_colhido'
    local item2 = 'farm_sumo_tomate'
    local quantidade = 1
    local GetItem = Player.Functions.GetItemByName(item)
    if GetItem ~= nil then

        if GetItem.amount >= 1 then
            Player.Functions.RemoveItem(item, quantidade)
            Player.Functions.AddItem(item2, quantidade)
        else
            TriggerClientEvent("AJFW:Notify", src, "You do not have the rigth items...", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", src, "You do not have the rigth items...", "error")
    end
end)

RegisterNetEvent('aj-farm:server:ProcessarTrigo', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_trigo_colhido'
    local item2 = 'farm_farinha'
    local quantidade = 1
    local GetItem = Player.Functions.GetItemByName(item)
    if GetItem ~= nil then

        if GetItem.amount >= 1 then
            Player.Functions.RemoveItem(item, quantidade)
            Player.Functions.AddItem(item2, quantidade)
        else
            TriggerClientEvent("AJFW:Notify", src, "You do not have the rigth items...", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", src, "You do not have the rigth items...", "error")
    end
end)

RegisterNetEvent('aj-farm:server:ProcessarLaranjas', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_laranja'
    local item2 = 'farm_sumo_laranja'
    local quantidade = 1
    local GetItem = Player.Functions.GetItemByName(item)
    if GetItem ~= nil then

        if GetItem.amount >= 1 then
            Player.Functions.RemoveItem(item, quantidade)
            Player.Functions.AddItem(item2, quantidade)
        else
            TriggerClientEvent("AJFW:Notify", src, "You do not have the rigth items...", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", src, "You do not have the rigth items...", "error")
    end
end)

RegisterNetEvent('aj-farm:server:ProcessarPessego', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_pessego'
    local item2 = 'farm_sumo_pessego'
    local quantidade = 1
    local GetItem = Player.Functions.GetItemByName(item)
    if GetItem ~= nil then

        if GetItem.amount >= 1 then
            Player.Functions.RemoveItem(item, quantidade)
            Player.Functions.AddItem(item2, quantidade)
        else
            TriggerClientEvent("AJFW:Notify", src, "You do not have the rigth items...", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", src, "You do not have the rigth items...", "error")
    end
end)

RegisterNetEvent('aj-farm:server:ProcessarMaca', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_maca'
    local item2 = 'farm_sumo_maca'
    local quantidade = 1
    local GetItem = Player.Functions.GetItemByName(item)
    if GetItem ~= nil then

        if GetItem.amount >= 1 then
            Player.Functions.RemoveItem(item, quantidade)
            Player.Functions.AddItem(item2, quantidade)
        else
            TriggerClientEvent("AJFW:Notify", src, "You do not have the rigth items...", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", src, "You do not have the rigth items...", "error")
    end
end)

RegisterNetEvent('aj-farm:server:ProcessarManga', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_manga'
    local item2 = 'farm_sumo_manga'
    local quantidade = 1
    local GetItem = Player.Functions.GetItemByName(item)
    if GetItem ~= nil then

        if GetItem.amount >= 1 then
            Player.Functions.RemoveItem(item, quantidade)
            Player.Functions.AddItem(item2, quantidade)
        else
            TriggerClientEvent("AJFW:Notify", src, "You do not have the rigth items...", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", src, "You do not have the rigth items...", "error")
    end
end)

RegisterNetEvent('aj-farm:server:ProcessarPera', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_pera'
    local item2 = 'farm_sumo_pera'
    local quantidade = 1
    local GetItem = Player.Functions.GetItemByName(item)
    if GetItem ~= nil then

        if GetItem.amount >= 1 then
            Player.Functions.RemoveItem(item, quantidade)
            Player.Functions.AddItem(item2, quantidade)
        else
            TriggerClientEvent("AJFW:Notify", src, "You do not have the rigth items...", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", src, "You do not have the rigth items...", "error")
    end
end)

RegisterNetEvent('aj-farm:server:ProcessarLimao', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local item = 'farm_limao'
    local item2 = 'farm_sumo_limao'
    local quantidade = 1
    local GetItem = Player.Functions.GetItemByName(item)
    if GetItem ~= nil then

        if GetItem.amount >= 1 then
            Player.Functions.RemoveItem(item, quantidade)
            Player.Functions.AddItem(item2, quantidade)
        else
            TriggerClientEvent("AJFW:Notify", src, "You do not have the rigth items...", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", src, "You do not have the rigth items...", "error")
    end
end)

-- venda

local ItemList = {
    ["farm_sumo_tomate"] =  Config.TomatoJuicePrice,
    ["farm_farinha"] =  Config.FlourPrice,
    ["farm_batatas_colhido"] =  Config.PotatoPrice,
    ["farm_pepino_colhido"] =  Config.CucumberPrice,
    ["farm_cebola_colhido"] =  Config.OnionPrice,
    ["farm_cove_colhido"] =  Config.CabbagePrice,
    ["farm_alface_colhido"] =  Config.LettucePrice,
    ["farm_cenora_colhido"] =  Config.CarrotPrice,
    ["farm_beterraba_colhido"] =  Config.BeetPrice,
    ["farm_nabo_colhido"] =  Config.TurnipPrice,
    ["farm_cogumelos_colhido"] =  Config.MushroomsPrice,
    ["farm_leite"] =  Config.MilkPrice,
    ["farm_sumo_laranja"] =  Config.OrangePrice,
    ["farm_sumo_pessego"] =  Config.PeachPrice,
    ["farm_sumo_pera"] =  Config.PearPrice,
    ["farm_sumo_maca"] =  Config.ApplePrice,
    ["farm_sumo_manga"] =  Config.MangoPrice,
    ["farm_sumo_limao"] =  Config.LemonPrice,
}

RegisterNetEvent('aj-farm:server:venderTudo', function()
    local src = source
    local price = 0
    local Player = AJFW.Functions.GetPlayer(src)
    if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then
        for k, v in pairs(Player.PlayerData.items) do
            if Player.PlayerData.items[k] ~= nil then
                if ItemList[Player.PlayerData.items[k].name] ~= nil then
                    price = price + (ItemList[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                    Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                    TriggerClientEvent('inventory:client:ItemBox', source, AJFW.Shared.Items[Player.PlayerData.items[k].name], "remove", Player.PlayerData.items[k].amount)
                end
            end
        end
        Player.Functions.AddMoney("cash", price)
        TriggerClientEvent('AJFW:Notify', src, "You sell some aliments for $"..price)
    else 
		TriggerClientEvent('AJFW:Notify', src, "You dont/'t have anything to sell..")
	end
end)

RegisterNetEvent('aj-farm:server:AddItem', function(ItemName, ItemAmount)
    local Player = AJFW.Functions.GetPlayer(source)

    Player.Functions.AddItem(ItemName, ItemAmount)
    TriggerClientEvent('inventory:client:ItemBox', source, AJFW.Shared.Items[ItemName], "add", ItemAmount)
end)

RegisterNetEvent('aj-farm:server:RemoveItem', function(ItemName, ItemAmount)
    local Player = AJFW.Functions.GetPlayer(source)

    Player.Functions.RemoveItem(ItemName, ItemAmount)
    TriggerClientEvent('inventory:client:ItemBox', source, AJFW.Shared.Items[ItemName], "remove", ItemAmount)
end)


AJFW.Functions.CreateCallback('aj-farm:server:VerificarItem', function(source, cb, item)
    local Player = AJFW.Functions.GetPlayer(source)

    if Player.Functions.GetItemByName(item) then
        cb(true)
    else
        cb(false)
    end
end)