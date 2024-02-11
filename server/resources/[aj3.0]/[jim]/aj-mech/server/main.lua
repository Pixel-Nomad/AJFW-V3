local AJFW = exports['aj-base']:GetCoreObject()
RegisterNetEvent('AJFW:Server:UpdateObject', function() if source ~= '' then return false end AJFW = exports['aj-base']:GetCoreObject() end)

--Create Usable Items
AJFW.Functions.CreateUseableItem("car_armor", function(source, item) TriggerClientEvent('aj-mech:client:applyArmour', source) end)
AJFW.Functions.CreateUseableItem("turbo", function(source, item) TriggerClientEvent("aj-mech:client:applyTurbo", source) end)
AJFW.Functions.CreateUseableItem("headlights", function(source, item) TriggerClientEvent("aj-mech:client:applyXenons", source) end)
AJFW.Functions.CreateUseableItem("underglow_controller", function(source, item) TriggerClientEvent('aj-mech:client:neonMenu', source) end)
AJFW.Functions.CreateUseableItem("toolbox", function(source, item) TriggerClientEvent('aj-mech:client:Menu', source) end)
AJFW.Functions.CreateUseableItem("mechanic_tools", function(source, item) TriggerClientEvent('aj-mech:client:Repair:Check', source) end)
AJFW.Functions.CreateUseableItem("seat", function(source, item) TriggerClientEvent('aj-mech:client:Seat:Check', source) end)
AJFW.Functions.CreateUseableItem("internals", function(source, item) TriggerClientEvent('aj-mech:client:Interior:Check', source) end)
AJFW.Functions.CreateUseableItem("externals", function(source, item) TriggerClientEvent('aj-mech:client:Exterior:Check', source) end)
AJFW.Functions.CreateUseableItem("rims", function(source, item) TriggerClientEvent('aj-mech:client:Rims:Check', source) end)
AJFW.Functions.CreateUseableItem("exhaust", function(source, item) TriggerClientEvent('aj-mech:client:Exhaust:Check', source) end)
AJFW.Functions.CreateUseableItem("horn", function(source, item) TriggerClientEvent('aj-mech:client:Horn:Check', source) end)
AJFW.Functions.CreateUseableItem("paintcan", function(source, item) TriggerClientEvent('aj-mech:client:Paints:Check', source) end)
AJFW.Functions.CreateUseableItem("livery", function(source, item) TriggerClientEvent('aj-mech:client:Livery:Check', source) end)
AJFW.Functions.CreateUseableItem("tires", function(source, item) TriggerClientEvent('aj-mech:client:Tires:Check', source) end)
AJFW.Functions.CreateUseableItem("skirts", function(source, item) TriggerClientEvent('aj-mech:client:Skirts:Check', source) end)
AJFW.Functions.CreateUseableItem("spoiler", function(source, item) TriggerClientEvent('aj-mech:client:Spoilers:Check', source) end)
AJFW.Functions.CreateUseableItem("roof", function(source, item) TriggerClientEvent('aj-mech:client:Roof:Check', source) end)
AJFW.Functions.CreateUseableItem("rollcage", function(source, item) TriggerClientEvent('aj-mech:client:RollCage:Check', source) end)
AJFW.Functions.CreateUseableItem("hood", function(source, item) TriggerClientEvent('aj-mech:client:Hood:Check', source) end)
AJFW.Functions.CreateUseableItem("bumper", function(source, item) TriggerClientEvent('aj-mech:client:Bumpers:Check', source) end)
AJFW.Functions.CreateUseableItem("customplate", function(source, item) TriggerClientEvent('aj-mech:client:Plates:Check', source) end)
AJFW.Functions.CreateUseableItem("cleaningkit", function(source, item) TriggerClientEvent('aj-mech:client:cleanVehicle', source, true) end)
AJFW.Functions.CreateUseableItem("tint_supplies", function(source, item) TriggerClientEvent('aj-mech:client:Windows:Check', source) end)
AJFW.Functions.CreateUseableItem("ducttape", function(source, item) TriggerClientEvent("aj-mech:quickrepair", source) end)
AJFW.Functions.CreateUseableItem("bprooftires", function(source, item) TriggerClientEvent("aj-mech:client:applyBulletProof", source) end)
AJFW.Functions.CreateUseableItem("drifttires", function(source, item) TriggerClientEvent("aj-mech:client:applyDrift", source) end)
AJFW.Functions.CreateUseableItem("nos", function(source, item) TriggerClientEvent("aj-mech:client:applyNOS", source) end)

