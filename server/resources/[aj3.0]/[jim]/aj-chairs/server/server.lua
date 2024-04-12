local AJFW = exports[Config.Core]:GetCoreObject()
RegisterNetEvent('AJFW:Server:UpdateObject', function() if source ~= '' then return false end AJFW = exports[Config.Core]:GetCoreObject() end)

CreateThread(function()
	if Config.Inv == "ox" then for k, v in pairs(Config.Stores) do exports['aj-inventory']:RegisterShop("ChairStore"..k, { name = v.label, inventory = v.items}) end end
	for i=1, 110, 1 do
		if AJFW.Shared.Items["chair"..i] then	AJFW.Functions.CreateUseableItem("chair"..i, function(source, item) TriggerClientEvent('aj-chairs:Use', source, i) end) end
	end
end)
local function CheckVersion()
	PerformHttpRequest('https://raw.githubusercontent.com/jimathy/jim-chairs/master/version.txt', function(err, newestVersion, headers)
		local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
		if not newestVersion then print("Currently unable to run a version check.") return end
		local advice = "^1You are currently running an outdated version^7, ^1please update"
		if newestVersion:gsub("%s+", "") == currentVersion:gsub("%s+", "") then advice = '^6You are running the latest version.'
		else print("^3Version Check^7: ^2Current^7: "..currentVersion.." ^2Latest^7: "..newestVersion) end
		print(advice)
	end)
end
CheckVersion()