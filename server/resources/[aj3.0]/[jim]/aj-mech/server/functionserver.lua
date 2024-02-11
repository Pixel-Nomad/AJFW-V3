local AJFW = exports['aj-base']:GetCoreObject()
RegisterNetEvent('AJFW:Server:UpdateObject', function() if source ~= '' then return false end AJFW = exports['aj-base']:GetCoreObject() end)

local Previewing = {}
local xenonColour = {}
----Commands
--[[AJFW.Commands.Add("test", "", {}, false, function(source, args) TriggerServerEvent('aj-mech:server:LoadNitrous', trim(GetVehicleNumberPlateText(GetVehiclePedIsIn(source)))) end)]]

AJFW.Commands.Add("preview", Loc[Config.Lan]["servfunction"].checkmods, {}, false, function(source) TriggerClientEvent("aj-mech:client:Preview:Menu", source) end)
AJFW.Commands.Add("checkveh", "Check Performance", {}, false, function(source) TriggerClientEvent("aj-mech:client:cuscheck", source) end)
AJFW.Commands.Add("showodo", "Odometer", {}, false, function(source) TriggerClientEvent("aj-mech:ShowOdo", source) end)
AJFW.Commands.Add("checkdamage", Loc[Config.Lan]["servfunction"].checkdamage, {}, false, function(source) TriggerClientEvent("aj-mech:client:Repair:Check", source, true) end)
AJFW.Commands.Add("checkmods", Loc[Config.Lan]["servfunction"].checkmods, {}, false, function(source) TriggerClientEvent("aj-mech:client:Menu:List", source) end)
AJFW.Commands.Add("flipvehicle", Loc[Config.Lan]["servfunction"].flipvehicle, {}, false, function(source)	TriggerClientEvent("aj-mech:flipvehicle", source) end)
AJFW.Commands.Add("togglesound", Loc[Config.Lan]["servfunction"].togglesound, {}, false, function(source)	TriggerClientEvent("aj-mech:togglesound", source) end)
AJFW.Commands.Add("cleancar", Loc[Config.Lan]["servfunction"].cleancar, {}, false, function(source) TriggerClientEvent("aj-mech:client:cleanVehicle", source, true) end)
AJFW.Commands.Add("hood", Loc[Config.Lan]["servfunction"].hood, {}, false, function(source) TriggerClientEvent("aj-mech:client:openDoor", source, 4) end)
AJFW.Commands.Add("trunk", Loc[Config.Lan]["servfunction"].trunk, {}, false, function(source) TriggerClientEvent("aj-mech:client:openDoor", source, 5) end)
AJFW.Commands.Add("door", Loc[Config.Lan]["servfunction"].door, {{name="0-3", help="Door ID"}}, false, function(source, args) TriggerClientEvent("aj-mech:client:openDoor", source, args[1]) end)
AJFW.Commands.Add("seat", Loc[Config.Lan]["servfunction"].seat, {{name="id", help="Seat ID"}}, false, function(source, args) TriggerClientEvent("aj-mech:seat", source, args[1]) end)

AJFW.Functions.CreateCallback("aj-mech:checkVehicleOwner", function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE plate = ?', { plate }, function(result)
        if result[1] then cb(true)
        else cb(false) end
	end)
end)

AJFW.Functions.CreateCallback("aj-mech:distGrab", function(source, cb, plate)
	local result = MySQL.scalar.await('SELECT traveldistance FROM player_vehicles WHERE plate = ?', {plate})
	if result then cb(result) else cb("") end
end)

RegisterNetEvent("aj-mech:updateVehicle", function(myCar, plate)
	local result = MySQL.scalar.await('SELECT mods FROM player_vehicles WHERE plate = ?', {plate})
	if result then
		if Config.Debug then print("^5Debug^7: ^3updateVehicle^7: ^2Vehicle Mods^7 - [^6"..plate.."^7]: ^4"..json.encode(myCar).."^7")
		else print("^5Debug^7: ^3updateVehicle^7: ^2Vehicle Mods^7 - [^6"..plate.."^7]") end
		MySQL.Async.execute('UPDATE player_vehicles SET mods = ? WHERE plate = ?', { json.encode(myCar), plate })
	end
end)