for i = 1, 5 do
	AJFW.Functions.CreateUseableItem("suspension"..i, function(source, item) TriggerClientEvent("aj-mech:client:applySuspension", source, i-1) end)
	AJFW.Functions.CreateUseableItem("engine"..i, function(source, item) TriggerClientEvent("aj-mech:client:applyEngine", source, i-1) end)
end
for i = 1, 4 do
	AJFW.Functions.CreateUseableItem("transmission"..i, function(source, item) TriggerClientEvent("aj-mech:client:applyTransmission", source, i-1) end)
end
for i = 1, 3 do
	AJFW.Functions.CreateUseableItem("brakes"..i, function(source, item) TriggerClientEvent("aj-mech:client:applyBrakes", source, i-1) end)
end

--Item Give/Remove (for performance items)
RegisterNetEvent('aj-mech:server:swapItem', function(level, current, item)
	local src = source
	if level then
		AJFW.Functions.GetPlayer(src).Functions.RemoveItem(item..level+1, 1, nil, nil, true)
		TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[item..level+1], "remove", 1)
	end
	if current ~= -1 then
		if AJFW.Functions.GetPlayer(src).Functions.AddItem(item..current+1, 1, nil,true) then
			TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[item..current+1], "add", 1)
		end
	end
end)

function HasItem(source, items, amount)
	local amount = amount or 1
    local Player = AJFW.Functions.GetPlayer(source)
    if not Player then return false end
    local totalItems = #items
    local count = 0
    local kvIndex = 2

	if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Checking if player has required item^7 '^3"..tostring(items).."^7'") end

	for _, itemData in pairs(Player.PlayerData.items) do
        if itemData and (itemData.name == items) then
			if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Item^7: '^3"..tostring(items).."^7' ^2Slot^7: ^3"..itemData.slot.." ^7x(^3"..tostring(itemData.amount).."^7)") end
			count += itemData.amount
		end
	end
	if count >= amount then
		if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items ^5FOUND^7 x^3"..count.."^7") end
		return true
	end
	if Config.Debug then print("^5Debug^7: ^3HasItem^7: ^2Items ^1NOT FOUND^7") end
    return false
end


--General give take items
RegisterNetEvent('aj-mech:server:toggleItem', function(give, item, amount)
	local amount = amount or 1
	local remamount = amount
	local src = source
	if not give then
		if HasItem(src, item, amount) then -- check if you still have the item
			if AJFW.Functions.GetPlayer(src).Functions.GetItemByName(item).unique then -- If unique item, keep removing until gone
				while remamount > 0 do
					AJFW.Functions.GetPlayer(src).Functions.RemoveItem(item, 1, nil, nil, true)
					remamount -= 1
				end
				TriggerClientEvent('inventory:client:ItemBox', source, AJFW.Shared.Items[item], "remove", amount) -- Show removal item box when all are removed
				return
			end
			if AJFW.Functions.GetPlayer(src).Functions.RemoveItem(item, amount, nil, nil, true) then
				if Config.Debug then print("^5Debug^7: ^1Removing ^2from Player^7(^2"..src.."^7) '^6"..AJFW.Shared.Items[item].label.."^7(^2x^6"..(amount or "1").."^7)'") end
				TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[item], "remove", amount)
			end
		else TriggerEvent("aj-mech:server:DupeWarn", item, src) end -- if not boot the player
	elseif give then
		if AJFW.Functions.GetPlayer(src).Functions.AddItem(item, amount, nil,nil,true) then
			if Config.Debug then print("^5Debug^7: ^4Giving ^2Player^7(^2"..src.."^7) '^6"..AJFW.Shared.Items[item].label.."^7(^2x^6"..(amount or "1").."^7)'") end
			TriggerClientEvent('inventory:client:ItemBox', source, AJFW.Shared.Items[item], "add", amount)
		end
	end
