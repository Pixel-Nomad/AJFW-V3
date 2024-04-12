local AJFW = exports['aj-base']:GetCoreObject()
local objects = {}

AJFW.Functions.CreateCallback("aj-signrobbery:server:GetObjects", function(source, cb)
    cb(objects)
end)

RegisterNetEvent('aj-signrobbery:server:delete')
AddEventHandler('aj-signrobbery:server:delete', function(object)
    local src = source
    local sourceCoords = GetEntityCoords(GetPlayerPed(src))
    if #(sourceCoords - object.coords) < 4 then
        local Player = AJFW.Functions.GetPlayer(tonumber(src))
        objects[#objects+1] = {coords = object.coords, model = object.model}
        TriggerClientEvent("signrobbery:client:delete", -1, object)
        if object.model == -949234773 then
            Player.Functions.AddItem("stopsign", 1, false)
            TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items['stopsign'], "add")
        elseif object.model == 1502931467 then
            Player.Functions.AddItem("walkingmansign", 1, false)
            TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items['walkingmansign'], "add")
        elseif object.model == 1191039009 then
            Player.Functions.AddItem("dontblockintersectionsign", 1, false)
            TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items['dontblockintersectionsign'], "add")
        elseif object.model == 4138610559 then
            Player.Functions.AddItem("uturnsign", 1, false)
            TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items['uturnsign'], "add")
        elseif object.model == 3830972543 then
            Player.Functions.AddItem("noparkingsign", 1, false)
            TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items['noparkingsign'], "add")
        elseif  object.model == 2643325436 then
            Player.Functions.AddItem("leftturnsign", 1, false)
            TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items['leftturnsign'], "add")
		elseif  object.model == 793482617 then
            Player.Functions.AddItem("rightturnsign", 1, false)
            TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items['rightturnsign'], "add")
		elseif  object.model == 1021214550 then
			Player.Functions.AddItem("notrespassingsign", 1, false)
			TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items['notrespassingsign'], "add")
		elseif  object.model == 3654973172 then
			Player.Functions.AddItem("yieldsign", 1, false)
			TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items['yieldsign'], "add")
		end
	end
end)

---------------------
--- Usable Signs ----
---------------------
AJFW.Functions.CreateUseableItem("stopsign", function(source, item)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    TriggerClientEvent('aj-signrobbery:use:StopSign', src, item)
end)

AJFW.Functions.CreateUseableItem("walkingmansign", function(source, item)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    TriggerClientEvent('aj-signrobbery:use:WalkingManSign', src, item)
end)

AJFW.Functions.CreateUseableItem("dontblockintersectionsign", function(source, item)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    TriggerClientEvent('aj-signrobbery:use:DontBlockIntersectionSign', src, item)
end)

AJFW.Functions.CreateUseableItem("uturnsign", function(source, item)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    TriggerClientEvent('aj-signrobbery:use:UturnSign', src, item)
end)

AJFW.Functions.CreateUseableItem("noparkingsign", function(source, item)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    TriggerClientEvent('aj-signrobbery:use:NoParkingSign', src, item)
end)

AJFW.Functions.CreateUseableItem("leftturnsign", function(source, item)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    TriggerClientEvent('aj-signrobbery:use:LeftTurnSign', src, item)
end)

AJFW.Functions.CreateUseableItem("rightturnsign", function(source, item)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    TriggerClientEvent('aj-signrobbery:use:RightTurnSign', src, item)
end)

AJFW.Functions.CreateUseableItem("notrespassingsign", function(source, item)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    TriggerClientEvent('aj-signrobbery:use:NoTrespassingSign', src, item)
end)

AJFW.Functions.CreateUseableItem("yieldsign", function(source, item)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    TriggerClientEvent('aj-signrobbery:use:YieldSign', src, item)
end)

