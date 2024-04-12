local AJFW = exports['aj-base']:GetCoreObject()

RegisterServerEvent('aj-drugprocessing:pickedUpCocaLeaf', function()
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)

	if Player.Functions.AddItem("coca_leaf", 1) then 
		TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items["coca_leaf"], "add")
		TriggerClientEvent('AJFW:Notify', src, Lang:t("success.coca_leaf"), "success")
	else
		TriggerClientEvent('AJFW:Notify', src, Lang:t("error.no_coca_leaf"), "error")
	end
end)

RegisterServerEvent('aj-drugprocessing:processCocaLeaf', function()
	local src = source
    local Player = AJFW.Functions.GetPlayer(src)

	if Player.Functions.RemoveItem('coca_leaf', Config.CokeProcessing.CokeLeaf) then
		if Player.Functions.AddItem('coke', Config.CokeProcessing.ProcessCokeLeaf) then
			TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['coca_leaf'], "remove", Config.CokeProcessing.CokeLeaf)
			TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['coke'], "add", Config.CokeProcessing.ProcessCokeLeaf)
			TriggerClientEvent('AJFW:Notify', src, Lang:t("success.coke"), "success")
		else
			Player.Functions.AddItem('coca_leaf', Config.CokeProcessing.CokeLeaf)
		end
	else
		TriggerClientEvent('AJFW:Notify', src, Lang:t("error.no_coca_leaf"), "error")
	end
end)

RegisterServerEvent('aj-drugprocessing:processCocaPowder', function()
	local src = source
    local Player = AJFW.Functions.GetPlayer(src)

	if Player.Functions.RemoveItem('coke', Config.CokeProcessing.Coke) then
		if Player.Functions.RemoveItem('bakingsoda', Config.CokeProcessing.BakingSoda) then
			if Player.Functions.AddItem('coke_small_brick', Config.CokeProcessing.SmallCokeBrick) then
				TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['coke'], "remove", Config.CokeProcessing.Coke)
				TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['bakingsoda'], "remove", Config.CokeProcessing.BakingSoda)
				TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['coke_small_brick'], "add", Config.CokeProcessing.SmallCokeBrick)
				TriggerClientEvent('AJFW:Notify', src, Lang:t("success.coke_small_brick"), "success")
			else
				Player.Functions.AddItem('coke', Config.CokeProcessing.Coke)
				Player.Functions.AddItem('bakingsoda', Config.CokeProcessing.BakingSoda)
			end
		else
			Player.Functions.AddItem('coke', Config.CokeProcessing.Coke)
			TriggerClientEvent('AJFW:Notify', src, Lang:t("error.no_bakingsoda"), "error")
		end
	else
		TriggerClientEvent('AJFW:Notify', src, Lang:t("error.no_cokain"), "error")
	end
end)

RegisterServerEvent('aj-drugprocessing:processCocaBrick', function()
	local src = source
    local Player = AJFW.Functions.GetPlayer(src)

	if Player.Functions.RemoveItem('coke_small_brick', Config.CokeProcessing.SmallBrick) then
		if Player.Functions.AddItem('coke_brick', Config.CokeProcessing.LargeBrick) then
			TriggerClientEvent("inventory:client:ItemBox", src, AJFW.Shared.Items['coke_small_brick'], "remove", Config.CokeProcessing.SmallBrick)
			TriggerClientEvent("inventory:client:ItemBox", src, AJFW.Shared.Items['coke_brick'], "add", Config.CokeProcessing.LargeBrick)
			TriggerClientEvent('AJFW:Notify', src, Lang:t("success.coke_brick"), "success")
		else
			Player.Functions.AddItem('coke_small_brick', Config.CokeProcessing.SmallBrick)
		end
	end
end)
