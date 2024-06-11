local AJFW = exports['aj-base']:GetCoreObject()

PlayerJob = {}
local onDuty = false
local alcoholCount = 0

local function installCheck()
	local items = { "bmochi", "pmochi", "gmochi", "omochi", "bobatea", "bbobatea", "gbobatea", "obobatea", "nekolatte", "sake",
					"miso", "cake", "bento", "riceball", "nekocookie", "nekodonut", "boba", "flour", "rice", "sugar", "nori", "blueberry", "strawberry",
					"orange", "mint", "tofu", "mocha", "cakepop", "pancake", "pizza", "purrito", "noodlebowl", "noodles", "ramen", "milk", "onion", "sodiumchloride", "salt", "water_bottle" }
	for k, v in pairs(items) do if AJFW.Shared.Items[v] == nil then print("Missing Item from AJFW.Shared.Items: '"..v.."'") end end
	if AJFW.Shared.Jobs["catcafe"] == nil then print("Error: Job role not found - 'catcafe'") end
	if Config.Debug then print((#Config.Chairs).." Total seating locations") print((#items).." Items required") end
end

local function jobCheck()
	canDo = true
	if not onDuty then TriggerEvent('AJFW:Notify', "Not clocked in!", 'error') canDo = false end
	return canDo
end

RegisterNetEvent('AJFW:Client:OnPlayerLoaded')
AddEventHandler('AJFW:Client:OnPlayerLoaded', function()
    AJFW.Functions.GetPlayerData(function(PlayerData)
		installCheck()
        PlayerJob = PlayerData.job
        if PlayerData.job.onduty then if PlayerData.job.name == "catcafe" then TriggerServerEvent("AJFW:ToggleDuty") end end
    end)
end)
RegisterNetEvent('AJFW:Client:OnJobUpdate') AddEventHandler('AJFW:Client:OnJobUpdate', function(JobInfo) PlayerJob = JobInfo onDuty = PlayerJob.onduty end) 
RegisterNetEvent('AJFW:Client:SetDuty') AddEventHandler('AJFW:Client:SetDuty', function(duty) onDuty = duty end)

AddEventHandler('onResourceStart', function(resource)
	installCheck()
    if GetCurrentResourceName() == resource then
		AJFW.Functions.GetPlayerData(function(PlayerData)
			PlayerJob = PlayerData.job
			if PlayerData.job.name == "catcafe" then onDuty = PlayerJob.onduty end 
		end)
    end
end)

CreateThread(function()
	local bossroles = {}
	for k, v in pairs(AJFW.Shared.Jobs["catcafe"].grades) do
		if AJFW.Shared.Jobs["catcafe"].grades[k].isboss == true then
			if bossroles["catcafe"] ~= nil then
				if bossroles["catcafe"] > tonumber(k) then bossroles["catcafe"] = tonumber(k) end
			else bossroles["catcafe"] = tonumber(k)	end
		end
	end
	for k, v in pairs(Config.Locations) do
		if Config.Locations[k].zoneEnable then
			JobLocation = PolyZone:Create(Config.Locations[k].zones, { name = Config.Locations[k].label, debugPoly = Config.Debug })
			JobLocation:onPlayerInOut(function(isPointInside) if not isPointInside and onDuty and PlayerJob.name == "catcafe" then TriggerServerEvent("AJFW:ToggleDuty") end end)	
		end
	end
	for k, v in pairs(Config.Locations) do
		-- if Config.Locations[k].zoneEnable then
			blip = AddBlipForCoord(Config.Locations[k].blip)	
			SetBlipAsShortRange(blip, true)
			SetBlipSprite(blip, 89)
			SetBlipColour(blip, Config.Locations[k].blipcolor)
			SetBlipScale(blip, 0.7)
			SetBlipDisplay(blip, 6)
			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString("CatCafe")
			EndTextCommandSetBlipName(blip)
		-- end
	end
	--Stashes
	exports['aj-target']:AddBoxZone("CatPrepared", vector3(-587.4, -1059.6, 23.45), 2.0, 2.5, { name="CatPrepared", heading = 270.0, debugPoly=Config.Debug, minZ=21.45, maxZ=23.45 }, 
		{ options = { {  event = "jim-catcafe:Stash2", icon = "fas fa-box-open", label = "Prepared Food", stash = "Shelf" }, },  distance = 2.0 })
	--FRIDGE
	exports['aj-target']:AddBoxZone("CatFridge", vector3(-588.06, -1067.1, 22.34), 3.5, 0.5, { name="CatFridge", heading = 0, debugPoly=Config.Debug, minZ=19.84, maxZ=23.84 }, 
		{ options = { {  event = "jim-catcafe:Stash3", icon = "fas fa-temperature-low", label = "Open Storage", stash = "Fridge", job = "catcafe" }, }, distance = 1.0 })		
	exports['aj-target']:AddBoxZone("CatFridge2", vector3(-590.67, -1068.1, 22.34), 2.0, 0.6, { name="CatFridge2", heading = 0, debugPoly=Config.Debug, minZ=19.84, maxZ=23.84 }, 
		{ options = { {  event = "jim-catcafe:Stash3", icon = "fas fa-temperature-low", label = "Open Storage", stash = "Fridge2", job = "catcafe"  }, }, distance = 1.0 })
	--WARESTORAGE
	exports['aj-target']:AddBoxZone("CatStorage", vector3(-598.0, -1068.47, 22.34), 4.0, 1.5, { name="CatStorage", heading = 90, debugPoly=Config.Debug, minZ=20.94, maxZ=24.94 }, 
		{ options = { {  event = "jim-catcafe:Shop", icon = "fas fa-box-open", label = "Open Store", job = "catcafe" }, }, distance = 2.0 })
	exports['aj-target']:AddBoxZone("CatStorage2", vector3(-598.25, -1065.61, 22.34), 4.0, 1.5, { name="CatStorage2", heading = 90, debugPoly=Config.Debug, minZ=20.94, maxZ=24.94 }, 
		{ options = { {  event = "jim-catcafe:Shop", icon = "fas fa-box-open", label = "Open Store", job = "catcafe" }, }, distance = 2.0 })
	exports['aj-target']:AddBoxZone("CatStorage3", vector3(-598.31, -1062.79, 22.34), 4.0, 1.5, { name="CatStorage3", heading = 90, debugPoly=Config.Debug, minZ=20.94, maxZ=24.94 }, 
		{ options = { {  event = "jim-catcafe:Shop", icon = "fas fa-box-open", label = "Open Store", job = "catcafe" }, }, distance = 2.0 })
	--Sinks
	exports['aj-target']:AddBoxZone("CatWash1", vector3(-587.89, -1062.58, 22.36), 0.7, 0.7, { name="CatWash1", heading = 0, debugPoly=Config.Debug, minZ=19.11, maxZ=23.11 }, 
		{ options = { { event = "jim-catcafe:washHands", icon = "fas fa-hand-holding-water", label = "Wash Your Hands" }, }, distance = 1.5	})		
	exports['aj-target']:AddBoxZone("CatWash2", vector3(-570.23, -1051.41, 22.34), 0.5, 0.5, { name="CatWash2", heading = 0, debugPoly=Config.Debug, minZ=21.74, maxZ=22.94, }, 
		{ options = { { event = "jim-catcafe:washHands", icon = "fas fa-hand-holding-water", label = "Wash Your Hands" }, }, distance = 1.2	})		
	exports['aj-target']:AddBoxZone("CatWash3", vector3(-570.25, -1056.98, 22.34), 0.5, 0.5, { name="CatWash3", heading = 0, debugPoly=Config.Debug, minZ=21.74, maxZ=22.94, },
		{ options = { { event = "jim-catcafe:washHands", icon = "fas fa-hand-holding-water", label = "Wash Your Hands" }, }, distance = 1.2 })
	--Oven
	exports['aj-target']:AddBoxZone("CatOven", vector3(-590.66, -1059.13, 22.34), 2.5, 0.6, { name="CatOven", heading = 0, debugPoly=Config.Debug, minZ = 19.84, maxZ = 23.84, }, 
		{ options = { { event = "jim-catcafe:Menu:Oven", icon = "fas fa-temperature-high", label = "Use Oven", job = "catcafe" }, }, distance = 2.0 })
	--Hob
	exports['aj-target']:AddBoxZone("CatHob", vector3(-591.02, -1056.56, 22.36), 1.5, 0.6, { name="CatHob", heading = 0, debugPoly=Config.Debug, minZ = 19.84, maxZ = 23.84, }, 
		{ options = { { event = "jim-catcafe:Menu:Hob", icon = "fas fa-temperature-high", label = "Use Hob", job = "catcafe" }, }, distance = 2.0 })
	--Trays
	exports['aj-target']:AddBoxZone("CatCounter", vector3(-584.01, -1059.27, 22.34), 0.6, 0.6, { name="CatCounter", heading = 0, debugPoly=Config.Debug, minZ=19.04, maxZ=23.04 }, 
		{ options = { { event = "jim-catcafe:Stash", icon = "fas fa-hamburger", label = "Open Counter", stash = "Counter" }, }, distance = 2.0	})	
	exports['aj-target']:AddBoxZone("CatCounter2", vector3(-584.04, -1062.05, 22.34), 0.6, 0.6, { name="CatCounter2", heading = 0, debugPoly=Config.Debug, minZ=19.04, maxZ=23.04 }, 
		{ options = { { event = "jim-catcafe:Stash", icon = "fas fa-hamburger", label = "Open Counter", stash = "Counter2" }, }, distance = 2.0	})
	--Payments
	--Coffee
	exports['aj-target']:AddBoxZone("CatCoffee", vector3(-586.8, -1061.89, 22.34), 0.7, 0.5, { name="CatCoffee", heading = 0, debugPoly=Config.Debug, minZ=21.99, maxZ=23.19 }, 
		{ options = { { event = "jim-catcafe:Menu:Coffee", icon = "fas fa-mug-hot", label = "Pour Coffee", job = "catcafe" }, }, distance = 2.0 })
	--Mixer
	exports['aj-target']:AddBoxZone("CatMixer", vector3(-591.0, -1064.11, 22.34), 0.3, 0.5, { name="CatMixer", heading = 0, debugPoly=Config.Debug, minZ=22.00, maxZ=22.80 }, 
		{ options = { { event = "jim-catcafe:Menu:Mixer", icon = "fas fa-blender", label = "Mixer", job = "catcafe" }, }, distance = 2.0 })
	--Chopping Board
	exports['aj-target']:AddBoxZone("CatBoard", vector3(-590.94, -1063.16, 22.36), 1.5, 0.6, { name="CatBoard", heading = 0, debugPoly=Config.Debug, minZ=18.96, maxZ=22.96, }, 
		{ options = { { event = "jim-catcafe:Menu:ChoppingBoard", icon = "fas fa-utensils", label = "Prepare Food", job = "catcafe" }, }, distance = 2.0 })	
	--Tables
	exports['aj-target']:AddBoxZone("CatTable", vector3(-573.43, -1059.76, 22.49), 1.9, 1.0, { name="CatTable", heading = 91.0, debugPoly=Config.Debug, minZ=21.49, maxZ=22.89 }, 
		{ options = { {  event = "jim-catcafe:Stash", icon = "fas fa-box-open", label = "Search Table", stash = "Table_1" }, }, distance = 2.0 })
	exports['aj-target']:AddBoxZone("CatTable2", vector3(-573.44, -1063.45, 22.34), 1.9, 1.0, { name="CatTable2", heading = 91.0, debugPoly=Config.Debug, minZ=21.49, maxZ=22.89 }, 
		{ options = { {  event = "jim-catcafe:Stash", icon = "fas fa-box-open", label = "Search Table", stash = "Table_2" }, }, distance = 2.0 })
	exports['aj-target']:AddBoxZone("CatTable3", vector3(-573.41, -1067.09, 22.49), 1.9, 1.0, { name="CatTable3", heading = 91.0, debugPoly=Config.Debug, minZ=21.49, maxZ=22.89 }, 
		{ options = { {  event = "jim-catcafe:Stash", icon = "fas fa-box-open", label = "Search Table", stash = "Table_3" }, }, distance = 2.0 })
	exports['aj-target']:AddBoxZone("CatTable4", vector3(-578.68, -1051.09, 22.35), 1.2, 0.9, { name="CatTable4", heading = 91.0, debugPoly=Config.Debug, minZ=21.49, maxZ=22.89 }, 
		{ options = { {  event = "jim-catcafe:Stash", icon = "fas fa-box-open", label = "Search Table", stash = "Table_4" }, }, distance = 2.0 })	
	--Clockin
	exports['aj-target']:AddBoxZone("CatClockin", vector3(-594.34, -1053.35, 22.34), 3.5, 0.5, { name="CatClockin", heading = 0, debugPoly=Config.Debug, minZ=22.19, maxZ=23.79 }, 
		{ options = { { type = "server", event = "AJFW:ToggleDuty", icon = "fas fa-user-check", label = "Toggle Duty", job = "catcafe" },
					  --{ event = "qb-bossmenu:client:OpenMenu", icon = "fas fa-clipboard-check", label = "Open Bossmenu", job = bossroles, }, 
					}, distance = 2.0 })
end)

RegisterNetEvent('jim-catcafe:washHands', function()
    AJFW.Functions.Progressbar('washing_hands', 'Washing hands','blue', 5000, false, false, { disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, },
	{ animDict = "mp_arresting", anim = "a_uncuff", flags = 8, }, {}, {}, function()
		TriggerEvent('AJFW:Notify', "You've washed your hands!", 'success')
    end, function() -- Cancel
        TriggerEvent('inventory:client:busy:status', false)
		TriggerEvent('AJFW:Notify', "Cancelled", 'error')
    end)
end)

RegisterNetEvent('jim-catcafe:MakeItem', function(data)
	if data.craftable then
		for k, v in pairs(data.craftable[data.tablenumber]) do
			AJFW.Functions.TriggerCallback('jim-catcafe:get', function(amount)
				if not amount then TriggerEvent('AJFW:Notify', "You don't have the correct ingredients", 'error') else TriggerEvent("jim-catcafe:FoodProgress", data) end		
			end, data.item, data.tablenumber, data.craftable)
		end
	end
end)

-- RegisterNetEvent('jim-catcafe:Stash', function(data) TriggerServerEvent("inventory:server:OpenInventory", "stash", "CatCafe_"..data.stash) TriggerEvent("inventory:client:SetCurrentStash", "CatCafe_"..data.stash) end)

RegisterNetEvent('jim-catcafe:Stash3')
AddEventHandler('jim-catcafe:Stash3',function(data)
	id = data.stash
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "CatCafe_"..id,
	{
        maxweight = 4000000,
        slots = 200,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "CatCafe_"..id)
end)

RegisterNetEvent('jim-catcafe:Stash2')
AddEventHandler('jim-catcafe:Stash2',function(data)
	id = data.stash
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "CatCafe_"..id)
    TriggerEvent("inventory:client:SetCurrentStash", "CatCafe_"..id)
end)

RegisterNetEvent('jim-catcafe:Stash')
AddEventHandler('jim-catcafe:Stash',function(data)
	id = data.stash
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "CatCafe_"..id,
	{
        maxweight = 200000,
        slots = 25,
    })
    TriggerEvent("inventory:client:SetCurrentStash", "CatCafe_"..id)
end)