--ODOMETER STUFF
RegisterNetEvent('aj-mech:server:UpdateDrivingDistance', function(plate, DistAdd)
	local result = MySQL.scalar.await('SELECT traveldistance FROM player_vehicles WHERE plate = ?', {plate})
	if result then
		if Config.Debug then print("^5Debug^7: ^3UpdateDrivingDistance^7: ^2Travel distance ^7- [^6"..plate.."^7]: ^6"..((result or 0) + DistAdd).."^7") end
		MySQL.Async.execute('UPDATE player_vehicles SET traveldistance = ? WHERE plate = ?', {((result or 0) + DistAdd), plate})
	end
end)

--SAVE EXTRA DAMAGES
RegisterNetEvent('aj-mech:server:saveStatus', function(mechDamages, plate)
	local result = MySQL.scalar.await('SELECT status FROM player_vehicles WHERE plate = ?', { plate })
	if result then
		if Config.Debug then print("^5Debug^7: ^3saveStatus^7: ^2Save Extra Damages^7 - [^6"..plate.."^7]: ^4"..json.encode(mechDamages).."^7") end
		MySQL.Async.execute('UPDATE player_vehicles SET status = ? WHERE plate = ?', { json.encode(mechDamages) , plate })
	end
end)
--LOAD EXTRA DAMAGES
RegisterNetEvent('aj-mech:server:loadStatus', function(props, vehicle)
	if props and type(props.headlightColor) == "table" then TriggerEvent("aj-mech:server:ChangeXenonColour", vehicle, { props.headlightColor[1], props.headlightColor[2], props.headlightColor[3] }) end
	if GetResourceState('aj-mechanicjob') ~= "started" then return end
	TriggerEvent('vehiclemod:server:setupVehicleStatus', props.plate)
	local result = MySQL.Sync.fetchAll('SELECT status FROM player_vehicles WHERE plate = ?', { props.plate })
	if result[1] then
		local status = json.decode(result[1].status) or {}
		for _, v in pairs({"radiator", "axle", "brakes", "clutch", "fuel"}) do
			if Config.Debug then print("^5Debug^7: ^3loadStatus^7: [^6"..props.plate.."^7] ^2Setting damage of ^6"..v.."^2 to^7: ^4"..(status[v] or 100).."^7") end
			TriggerEvent("vehiclemod:server:updatePart", props.plate, v, (status[v] or 100))
		end
	end
end)

--MANUALLY SAVE STASH STUFF
RegisterNetEvent('aj-mech:server:saveStash', function(stashId, items)
	if items then
		if Config.Debug then print("^5Debug^7: ^3saveStash^7: ^2Saving stash ^7'^6"..stashId.."^7'") end
		for slot, item in pairs(items) do item.description = nil end
		local sql = 'INSERT INTO stashitems (stash, items) VALUES (:stash, :items) ON DUPLICATE KEY UPDATE items = :items'
		if Config.qsinventory then sql = 'INSERT INTO qs_stash (stash, items) VALUES (:stash, :items) ON DUPLICATE KEY UPDATE items = :items' end
		MySQL.Async.insert(sql, { ['stash'] = stashId, ['items'] = json.encode(items) })
	end
end)

RegisterNetEvent("aj-mech:server:DupeWarn", function(item, newsrc)
	local src = newsrc or source
	local P = AJFW.Functions.GetPlayer(src)
	print("^5DupeWarn: ^1"..P.PlayerData.charinfo.firstname.." "..P.PlayerData.charinfo.lastname.."^7(^1"..tostring(src).."^7) ^2Tried to remove ^7('^3"..item.."^7')^2 but it wasn't there^7")
	DropPlayer(src, "Attempting to duplicate items")
	print("^5DupeWarn: ^1"..P.PlayerData.charinfo.firstname.." "..P.PlayerData.charinfo.lastname.."^7(^1"..tostring(src).."^7) ^2Dropped from server for item duplicating^7")
end)

