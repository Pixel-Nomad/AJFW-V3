local AJFW = exports['aj-base']:GetCoreObject()

CreateThread(function()
	for i, v in pairs(AJFW.Shared.Vehicles) do
		local text
		if v["brand"] then
			text = v["brand"] .. " " .. v["name"]
		else
			text = v["name"]
		end
		if v.tier then
			text = text .. " (".. v.tier..")"
		end
		if v['hash'] ~= 0 and v['hash'] ~= nil then
			AddTextEntryByHash(v["hash"],text)
		end
	end
end)