RegisterNetEvent('jim-catcafe:Shop', function() if not jobCheck() then return else TriggerServerEvent("inventory:server:OpenInventory", "shop", "catcafe", Config.Items) end end)

RegisterNetEvent('jim-catcafe:FoodProgress', function(data)
	AJFW.Functions.Progressbar('making_food', data.bartext..AJFW.Shared.Items[data.item].label,'orange', data.time, false, false, {
		disableMovement = true, disableCarMovement = true, disableMouse = false, disableCombat = true, }, 
		{ animDict = data.animDict,	anim = data.anim, flags = 8, }, 
	{}, {}, function()  
		TriggerServerEvent('jim-catcafe:GetFood', data)
		StopAnimTask(GetPlayerPed(-1), data.animDict, data.anim, 1.0)
	end, function()
		TriggerEvent('inventory:client:busy:status', false)
		TriggerEvent('AJFW:Notify', "Cancelled!", 'error')
	end)
end)

RegisterNetEvent('jim-catcafe:Menu:ChoppingBoard', function()
	if not jobCheck() then return end
	local ChopMenu = {}
	ChopMenu[#ChopMenu + 1] = { header = "Chopping Board", txt = "", isMenuHeader = true }
		for i = 1, #Crafting.ChoppingBoard do
			for k, v in pairs(Crafting.ChoppingBoard[i]) do
				if k ~= "img" then
					local text = ""
					local setheader = AJFW.Shared.Items[k].label
					if Crafting.ChoppingBoard[i]["img"] ~= nil then setheader = Crafting.ChoppingBoard[i]["img"]..setheader end
					for l, b in pairs(Crafting.ChoppingBoard[i][tostring(k)]) do
						if b == 1 then number = "" else number = " x"..b end
						text = text.."- "..AJFW.Shared.Items[l].label..number.."<br>"
						if b == 0 then text = "" end
						settext = text
					end
					ChopMenu[#ChopMenu + 1] = { header = "<img src=nui://"..Config.link..AJFW.Shared.Items[k].image.." width=35px> "..setheader, txt = settext, 
												params = { event = "jim-catcafe:MakeItem", args = { item = k, tablenumber = i, craftable = Crafting.ChoppingBoard,
														   bartext = "Preparing a ", time = 7000, animDict = "anim@heists@prison_heiststation@cop_reactions", anim = "cop_b_idle" } } }
					settext, setheader = nil
				end
			end
		end
	exports['aj-menu']:openMenu(ChopMenu)
end)

RegisterNetEvent('jim-catcafe:Menu:Oven', function()
	if not jobCheck() then return end
	local OvenMenu = {}
	OvenMenu[#OvenMenu + 1] = { header = "Oven Menu", txt = "", isMenuHeader = true }
		for i = 1, #Crafting.Oven do
			for k, v in pairs(Crafting.Oven[i]) do
				if k ~= "img" then
					local text = ""
					local setheader = AJFW.Shared.Items[k].label
					if Crafting.Oven[i]["img"] ~= nil then setheader = Crafting.Oven[i]["img"]..setheader end
					for l, b in pairs(Crafting.Oven[i][tostring(k)]) do
						if b == 1 then number = "" else number = " x"..b end
						text = text.."- "..AJFW.Shared.Items[l].label..number.."<br>"
						if b == 0 then text = "" end
						settext = text
						end
					OvenMenu[#OvenMenu + 1] = { header = "<img src=nui://"..Config.link..AJFW.Shared.Items[k].image.." width=35px> "..setheader, txt = settext, 
												params = { event = "jim-catcafe:MakeItem", args = { item = k, tablenumber = i, craftable = Crafting.Oven,
														   bartext = "Preparing a ", time = 5000, animDict = "amb@prop_human_bbq@male@base", anim = "base" } } }
					settext, setheader = nil
				end
			end
		end
	exports['aj-menu']:openMenu(OvenMenu)
end)

RegisterNetEvent('jim-catcafe:Menu:Coffee', function()
	if not jobCheck() then return end
	local CoffeeMenu = {}
	CoffeeMenu[#CoffeeMenu + 1] = { header = "Coffee Menu", txt = "", isMenuHeader = true }
		for i = 1, #Crafting.Coffee do
			for k, v in pairs(Crafting.Coffee[i]) do
				if k ~= "img" then
					local text = ""
					local setheader = AJFW.Shared.Items[k].label
					if Crafting.Coffee[i]["img"] ~= nil then setheader = Crafting.Coffee[i]["img"]..setheader end
					for l, b in pairs(Crafting.Coffee[i][tostring(k)]) do
						if b == 1 then number = "" else number = " x"..b end
						text = text.."- "..AJFW.Shared.Items[l].label..number.."<br>"
						if b == 0 then text = "" end
						settext = text
						end
					CoffeeMenu[#CoffeeMenu + 1] = { header = "<img src=nui://"..Config.link..AJFW.Shared.Items[k].image.." width=35px> "..setheader, txt = settext, 
													params = { event = "jim-catcafe:MakeItem", args = { item = k, tablenumber = i, craftable = Crafting.Coffee,
															   bartext = "Pouring a ", time = 3000, animDict = "amb@prop_human_bum_shopping_cart@male@idle_a", anim = "idle_c", flags = 49 } } }
					settext, setheader = nil
				end
			end
		end
	exports['aj-menu']:openMenu(CoffeeMenu)
end)

RegisterNetEvent('jim-catcafe:Menu:Mixer', function()
	if not jobCheck() then return end
	local MixerMenu = {}
	MixerMenu[#MixerMenu + 1] = { header = "Mixer Menu", txt = "", isMenuHeader = true }
		for i = 1, #Crafting.Mixer do
			for k, v in pairs(Crafting.Mixer[i]) do
				if k ~= "img" then
					local text = ""
					local setheader = AJFW.Shared.Items[k].label
					if Crafting.Mixer[i]["img"] ~= nil then setheader = Crafting.Mixer[i]["img"]..setheader end
					for l, b in pairs(Crafting.Mixer[i][tostring(k)]) do
						if b == 1 then number = "" else number = " x"..b end
						text = text.."- "..AJFW.Shared.Items[l].label..number.."<br>"
						if b == 0 then text = "" end
						settext = text
						end
						MixerMenu[#MixerMenu + 1] = { header = "<img src=nui://"..Config.link..AJFW.Shared.Items[k].image.." width=35px> "..setheader, txt = settext, 
													params = { event = "jim-catcafe:MakeItem", args = { item = k, tablenumber = i, craftable = Crafting.Mixer,
															   bartext = "Mixing a ", time = 3000, animDict = "amb@prop_human_bum_shopping_cart@male@idle_a", anim = "idle_c", flags = 49 } } }
					settext, setheader = nil
				end
			end
		end
	exports['aj-menu']:openMenu(MixerMenu)
end)

RegisterNetEvent('jim-catcafe:Menu:Hob', function()
	if not jobCheck() then return end
	local HobMenu = {}
	HobMenu[#HobMenu + 1] = { header = "Hob Menu", txt = "", isMenuHeader = true }
		for i = 1, #Crafting.Hob do
			for k, v in pairs(Crafting.Hob[i]) do
				if k ~= "img" then
					local text = ""
					local setheader = AJFW.Shared.Items[k].label
					if Crafting.Hob[i]["img"] ~= nil then setheader = Crafting.Hob[i]["img"]..setheader end
					for l, b in pairs(Crafting.Hob[i][tostring(k)]) do
						if b == 1 then number = "" else number = " x"..b end
						text = text.."- "..AJFW.Shared.Items[l].label..number.."<br>"
						if b == 0 then text = "" end
						settext = text
						end
					HobMenu[#HobMenu + 1] = { header = "<img src=nui://"..Config.link..AJFW.Shared.Items[k].image.." width=35px> "..setheader, txt = settext, 
											  params = { event = "jim-catcafe:MakeItem", args = { item = k, tablenumber = i, craftable = Crafting.Hob,
														 bartext = "Preparing a ", time = 7000, animDict = "amb@prop_human_bbq@male@base", anim = "base" } } }
					settext, setheader = nil
				end
			end
		end
	exports['aj-menu']:openMenu(HobMenu)
end)


RegisterNetEvent('jim-catcafe:client:DrinkAlcohol', function(itemName)
	TriggerEvent('animations:client:EmoteCommandStart', {"flute"})
    AJFW.Functions.Progressbar("snort_coke", "Drinking "..AJFW.Shared.Items[itemName].label.."..",'yellow', math.random(3000, 6000), false, true, {
        disableMovement = false,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerEvent("inventory:client:ItemBox", AJFW.Shared.Items[itemName], "remove", 1)
        TriggerServerEvent("AJFW:Server:RemoveItem", itemName, 1)
		if AJFW.Shared.Items[itemName].thirst then TriggerServerEvent("AJFW:Server:SetMetaData", "thirst", AJFW.Functions.GetPlayerData().metadata["thirst"] + AJFW.Shared.Items[itemName].thirst) end
		if AJFW.Shared.Items[itemName].hunger then TriggerServerEvent("AJFW:Server:SetMetaData", "hunger", AJFW.Functions.GetPlayerData().metadata["hunger"] + AJFW.Shared.Items[itemName].hunger) end
        alcoholCount = alcoholCount + 1
        if alcoholCount > 1 and alcoholCount < 4 then
            TriggerEvent("evidence:client:SetStatus", "alcohol", 200)
        elseif alcoholCount >= 4 then
            TriggerEvent("evidence:client:SetStatus", "heavyalcohol", 200)
			AlienEffect()
        end
        
    end, function() -- Cancel
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        AJFW.Functions.Notify("Cancelled..", "error")
    end)
end)

function AlienEffect()
    StartScreenEffect("DrugsMichaelAliensFightIn", 3.0, 0)
    Wait(math.random(5000, 8000))
    local ped = PlayerPedId()
    RequestAnimSet("MOVE_M@DRUNK@VERYDRUNK") 
    while not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") do Citizen.Wait(0) end
    SetPedCanRagdoll( ped, true )
    ShakeGameplayCam('DRUNK_SHAKE', 2.80)
    SetTimecycleModifier("Drunk")
    SetPedMovementClipset(ped, "MOVE_M@DRUNK@VERYDRUNK", true)
    SetPedMotionBlur(ped, true)
    SetPedIsDrunk(ped, true)
    Wait(1500)
    SetPedToRagdoll(ped, 5000, 1000, 1, false, false, false )
    Wait(13500)
    SetPedToRagdoll(ped, 5000, 1000, 1, false, false, false )
    Wait(120500)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(ped, 0)
    SetPedIsDrunk(ped, false)
    SetPedMotionBlur(ped, false)
    AnimpostfxStopAll()
    ShakeGameplayCam('DRUNK_SHAKE', 0.0)
    StartScreenEffect("DrugsMichaelAliensFight", 3.0, 0)
    Wait(math.random(45000, 60000))    
    StartScreenEffect("DrugsMichaelAliensFightOut", 3.0, 0)
    StopScreenEffect("DrugsMichaelAliensFightIn")
    StopScreenEffect("DrugsMichaelAliensFight")
    StopScreenEffect("DrugsMichaelAliensFightOut")
end

RegisterNetEvent('jim-catcafe:client:Drink', function(itemName)
	TriggerEvent('dpemote:custom:animation', {"coffee"})
	AJFW.Functions.Progressbar("drink_something", "Drinking "..AJFW.Shared.Items[itemName].label.."..",'blue', 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", AJFW.Shared.Items[itemName], "remove", 1)
        TriggerEvent('dpemote:custom:animation', {"c"})
		TriggerServerEvent("AJFW:Server:RemoveItem", itemName, 1)
		if AJFW.Shared.Items[itemName].thirst then TriggerServerEvent("AJFW:Server:SetMetaData", "thirst", AJFW.Functions.GetPlayerData().metadata["thirst"] + AJFW.Shared.Items[itemName].thirst) end
		if AJFW.Shared.Items[itemName].hunger then TriggerServerEvent("AJFW:Server:SetMetaData", "hunger", AJFW.Functions.GetPlayerData().metadata["hunger"] + AJFW.Shared.Items[itemName].hunger) end
	end)
end)

RegisterNetEvent('jim-catcafe:client:Eat', function(itemName)
	TriggerEvent('dpemote:custom:animation', {"beans"})
    AJFW.Functions.Progressbar("eat_something", "Eating "..AJFW.Shared.Items[itemName].label.."..",'orange', 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", AJFW.Shared.Items[itemName], "remove", 1)
		TriggerServerEvent("AJFW:Server:RemoveItem", itemName, 1)
        TriggerEvent('dpemote:custom:animation', {"c"})
		if AJFW.Shared.Items[itemName].thirst then TriggerServerEvent("AJFW:Server:SetMetaData", "thirst", AJFW.Functions.GetPlayerData().metadata["thirst"] + AJFW.Shared.Items[itemName].thirst) end
		if AJFW.Shared.Items[itemName].hunger then TriggerServerEvent("AJFW:Server:SetMetaData", "hunger", AJFW.Functions.GetPlayerData().metadata["hunger"] + AJFW.Shared.Items[itemName].hunger) end
        TriggerServerEvent('hud:server:RelieveStress', math.random(2, 4))
    end)
end)

RegisterNetEvent('jim-catcafe:client:Eat2', function(itemName)
	TriggerEvent('dpemote:custom:animation', {"sandwich"})
    AJFW.Functions.Progressbar("eat_something", "Eating "..AJFW.Shared.Items[itemName].label.."..",'orange', 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", AJFW.Shared.Items[itemName], "remove", 1)
		TriggerServerEvent("AJFW:Server:RemoveItem", itemName, 1)
        TriggerEvent('dpemote:custom:animation', {"c"})
		if AJFW.Shared.Items[itemName].thirst then TriggerServerEvent("AJFW:Server:SetMetaData", "thirst", AJFW.Functions.GetPlayerData().metadata["thirst"] + AJFW.Shared.Items[itemName].thirst) end
		if AJFW.Shared.Items[itemName].hunger then TriggerServerEvent("AJFW:Server:SetMetaData", "hunger", AJFW.Functions.GetPlayerData().metadata["hunger"] + AJFW.Shared.Items[itemName].hunger) end
        TriggerServerEvent('hud:server:RelieveStress', math.random(2, 4))
    end)
end)

RegisterNetEvent('jim-catcafe:client:Eat3', function(itemName)
	TriggerEvent('dpemote:custom:animation', {"donut"})
    AJFW.Functions.Progressbar("eat_something", "Eating "..AJFW.Shared.Items[itemName].label.."..",'orange', 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", AJFW.Shared.Items[itemName], "remove", 1)
		TriggerServerEvent("AJFW:Server:RemoveItem", itemName, 1)
        TriggerEvent('dpemote:custom:animation', {"c"})
		if AJFW.Shared.Items[itemName].thirst then TriggerServerEvent("AJFW:Server:SetMetaData", "thirst", AJFW.Functions.GetPlayerData().metadata["thirst"] + AJFW.Shared.Items[itemName].thirst) end
		if AJFW.Shared.Items[itemName].hunger then TriggerServerEvent("AJFW:Server:SetMetaData", "hunger", AJFW.Functions.GetPlayerData().metadata["hunger"] + AJFW.Shared.Items[itemName].hunger) end
        TriggerServerEvent('hud:server:RelieveStress', math.random(2, 4))
    end)
end)

RegisterNetEvent('jim-catcafe:client:Eat4', function(itemName)
	TriggerEvent('dpemote:custom:animation', {"candy"})
    AJFW.Functions.Progressbar("eat_something", "Eating "..AJFW.Shared.Items[itemName].label.."..",'orange', 5000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerEvent("inventory:client:ItemBox", AJFW.Shared.Items[itemName], "remove", 1)
		TriggerServerEvent("AJFW:Server:RemoveItem", itemName, 1)
        TriggerEvent('dpemote:custom:animation', {"c"})
		if AJFW.Shared.Items[itemName].thirst then TriggerServerEvent("AJFW:Server:SetMetaData", "thirst", AJFW.Functions.GetPlayerData().metadata["thirst"] + AJFW.Shared.Items[itemName].thirst) end
		if AJFW.Shared.Items[itemName].hunger then TriggerServerEvent("AJFW:Server:SetMetaData", "hunger", AJFW.Functions.GetPlayerData().metadata["hunger"] + AJFW.Shared.Items[itemName].hunger) end
        TriggerServerEvent('hud:server:RelieveStress', math.random(2, 4))
    end)
end)

AddEventHandler('onResourceStop', function(resource) 
	if resource == GetCurrentResourceName() then
		exports['aj-target']:RemoveZone("CatTable") 
		exports['aj-target']:RemoveZone("CatTable2") 
		exports['aj-target']:RemoveZone("CatTable3") 
		exports['aj-target']:RemoveZone("CatTable4") 
		exports['aj-target']:RemoveZone("CatBoard") 
		exports['aj-target']:RemoveZone("CatCoffee") 
		exports['aj-target']:RemoveZone("CatMixer") 
		exports['aj-target']:RemoveZone("CatReceipt2") 
		exports['aj-target']:RemoveZone("CatReceipt1") 
		exports['aj-target']:RemoveZone("CatCounter2") 
		exports['aj-target']:RemoveZone("CatCounter") 
		exports['aj-target']:RemoveZone("CatHob") 
		exports['aj-target']:RemoveZone("CatOven") 
		exports['aj-target']:RemoveZone("CatClockin")
		exports['aj-target']:RemoveZone("CatWash3")
		exports['aj-target']:RemoveZone("CatWash2")
		exports['aj-target']:RemoveZone("CatWash1")
		exports['aj-target']:RemoveZone("CatStorage3")
		exports['aj-target']:RemoveZone("CatStorage2")
		exports['aj-target']:RemoveZone("CatStorage")
		exports['aj-target']:RemoveZone("CatFridge2")
		exports['aj-target']:RemoveZone("CatFridge")
		exports['aj-target']:RemoveZone("CatPrepared")
	end
end)