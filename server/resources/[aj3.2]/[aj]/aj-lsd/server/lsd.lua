
local playersProcessingMushroom = {}
local AJFW = exports['aj-base']:GetCoreObject()

RegisterServerEvent('aj-lsdmushroom:pickedMushroom')
AddEventHandler('aj-lsdmushroom:pickedMushroom', function()
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)

	  if TriggerClientEvent("AJFW:Notify", src, "Picked up mushroom!!", "Success", 8000) then
		  Player.Functions.AddItem('mushroom', 1) ---- change this shit 
		  TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['mushroom'], "add")
	  end
  end)



RegisterServerEvent('aj-lsdmushroom:processMushroom')
AddEventHandler('aj-lsdmushroom:processMushroom', function()
		local src = source
    	local Player = AJFW.Functions.GetPlayer(src)

		Player.Functions.RemoveItem('mushroom', 1)----change this
		Player.Functions.RemoveItem('sodiumoxide', 1)----change this
		Player.Functions.RemoveItem('aspirine', 1)-----change this
        Player.Functions.RemoveItem('gbottle', 1)-----change this

        Player.Functions.AddItem('pmushroom', 1)-----change this
        Player.Functions.AddItem('vacid', 1)-----change this

		TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['mushroom'], "remove")
		TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['sodiumoxide'], "remove")
        TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['aspirine'], "remove")
        TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['gbottle'], "remove")

		TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['pmushroom'], "add")
        TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['vacid'], "add")
		TriggerClientEvent('AJFW:Notify', src, 'mushroom_processed', "success")                                                                         				
end)



function CancelProcessing(playerId)
	if playersProcessingMushroom[playerId] then
		ClearTimeout(playersProcessingMushroom[playerId])
		playersProcessingMushroom[playerId] = nil
	end
end

RegisterServerEvent('aj-lsdmushroom:cancelProcessing')
AddEventHandler('aj-lsdmushroom:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('aj-lsdmushroom:playerDropped', function(playerId, reason)
	CancelProcessing(playerId)
end)

RegisterServerEvent('aj-lsdmushroom:onPlayerDeath')
AddEventHandler('aj-lsdmushroom:onPlayerDeath', function(data)
	local src = source
	CancelProcessing(src)
end)


AJFW.Functions.CreateCallback('mushroom:ingredient', function(source, cb)
    local src = source
    local Ply = AJFW.Functions.GetPlayer(src)
    local mushroom = Ply.Functions.GetItemByName("mushroom")
	local sodiumoxide = Ply.Functions.GetItemByName("sodiumoxide")
	local aspirine = Ply.Functions.GetItemByName("aspirine")
    local gbottle = Ply.Functions.GetItemByName("gbottle")

    if mushroom ~= nil and sodiumoxide ~= nil and aspirine ~= nil and gbottle ~= nil then
        cb(true)
    else
        cb(false)
    end
end)


