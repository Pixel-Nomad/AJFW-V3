local AJFW = exports['aj-base']:GetCoreObject()

RegisterServerEvent('aj-drugprocessing:Processlsd', function()
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)

	if Player.Functions.RemoveItem("lsa", 1) then
		if Player.Functions.RemoveItem("thionyl_chloride", 1) then
			if Player.Functions.AddItem("lsd", 1) then
				TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items["lsd"], "add")
				TriggerClientEvent('AJFW:Notify', src, Lang:t("success.lsd"), "success")
			else
				Player.Functions.AddItem("lsa", 1)
				Player.Functions.AddItem("thionyl_chloride", 1)
			end
		else
			Player.Functions.AddItem("lsa", 1)
			TriggerClientEvent('AJFW:Notify', src, Lang:t("error.no_thionyl_chloride"), "error")
		end
	else
		TriggerClientEvent('AJFW:Notify', src, Lang:t("error.no_lsa"), "error")
	end
end)

RegisterServerEvent('aj-drugprocessing:processThionylChloride', function()
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)

	if Player.Functions.RemoveItem("lsa", 1) then
		if Player.Functions.RemoveItem("chemicals", 1) then
			if Player.Functions.AddItem("thionyl_chloride", 1) then
				TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items["thionyl_chloride"], "add")
				TriggerClientEvent('AJFW:Notify', src, Lang:t("success.thionyl_chloride"), "success")
			else
				Player.Functions.AddItem("lsa", 1)
				Player.Functions.AddItem("chemicals", 1)
			end
		else
			Player.Functions.AddItem("lsa", 1)
			TriggerClientEvent('AJFW:Notify', src, Lang:t("error.no_chemicals"), "error")
		end
	else
		TriggerClientEvent('AJFW:Notify', src, Lang:t("error.no_lsa"), "error")
	end
end)