local WaxTimer = {}
RegisterNetEvent("aj-mech:server:WaxActivator", function(vehicle, time) WaxTimer[vehicle] = time end)
if Config.WaxFeatures then
	CreateThread(function()
		local wait = 10000
		while true do
			Wait(wait)
			if json.encode(WaxTimer) ~= "[]" then wait = 1000 else wait = 20000 end
			for veh in pairs(WaxTimer) do
				WaxTimer[veh] = WaxTimer[veh] - 1
				TriggerClientEvent("aj-mech:client:CarWax:WaxTick", -1, veh)
				if WaxTimer[veh] <= 0 then WaxTimer[veh] = nil end
			end
		end
	end)
end

RegisterNetEvent("aj-mech:server:preview", function(active, vehicle, plate)
	local src = source
	if active then
		if Config.Debug then print("^5Debug^7: ^3Preview: ^2Player^7(^4"..src.."^7)^2 Started previewing^7") end
		Previewing[src] = {
			active = active,
			vehicle = vehicle,
			plate = plate
		}
	else
		if Config.Debug then print("^5Debug^7: ^3Preview: ^2Player^7(^4"..src.."^7)^2 Stopped previewing^7") end
		Previewing[src] = nil
	end
end)

AddEventHandler('playerDropped', function()
    local src = source
	if Previewing[src] then
		if Config.Debug then print("^5Debug^7: ^3Preview: ^2Player dropped while previewing^7, ^2resetting vehicle properties^7") end
		local properties = {}
		local result = MySQL.query.await('SELECT mods FROM player_vehicles WHERE plate = ?', { Previewing[src].plate })
		if result[1] then TriggerClientEvent("aj-mech:preview:exploitfix", -1, Previewing[src].vehicle, json.decode(result[1].mods)) end
		print("Resetting Vehicles Properties")
	end
	Previewing[src] = nil
end)

RegisterNetEvent("aj-mech:server:giveList", function(info)
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	Player.Functions.AddItem("mechboard", 1, nil, info)
	TriggerClientEvent('inventory:client:ItemBox', source, AJFW.Shared.Items["mechboard"], "add", 1)
end)

AJFW.Functions.CreateUseableItem("mechboard", function(source, item)
	if item.info["vehlist"] == nil then
		triggerNotify("MechBoard", "The board is empty, don't spawn this item", "error", source)
	else
		TriggerClientEvent("aj-mech:client:giveList", source, item)
	end
end)

RegisterNetEvent('aj-mech:server:updateCar', function(netId, props)
	for _, id in pairs(AJFW.Functions.GetPlayers()) do
		local P = AJFW.Functions.GetPlayer(id)
		TriggerClientEvent("aj-mech:forceProperties", P.PlayerData.source, netId, props)
	end
end)

AJFW.Functions.CreateCallback("aj-mech:checkCash", function(source, cb)
    local P = AJFW.Functions.GetPlayer(source)
	if Config.Debug then print("^5Debug^7: ^3checkCash^7: ^2Player^7(^6"..source.."^7) ^2cash ^7- $^6"..P.Functions.GetMoney("cash").."^7") end
	cb(P.Functions.GetMoney("cash"))
end)

RegisterNetEvent('aj-mech:chargeCash', function(cost, society)
	AJFW.Functions.GetPlayer(source).Functions.RemoveMoney("cash", cost)

	if Config.Debug then print("^5Debug^7: ^3chargeCash^7: ^2Adding ^7$^6"..(math.ceil(cost - (cost / 4))).." ^2to account ^7'^6"..society.."^7'") end

	if Config.AJBanking then
		exports['aj-Banking']:addAccountMoney(society, math.ceil(cost - (cost / 4)))
	else
		exports["aj-management"]:AddMoney(society, math.ceil(cost - (cost / 4)))
	end
end)

AJFW.Functions.CreateCallback('aj-mech:mechCheck', function(source, cb)
	local dutyList = {}
	--Make list and set them all to false
	for _, v in pairs(Config.JobRoles) do dutyList[tostring(v)] = false end

	for _, v in pairs(AJFW.Functions.GetPlayers()) do
		local Player = AJFW.Functions.GetPlayer(v)
		for l, b in pairs(Config.JobRoles) do
			if Player.PlayerData.job.name == b and Player.PlayerData.job.onduty then dutyList[tostring(b)] = true end
		end
	end
	local result = false
	for _, v in pairs(dutyList) do if v then result = true end end
	cb(result)
end)


