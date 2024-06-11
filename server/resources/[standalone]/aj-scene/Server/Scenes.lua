
AJFW = exports['aj-base']:GetCoreObject()


Scenes = {
	Current = {},
	Cooldowns = {}
}

Admins = {
	"discord:773265257153429566",
	"steam:11000010c5c1b97",
}

function CloseToOtherScene(t)
	local Nearby = false
	for k,v in pairs(Scenes.Current) do
		local Dis = Distance(t.Location, v.Location)
		if Dis < 0.2 then Nearby = true end
	end 
	return Nearby
end

function CountScenes(id)
	local Count = 0
	for k,v in pairs(Scenes.Current) do
		if v.Owner == id then Count = Count + 1 end 
	end
	return Count
end

CreateThread(function()
	while true do Wait(1000)
		for k,v in pairs(Scenes.Cooldowns) do
			Scenes.Cooldowns[k] = Scenes.Cooldowns[k] -1
			if Scenes.Cooldowns[k] < 0 then Scenes.Cooldowns[k] = nil end
		end
	end
end)

CreateThread(function()
	Wait(100)
	DB.GrabAll()
	while true do
		TriggerClientEvent("Scene:Cache", -1, {Time = os.time()})
		DB.Timecheck()
		Wait(10000)
	end
end)

RegisterCommand("scene", function(Src, Arguments)
	local Player = AJFW.Functions.GetPlayer(Src)
	if Player.PlayerData.job.name == "contractor" or (Player.PlayerData.job.name == "mechanic" and Player.PlayerData.job.grade.level >= 4) or (Player.PlayerData.job.name == "pdm" and Player.PlayerData.job.grade.level >= 5) or (Player.PlayerData.job.name == "realestate" and Player.PlayerData.job.grade.level == 0 and Player.PlayerData.job.grade.level == 1) or (Player.PlayerData.job.name == "doctor" and Player.PlayerData.job.grade.level >= 8) or (Player.PlayerData.job.name == "mcd" and Player.PlayerData.job.grade.level >= 2) or (Player.PlayerData.job.name == "coffee" and Player.PlayerData.job.grade.level >= 2) or (Player.PlayerData.job.name == "shopone" and Player.PlayerData.job.grade.level >= 1)then 
		if not Scenes.Cooldowns[Src] then
			Scenes.Cooldowns[Src] = 1
			local Input = table.concat(Arguments, " ") local Length = string.len(Input)
			if Length <= 280 and Length > 3 then
				TriggerClientEvent("Scene:Create", Src, Input)
			else
				Chat(Src, Lang("InvalidText"))
			end
		else
			Chat(Src, Lang("CantRightNow"))
		end
	else
		Chat(Src, Lang("NoPerms2"))
	end
end)


RegisterCommand("scenestats", function(Src, Arguments)
	local TotalSceneCount = 0 for k,v in pairs(Scenes.Current) do TotalSceneCount = TotalSceneCount +1 end
	local Formatted = "Active Scenes : "..TotalSceneCount.."x"
	Chat(Src, Formatted)
end)

RegisterNetEvent("Scene:Request")
AddEventHandler("Scene:Request", function()
	local Src = source
	TriggerClientEvent("Scene:RecieveAll", Src, Scenes.Current)
	TriggerClientEvent("Scene:Cache", Src, { Time = os.time() })
end)