end)

AddEventHandler('onResourceStart', function(r) if GetCurrentResourceName() ~= r then return end
local itemcheck = true
--Check crafting recipes and their ingredients
if Config.Crafting then
	for k, v in pairs(Crafting) do for i = 1, #v do for l, b in pairs(v[i]) do if l ~= "amount" and l ~= "job" then
			if not AJFW.Shared.Items[l] then print("^5Debug^7: ^3onResourceStart^7: ^2Missing Item from ^4Shared^7.^4Items^7: '^6"..l.."^7'") itemcheck = false end
			for j in pairs(b) do if not AJFW.Shared.Items[j] then print("^5Debug^7: ^3onResourceStart^7: ^2Missing Item from ^4Shared^7.^4Items^7: '^6"..j.."^7'") itemcheck = false end	end	end	end	end
		end
	end
	-- Check Stores for missing items
	if Config.Stores then
		for _, v in pairs(Stores) do
			for i = 1, #v.items do if not AJFW.Shared.Items[v.items[i].name] then print("^5Debug^7: ^3onResourceStart^7: ^2Missing Item from ^4Shared^7.^4Items^7: '^6"..v.items[i].name.."^7'") itemcheck = false end end
		end
	end
	-- Check if theres a missing item/mistake in the repair materials
	if not FreeRepair then
		if not AJFW.Shared.Items[Config.RepairEngine] then print("^5Debug^7: ^3onResourceStart^7: ^2Engine repair requested a item missing from the Shared^7: '"..Config.RepairEngine.."^7'") itemcheck = false end
		if not AJFW.Shared.Items[Config.RepairBody] then print("^5Debug^7: ^3onResourceStart^7: ^2Body repair requested a item missing from the Shared^7: '"..Config.RepairBody.."^7'") itemcheck = false end
		if useMechJob then
			if not AJFW.Shared.Items[Config.RepairRadiator] then print("^5Debug^7: ^3onResourceStart^7: ^2Radiator repair requested a item missing from the Shared^7: '^6"..Config.RepairRadiator.."^7'") itemcheck = false end
			if not AJFW.Shared.Items[Config.RepairAxle] then print("^5Debug^7: ^3onResourceStart^7: ^2Axle repair requested a item missing from the Shared^7: '^6"..Config.RepairAxle.."^7'") itemcheck = false end
			if not AJFW.Shared.Items[Config.RepairBrakes] then print("^5Debug^7: ^3onResourceStart^7: ^2Brakes repair requested a item missing from the Shared^7: '^6"..Config.RepairBrakes.."^7'") itemcheck = false end
			if not AJFW.Shared.Items[Config.RepairClutch] then print("^5Debug^7: ^3onResourceStart^7: ^2Clutch repair requested a item missing from the Shared^7: '^6"..Config.RepairClutch.."^7'") itemcheck = false end
			if not AJFW.Shared.Items[Config.RepairFuel] then print("^5Debug^7: ^3onResourceStart^7: ^2FuelTank repair requested a item missing from the Shared^7: '^6"..Config.RepairFuel.."^7'") itemcheck = false end
		end
	end
	-- Check for "mechboard" item
	if not AJFW.Shared.Items["mechboard"] then print("^5Debug^7: ^3onResourceStart^7: ^2Missing Item from ^4Shared^7.^4Items^7: '^6mechboard^7'") itemcheck = false end
	for k, v in pairs(Config.JobRoles) do
		if not AJFW.Shared.Jobs[v] then print("^5Debug^7: ^3onResourceStart^7: ^4Config^7.^4Jobroles ^2tried to find the missing job^7: '^6"..v.."^7'") end
	end
	--Success message if all there.
	if Config.Debug and itemcheck then print("^5Debug^7: ^3onResourceStart^7: ^2All items found in the shared^7!") end
end)