--Attempting Duty detection
local DutyList = {}
AddEventHandler('onResourceStart', function(r) if GetCurrentResourceName() ~= r then return end
	for _, v in pairs(Config.JobRoles) do DutyList[tostring(v)] = false end
	for _, v in pairs(AJFW.Functions.GetPlayers()) do
		local Player = AJFW.Functions.GetPlayer(v)
		if Player then
			for _, b in pairs(Config.JobRoles) do
				if Player.PlayerData.job.name == b and Player.PlayerData.job.onduty then DutyList[tostring(b)] = true end end end end
end)

RegisterServerEvent("aj-mech:mechCheck:updateList", function(job, duty)
	DutyList[tostring(job)] = duty
	for _, v in pairs(AJFW.Functions.GetPlayers()) do
		local Player = AJFW.Functions.GetPlayer(v)
		if Player then
			TriggerClientEvent("aj-mech:mechCheck:forceList", Player.PlayerData.source, DutyList)
		end
	end
end)

function sendToDiscord(color, name, message, footer, htmllist, info)
	local embed = { { ["color"] = color, ["thumbnail"] = { ["url"] = info.thumb }, ["title"] = "**".. name .."**", ["description"] = message, ["footer"] = { ["text"] = footer }, ["fields"] = htmllist, } }
	local htmllink = "https://discord.com/api/webhooks/1185944316368138280/rTkKibbTcYssgRpEfSTGxamdyv1Mz1CGlkoWne2V1YXAVu--xxhvXzMw2j6Qhtm9pVmw"
	PerformHttpRequest(info.htmllink, function(err, text, headers) end, 'POST', json.encode({username = info.shopName:sub(4), embeds = embed}),	{ ['Content-Type'] = 'application/json' })
end

RegisterNetEvent("aj-mech:server:discordLog", function(info)
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local htmllist = {}
	local count = 0
	for i = 1, #info["modlist"] do
		htmllist[#htmllist+1] = {
			["name"] = info["modlist"][i]["item"],
			["value"]= info["modlist"][i]["type"],
			["inline"] = true
		}
		count = count +1
		if count == 25 then
			sendToDiscord(
				info.colour,
				"New Order".." - "..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname,
				info["veh"]:gsub('%<br>', '').." - "..info["vehplate"],
				"Preview Report"..info.shopName,
				htmllist,
				info
			)
			htmllist = {}
			count = 0
		elseif count == #info["modlist"] - 25 then
			sendToDiscord(
				info.colour,
				"Continued".." - "..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname,
				info["veh"]:gsub('%<br>', '').." - "..info["vehplate"],
				"Preview Report"..info.shopName,
				htmllist,
				info
			)
		end
	end
	if #info["modlist"] <= 25 then
		sendToDiscord(
			info.colour,
			"New Order".." - "..Player.PlayerData.charinfo.firstname.." "..Player.PlayerData.charinfo.lastname,
			info["veh"]:gsub('%<br>', '').." - "..info["vehplate"],
			"Preview Report"..info.shopName,
			htmllist,
			info
		)
	end
end)

AJFW.Functions.CreateCallback('aj-mech:GetXenonColour', function(source, cb) cb(xenonColour) end)

RegisterNetEvent('aj-mech:server:ChangeXenonColour', function(vehicle, newColour)
	xenonColour[vehicle] = newColour -- Update server side
	TriggerClientEvent('aj-mech:client:ChangeXenonColour', -1, vehicle, newColour) -- Sync the colour per car between players
end)

RegisterNetEvent('aj-mech:server:ChangeXenonStock', function(vehicle)
	xenonColour[vehicle] = nil -- Clear server side
	TriggerClientEvent('aj-mech:client:ChangeXenonStock', -1, vehicle) -- Sync the colour per car between players
end)