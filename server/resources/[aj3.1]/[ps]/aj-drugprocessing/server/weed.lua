local AJFW = exports['aj-base']:GetCoreObject()

RegisterServerEvent('aj-drugprocessing:pickedUpCannabis', function()
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)

	if Player.Functions.AddItem("cannabis", 1) then
		TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items["cannabis"], "add")
		TriggerClientEvent('AJFW:Notify', src, Lang:t("success.cannabis"), "success")
	end
end)

RegisterServerEvent('aj-drugprocessing:processCannabis', function()
	local src = source
    local Player = AJFW.Functions.GetPlayer(src)

	if Player.Functions.RemoveItem('cannabis', 1) then
		if Player.Functions.AddItem('marijuana', 1) then
			TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['cannabis'], "remove")
			TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['marijuana'], "add")
			TriggerClientEvent('AJFW:Notify', src, Lang:t("success.marijuana"), "success")
		else
			Player.Functions.AddItem('cannabis', 1)
		end
	else
		TriggerClientEvent('AJFW:Notify', src, Lang:t("error.no_cannabis"), "error")
	end
end)

RegisterServerEvent('aj-drugprocessing:rollJoint', function()
	local src = source
    local Player = AJFW.Functions.GetPlayer(src)

	if Player.Functions.RemoveItem('marijuana', 1) then
		if Player.Functions.RemoveItem('rolling_paper', 1) then
			if Player.Functions.AddItem('joint', 1) then
				TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['marijuana'], "remove")
				TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['rolling_paper'], "remove")
				TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['joint'], "add")
				TriggerClientEvent('AJFW:Notify', src, Lang:t("success.joint"), "success")
			else
				Player.Functions.AddItem('marijuana', 1)
				Player.Functions.AddItem('rolling_paper', 1)
			end
		else
			Player.Functions.AddItem('marijuana', 1)
		end
	else
		TriggerClientEvent('AJFW:Notify', src, Lang:t("error.no_marijuhana"), "error")
	end
end)

AJFW.Functions.CreateUseableItem("rolling_paper", function(source, item)
    local Player = AJFW.Functions.GetPlayer(source)
    TriggerClientEvent('aj-drugprocessing:client:rollJoint', source, 'marijuana', item)
end)

RegisterServerEvent('aj-drugprocessing:bagskunk', function()
	local src = source
    local Player = AJFW.Functions.GetPlayer(src)

	if Player.Functions.RemoveItem('marijuana', 1) then
		if Player.Functions.RemoveItem('empty_weed_bag', 1) then
			if Player.Functions.AddItem('weed_skunk', 1) then
				TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['marijuana'], "remove")
				TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['empty_weed_bag'], "remove")
				TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['weed_skunk'], "add")
				TriggerClientEvent('AJFW:Notify', src, Lang:t("success.baggy"), "success")
			else
				Player.Functions.AddItem('marijuana', 1)
				Player.Functions.AddItem('empty_weed_bag', 1)
			end
		else
			Player.Functions.AddItem('marijuana', 1)
		end
	else
		TriggerClientEvent('AJFW:Notify', src, Lang:t("error.no_marijuhana"), "error")
	end
end)

AJFW.Functions.CreateUseableItem("empty_weed_bag", function(source, item)
    local Player = AJFW.Functions.GetPlayer(source)
    TriggerClientEvent('aj-drugprocessing:client:bagskunk', source, 'marijuana', item)
end)
