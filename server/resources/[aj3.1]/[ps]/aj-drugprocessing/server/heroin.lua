local AJFW = exports['aj-base']:GetCoreObject()

RegisterServerEvent('aj-drugprocessing:pickedUpPoppy', function()
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)

	if Player.Functions.AddItem("poppyresin", 1) then
		TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items["poppyresin"], "add")
		TriggerClientEvent('AJFW:Notify', src, Lang:t("success.poppyresin"), "success")
	end
end)

RegisterServerEvent('aj-drugprocessing:processPoppyResin', function()
	local src = source
    local Player = AJFW.Functions.GetPlayer(src)

	if Player.Functions.RemoveItem('poppyresin', Config.HeroinProcessing.Poppy) then
		if Player.Functions.AddItem('heroin', 1) then
			TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['poppyresin'], "remove", Config.HeroinProcessing.Poppy)
			TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['heroin'], "add")
			TriggerClientEvent('AJFW:Notify', src, Lang:t("success.heroin"), "success")
		else
			Player.Functions.AddItem('poppyresin', 1)
		end
	else
		TriggerClientEvent('AJFW:Notify', src, Lang:t("error.no_poppy_resin"), "error")
	end
end)
