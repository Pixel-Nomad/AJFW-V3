local AJFW = exports['aj-base']:GetCoreObject()

RegisterServerEvent('aj-drugprocessing:pickedUpChemicals', function()
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)

	if Player.Functions.AddItem("chemicals", 1) then
		TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items["chemicals"], "add")
		TriggerClientEvent('AJFW:Notify', src, Lang:t("success.chemicals"), "success")
	end
end)

RegisterServerEvent('aj-drugprocessing:processHydrochloric_acid', function()
	local src = source
    local Player = AJFW.Functions.GetPlayer(src)

	if Player.Functions.RemoveItem('chemicals', 1) then
		if Player.Functions.AddItem('hydrochloric_acid', 1) then
			TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['chemicals'], "remove")
			TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['hydrochloric_acid'], "add")
			TriggerClientEvent('AJFW:Notify', src, Lang:t("success.hydrochloric_acid"), "success")
		else
			Player.Functions.AddItem('chemicals', 1)
		end
	else
		TriggerClientEvent('AJFW:Notify', src, Lang:t("error.no_chemicals"), "error")
	end
end)

RegisterServerEvent('aj-drugprocessing:processsodium_hydroxide', function()
	local src = source
    local Player = AJFW.Functions.GetPlayer(src)

	if Player.Functions.RemoveItem('chemicals', 1) then
		if Player.Functions.AddItem('sodium_hydroxide', 1) then
			TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['chemicals'], "remove")
			TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['sodium_hydroxide'], "add")
			TriggerClientEvent('AJFW:Notify', src, Lang:t("success.sodium_hydroxide"), "success")
		else
			Player.Functions.AddItem('chemicals', 1)
		end
	else
		TriggerClientEvent('AJFW:Notify', src, Lang:t("error.no_chemicals"), "error")
	end
end)

RegisterServerEvent('aj-drugprocessing:processprocess_sulfuric_acid', function()
	local src = source
    local Player = AJFW.Functions.GetPlayer(src)

	if Player.Functions.RemoveItem('chemicals', 1) then
		if Player.Functions.AddItem('sulfuric_acid', 1) then
			TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['chemicals'], "remove")
			TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['sulfuric_acid'], "add")
			TriggerClientEvent('AJFW:Notify', src, Lang:t("success.sulfuric_acid"), "success")
		else
			Player.Functions.AddItem('chemicals', 1)
		end
	else
		TriggerClientEvent('AJFW:Notify', src, Lang:t("error.no_chemicals"), "error")
	end
end)

RegisterServerEvent('aj-drugprocessing:process_lsa', function()
	local src = source
    local Player = AJFW.Functions.GetPlayer(src)

	if Player.Functions.RemoveItem('chemicals', 1) then
		if Player.Functions.AddItem('lsa', 1) then 
			TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['chemicals'], "remove")
			TriggerClientEvent("inventory:client:ItemBox", source, AJFW.Shared.Items['lsa'], "add")
			TriggerClientEvent('AJFW:Notify', src, Lang:t("success.lsa"), "success")
		else
			Player.Functions.AddItem('chemicals', 1)
		end
	else
		TriggerClientEvent('AJFW:Notify', src, Lang:t("error.no_chemicals"), "error")
	end
end)


AJFW.Functions.CreateCallback('aj-drugprocessing:validate_items', function(source, cb, data)
    local Player = AJFW.Functions.GetPlayer(source)
    if not Player then return end

	local hasItems = {
		ret = true,
		items = {}
	}
	for name,amount in pairs(data) do
		local item = Player.Functions.GetItemByName(name)
		if not item or item and item.amount < amount then
			hasItems.ret = false
			hasItems.items[#hasItems.items+1] = AJFW.Shared.Items[name].label
		end
		if not hasItems then break end
	end
	hasItems.item = table.concat(hasItems.items, ", ")
	cb(hasItems)
end)