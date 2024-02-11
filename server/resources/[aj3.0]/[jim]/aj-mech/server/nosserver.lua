local AJFW = exports['aj-base']:GetCoreObject()
RegisterNetEvent('AJFW:Server:UpdateObject', function() if source ~= '' then return false end AJFW = exports['aj-base']:GetCoreObject() end)

local VehicleNitrous = { }
local nosColour = { }

AddEventHandler('onResourceStart', function(resource) if GetCurrentResourceName() ~= resource then return end
	TriggerEvent("aj-mech:GetNosUpdate")
	TriggerEvent("aj-mech:GetNosColourUpdate")
end)

--These events sync the VehicleNitrous table with the server, making them able to be synced with the players
RegisterNetEvent('aj-mech:server:LoadNitrous', function(Plate)
	VehicleNitrous[Plate] = { hasnitro = 1, level = 100 }
	TriggerClientEvent('aj-mech:client:LoadNitrous',-1, Plate)
	TriggerEvent('aj-mech:database:LoadNitro', Plate)
end)

RegisterNetEvent('aj-mech:server:UnloadNitrous', function(Plate)
	VehicleNitrous[Plate] = nil
	TriggerClientEvent('aj-mech:client:UnloadNitrous', -1, Plate)
	TriggerEvent('aj-mech:database:UnloadNitro', Plate)
end)

RegisterNetEvent('aj-mech:server:UpdateNitroLevel', function(Plate, level)
	VehicleNitrous[Plate] = { hasnitro = 1, level = level }
	TriggerClientEvent('aj-mech:client:UpdateNitroLevel', -1, Plate, level)
end)

--Event called on script start to grab Database info about nos
RegisterNetEvent("aj-mech:GetNosUpdate", function()
	local result = MySQL.Sync.fetchAll('SELECT * FROM player_vehicles WHERE hasnitro = ?', {1})
	if result and result[1] then
		for _, v in pairs(result) do
			if Config.Debug then print("^5Debug^7: ^3GetNosUpdate^7: ^2VehicleNitrous^7[^6"..tostring(v["plate"]).."^7] = { ^2level ^7= ^6"..tonumber(v["noslevel"]).."^7, ^2hasnitro ^7= ^6"..tostring(v["hasnitro"]).."^7 }") end
			VehicleNitrous[v["plate"]] = { hasnitro = v["hasnitro"], level = tonumber(v["noslevel"]), }
		end
		if Config.Debug then print("^5Debug^7: ^3GetNosUpdate^7: ^2VehicleNitrous Results Found^7: ^6"..#result.."^7") end
	else if Config.Debug then print("^5Debug^7: ^3GetNosUpdate^7: ^2Checked Database and found no vehicles with NOS^7") end end
end)

--Callback to send Database info to Client
AJFW.Functions.CreateCallback('aj-mech:GetNosLoaded', function(source, cb) cb(VehicleNitrous) end)

--Database interactions
RegisterNetEvent('aj-mech:database:LoadNitro', function(Plate) MySQL.Async.execute('UPDATE player_vehicles SET noslevel = ?, hasnitro = ? WHERE plate = ?', {100, true, Plate}) end)
RegisterNetEvent('aj-mech:database:UnloadNitro', function(plate) MySQL.Async.execute('UPDATE player_vehicles SET noslevel = ?, hasnitro = ? WHERE plate = ?', {0, false, plate}) end)
RegisterNetEvent('aj-mech:database:UpdateNitroLevel', function(plate, level)
	if Config.Debug then print("^5Debug^7: ^2Database ^6noslevel^2 updated "..plate.." "..level.."^7") end
	MySQL.Async.execute('UPDATE player_vehicles SET noslevel = ? WHERE plate = ?', {level, plate})
end)

--Syncing stuff
RegisterNetEvent('aj-mech:server:SyncPurge', function(netId, enabled, size) TriggerClientEvent('aj-mech:client:SyncPurge', -1, netId, enabled, size) end)
RegisterNetEvent('aj-mech:server:SyncTrail', function(netId, enabled) TriggerClientEvent('aj-mech:client:SyncTrail', -1, netId, enabled) end)
RegisterNetEvent('aj-mech:server:SyncFlame', function(netId, scale) TriggerClientEvent('aj-mech:client:SyncFlame', -1, netId, scale) end)

AJFW.Functions.CreateUseableItem("noscolour", function(source, item) TriggerClientEvent("aj-mech:client:NOS:rgbORhex", source) end)

--Event called on script start to grab Database info about nos
RegisterNetEvent("aj-mech:GetNosColourUpdate", function()
	local result = MySQL.Sync.fetchAll("SELECT `nosColour`, `plate` FROM `player_vehicles` WHERE 1")
	if result and result[1] then
		for _, v in pairs(result) do
			if v["nosColour"] then
				json.decode(v["nosColour"])
				local newColour = json.decode(v["nosColour"])
				if Config.Debug then print("^5Debug^7: ^3nosColour^7[^6"..tostring(v["plate"]).."^7] = { ^2RBG^7: ^6"..newColour[1].."^7, ^6"..newColour[2].."^7, ^6"..newColour[3].." ^7}") end
				nosColour[v["plate"]] = newColour
			end
		end
	end
end)

--Callback to send Database info to Client
AJFW.Functions.CreateCallback('aj-mech:GetNosColour', function(source, cb) cb(nosColour) end)

-- This event is to make it so every car's purge colour is synced
-- If you change the colour of the purge on a car, everyone who gets in THAT car will spray this colour
RegisterNetEvent('aj-mech:server:ChangeColour', function(Plate, newColour)
	nosColour[Plate] = newColour -- Update server side
	TriggerClientEvent('aj-mech:client:ChangeColour', -1, Plate, newColour) -- Sync the colour per car between players
	TriggerEvent('aj-mech:database:ChangeColour', Plate, newColour) -- Update Database with new colour
end)

RegisterNetEvent('aj-mech:database:ChangeColour', function(plate, newColour)
	if Config.Debug then print("Update Purge Colour") end
	MySQL.Async.execute('UPDATE player_vehicles SET nosColour = ? WHERE plate = ?', { json.encode(newColour), plate })
end)