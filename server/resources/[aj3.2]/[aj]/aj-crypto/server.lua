local AJFW = exports['aj-base']:GetCoreObject()

AJFW.Functions.CreateUseableItem('cryptostick' , function(source, item)
    local Player = AJFW.Functions.GetPlayer(source)
    local Item = Player.Functions.GetItemByName('iphone')
    if Item then
        if Player.Functions.RemoveItem(item.name, 1, item.slot) then
            TriggerClientEvent("crypto:client:UseCrypto", source)
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "Something is missing", "error", 3000, 'left')
    end
end)

RegisterNetEvent('aj-crypto:hackingCompleted', function()
    local Player = AJFW.Functions.GetPlayer(source)
    if Player then
        Player.Functions.AddMoney('crypto', math.random(2,5), 'finished-Crypto')
    end
end)

AJFW.Commands.Add('givecryptos', 'Give Crypto', {{name = 'id', help = 'Player ID'}, {name = 'amount', help = 'Amount'}}, true, function(source, args)
    local src = source
	local id = tonumber(args[1])
	local amount = math.ceil(tonumber(args[2]))

	if id and amount then
		local xPlayer = AJFW.Functions.GetPlayer(src)
		local xReciv = AJFW.Functions.GetPlayer(id)

		if xReciv and xPlayer then
			if not xPlayer.PlayerData.metadata["isdead"] then
				local distance = xPlayer.PlayerData.metadata["inlaststand"] and 3.0 or 10.0
				if #(GetEntityCoords(GetPlayerPed(src)) - GetEntityCoords(GetPlayerPed(id))) < distance then
                    if amount > 0 then
                        if xPlayer.Functions.RemoveMoney('crypto', amount) then
                            if xReciv.Functions.AddMoney('crypto', amount) then
                                TriggerClientEvent('AJFW:Notify', src, Lang:t('success.give_cash',{id = tostring(id), cash = tostring(amount)}), "success")
                                TriggerClientEvent('AJFW:Notify', id, Lang:t('success.received_cash',{id = tostring(src), cash = tostring(amount)}), "success")
                                TriggerClientEvent("payanimation", src)
                            else
                                -- Return player cash
                                xPlayer.Functions.AddMoney('crypto', amount)
                                TriggerClientEvent('AJFW:Notify', src, Lang:t('error.not_give'), "error")
                            end
                        else
                            TriggerClientEvent('AJFW:Notify', src, Lang:t('error.not_enough'), "error")
                        end
                    else
                        TriggerClientEvent('AJFW:Notify', src, Lang:t('error.invalid_amount'), "error")
                    end
				else
					TriggerClientEvent('AJFW:Notify', src, Lang:t('error.too_far_away'), "error")
				end
			else
				TriggerClientEvent('AJFW:Notify', src, Lang:t('error.dead'), "error")
			end
		else
			TriggerClientEvent('AJFW:Notify', src, Lang:t('error.wrong_id'), "error")
		end
	else
		TriggerClientEvent('AJFW:Notify', src, Lang:t('error.givecash'), "error")
	end
end)