RegisterServerEvent("SignRobbery:TradeItems", function(data)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
	local randomItem = ""
	local amount = 0
	if data == 1 then
		if Player.Functions.GetItemByName('stopsign') ~= nil and Player.Functions.GetItemByName('stopsign').amount >= 1 then
			Player.Functions.RemoveItem("stopsign", 1)
			TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items["stopsign"], 'remove', 1)	
			Citizen.Wait(500)
			for i = 1, 5, math.random(1,2) do
				randomItem = Config.Items[math.random(1, #Config.Items)]
				amount = math.random(Config.min, Config.max)
				Player.Functions.AddItem(randomItem, amount, false, {["quality"] = nil})
				TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[randomItem], 'add', amount)
                Citizen.Wait(500)
			end
		else
			TriggerClientEvent('AJFW:Notify', src, "You Don't Have Enough Items")
		end
	elseif data == 2 then
		if Player.Functions.GetItemByName('walkingmansign') ~= nil and Player.Functions.GetItemByName('walkingmansign').amount >= 1 then
			Player.Functions.RemoveItem("walkingmansign", "1")
			TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items["walkingmansign"], 'remove', 1)
			Citizen.Wait(500)
			for i = 1, 5, math.random(1,2) do
				randomItem = Config.Items[math.random(1, #Config.Items)]
				amount = math.random(Config.min, Config.max)
				Player.Functions.AddItem(randomItem, amount, false, {["quality"] = nil})
				TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[randomItem], 'add', amount)
				Citizen.Wait(500)
			end
		else
			TriggerClientEvent('AJFW:Notify', src, "You Do Not Have Enough Items")
		end
    elseif data == 3 then
		if Player.Functions.GetItemByName('dontblockintersectionsign') ~= nil and Player.Functions.GetItemByName('dontblockintersectionsign').amount >= 1 then
			Player.Functions.RemoveItem("dontblockintersectionsign", "1")
			TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items["dontblockintersectionsign"], 'remove', 1)
			Citizen.Wait(500)
			for i = 1, 5, math.random(1,2) do
				randomItem = Config.Items[math.random(1, #Config.Items)]
				amount = math.random(Config.min, Config.max)
				Player.Functions.AddItem(randomItem, amount, false, {["quality"] = nil})
				TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[randomItem], 'add', amount)
				Citizen.Wait(500)
			end
		else
			TriggerClientEvent('AJFW:Notify', src, "You Do Not Have Enough Items")
		end
    elseif data == 4 then
		if Player.Functions.GetItemByName('uturnsign') ~= nil and Player.Functions.GetItemByName('uturnsign').amount >= 1 then
			Player.Functions.RemoveItem("uturnsign", "1")
			TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items["uturnsign"], 'remove', 1)
			Citizen.Wait(500)
			for i = 1, 5, math.random(1,2) do
				randomItem = Config.Items[math.random(1, #Config.Items)]
				amount = math.random(Config.min, Config.max)
				Player.Functions.AddItem(randomItem, amount, false, {["quality"] = nil})
				TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[randomItem], 'add', amount)
				Citizen.Wait(500)
			end
		else
			TriggerClientEvent('AJFW:Notify', src, "You Do Not Have Enough Items")
		end
    elseif data == 5 then
		if Player.Functions.GetItemByName('noparkingsign') ~= nil and Player.Functions.GetItemByName('noparkingsign').amount >= 1 then
			Player.Functions.RemoveItem("noparkingsign", "1")
			TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items["noparkingsign"], 'remove', 1)
			Citizen.Wait(500)
			for i = 1, 5, math.random(1,2) do
				randomItem = Config.Items[math.random(1, #Config.Items)]
				amount = math.random(Config.min, Config.max)
				Player.Functions.AddItem(randomItem, amount, false, {["quality"] = nil})
				TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[randomItem], 'add', amount)
				Citizen.Wait(500)
			end
		else
			TriggerClientEvent('AJFW:Notify', src, "You Do Not Have Enough Items")
		end
    elseif data == 6 then
		if Player.Functions.GetItemByName('leftturnsign') ~= nil and Player.Functions.GetItemByName('leftturnsign').amount >= 1 then
			Player.Functions.RemoveItem("leftturnsign", "1")
			TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items["leftturnsign"], 'remove', 1)
			Citizen.Wait(500)
			for i = 1, 5, math.random(1,2) do
				randomItem = Config.Items[math.random(1, #Config.Items)]
				amount = math.random(Config.min, Config.max)
				Player.Functions.AddItem(randomItem, amount, false, {["quality"] = nil})
				TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[randomItem], 'add', amount)
				Citizen.Wait(500)
			end
		else
			TriggerClientEvent('AJFW:Notify', src, "You Do Not Have Enough Items")
		end
	elseif data == 7 then
		if Player.Functions.GetItemByName('rightturnsign') ~= nil and Player.Functions.GetItemByName('rightturnsign').amount >= 1 then
			Player.Functions.RemoveItem("rightturnsign", "1")
			TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items["rightturnsign"], 'remove', 1)
			Citizen.Wait(500)
			for i = 1, 5, math.random(1,2) do
				randomItem = Config.Items[math.random(1, #Config.Items)]
				amount = math.random(Config.min, Config.max)
				Player.Functions.AddItem(randomItem, amount, false, {["quality"] = nil})
				TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[randomItem], 'add', amount)
				Citizen.Wait(500)
			end
		else
			TriggerClientEvent('AJFW:Notify', src, "You Do Not Have Enough Items")
		end
	elseif data == 8 then
		if Player.Functions.GetItemByName('notrespassingsign') ~= nil and Player.Functions.GetItemByName('notrespassingsign').amount >= 1 then
			Player.Functions.RemoveItem("notrespassingsign", "1")
			TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items["notrespassingsign"], 'remove', 1)
			Citizen.Wait(500)
			for i = 1, 5, math.random(1,2) do
				randomItem = Config.Items[math.random(1, #Config.Items)]
				amount = math.random(Config.min, Config.max)
				Player.Functions.AddItem(randomItem, amount, false, {["quality"] = nil})
				TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[randomItem], 'add', amount)
				Citizen.Wait(500)
			end
		else
			TriggerClientEvent('AJFW:Notify', src, "You Do Not Have Enough Items")
		end
	elseif data == 9 then
		if Player.Functions.GetItemByName('yieldsign') ~= nil and Player.Functions.GetItemByName('yieldsign').amount >= 1 then
			Player.Functions.RemoveItem("yieldsign", "1")
			TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items["yieldsign"], 'remove', 1)
			Citizen.Wait(500)
			for i = 1, 5, math.random(1,2) do
				randomItem = Config.Items[math.random(1, #Config.Items)]
				amount = math.random(Config.min, Config.max)
				Player.Functions.AddItem(randomItem, amount, false, {["quality"] = nil})
				TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[randomItem], 'add', amount)
				Citizen.Wait(500)
			end
		else
			TriggerClientEvent('AJFW:Notify', src, "You Do Not Have Enough Items")
		end
    end
end)
