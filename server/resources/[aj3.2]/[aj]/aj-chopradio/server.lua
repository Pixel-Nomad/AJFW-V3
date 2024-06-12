-- Locals
local AJFW = exports["aj-base"]:GetCoreObject()

local cooldown = -1
local inProgress = false
local randomLoc, randomVeh = nil , nil
local chopvehicle = nil
local currentplate = nil

local ChopItem = Config.ChopRadioItem
local randomLocations = Config.RandomLocations
local randomModels = Config.RandomVehicles
local RewardItems = Config.RewardItems

-- Functions

function CooldownTimer(minutes)
    cooldown = minutes * 60 * 1000
    while cooldown > 0 do
        Wait(1000)
        cooldown = cooldown - 1000
        if cooldown <= 0 then
            cooldown = -1
            inProgress = false
            TriggerEvent('jacob-chopshop:timeOver')
            break
        end
        if not DoesEntityExist(chopvehicle) then
            cooldown = -1
            inProgress = false
            TriggerEvent('jacob-chopshop:timeOver')
            break
        end
    end
end

-- Loops

CreateThread(function()
	while true do
		Wait(1000)   
        if not inProgress then     
            if randomLoc == nil and randomVeh == nil and currentplate == nil then
                randomLoc = randomLocations[math.random(1, #randomLocations)]
                randomVeh = randomModels[math.random(1, #randomModels)]        
                currentplate = tostring(math.random(11111111,99999999))
                inProgress = true
                -- Wait((1000*60)*3)      
                chopvehicle = CreateVehicle(randomVeh, randomLoc.x, randomLoc.y, randomLoc.z, randomLoc.w, true, true)     
                while not DoesEntityExist(chopvehicle) do Wait(0) end
                SetVehicleNumberPlateText(chopvehicle, currentplate)
                print(tostring("Vehicle: [" .. randomVeh .. "] | Coords: " .. randomLoc .. " | Plate: " .. currentplate))             
                local Players = AJFW.Functions.GetPlayers()
                for i=1, #Players, 1 do
                    local Player = AJFW.Functions.GetPlayer(Players[i])
                    if Player.Functions.GetItemByName(ChopItem) then
                        TriggerClientEvent("jacob-chopshop:GetHotVehicleData", Players[i], randomVeh, currentplate)                    
                        TriggerClientEvent('jacob-chopshop:notifyOwner', Players[i], randomLoc.x, randomLoc.y, randomLoc.z, randomVeh)                        
                    end
                end        
                CooldownTimer(20)          
            end        
        end
	end
end)

-- Create Usable Items

AJFW.Functions.CreateUseableItem(ChopItem, function(source)
    local src = source        
    if randomLoc and randomVeh then      
        TriggerClientEvent("jacob-chopshop:GetHotVehicleData", src, randomVeh, currentplate)      		                                                  
        TriggerClientEvent('jacob-chopshop:notifyOwner', src, randomLoc.x, randomLoc.y, randomLoc.z, randomVeh)               
	else        		    
        TriggerClientEvent('AJFW:Notify', src, 'You will be informed if there is another hot vehicle needed')         	        
	end
end)

-- Events

RegisterNetEvent('jacob-chopshop:clientjoined', function()
    local Player = AJFW.Functions.GetPlayer(source)
    if Player.Functions.GetItemByName(ChopItem) then
        if randomLoc and randomVeh then      
            TriggerClientEvent("jacob-chopshop:GetHotVehicleData", source, randomVeh, currentplate)      		                                                  
            TriggerClientEvent('jacob-chopshop:notifyOwner', source, randomLoc.x, randomLoc.y, randomLoc.z, randomVeh)            	
        end
    end
end)

RegisterNetEvent('jacob-chopshop:vehicleChopped', function()	
	local Players = AJFW.Functions.GetPlayers()
    for i=1, #Players, 1 do
        local Player = AJFW.Functions.GetPlayer(Players[i])
        if Player.Functions.GetItemByName(ChopItem) then
            TriggerClientEvent('jacob-chopshop:informClients', Players[i])
            randomLoc = nil
            randomVeh = nil
            currentplate = nil         
            chopvehicle = nil   
	    cooldown = 25000 -- 25 secs after chop will give new vehicle
        end
    end
end)

RegisterNetEvent('jacob-chopshop:timeOver', function()
    local Players = AJFW.Functions.GetPlayers()    
    for i=1, #Players, 1 do
        local Player = AJFW.Functions.GetPlayer(Players[i])
        if Player.Functions.GetItemByName(ChopItem) then
            TriggerClientEvent('jacob-chopshop:informClients', Players[i])
            randomLoc = nil
            randomVeh = nil
            currentplate = nil    
            chopvehicle = nil        
        end
    end
end)

RegisterNetEvent('cad-chopshop:recievereward', function(rarevalue)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local amount = math.random(1500, 4000)
    if Player ~= nil then        
        TriggerClientEvent('AJFW:Notify', src, 'You received $' .. amount .. ' for this hot vehicle', 'success')
        if rarevalue == "rare1" then        
            Player.Functions.AddItem("tunerlaptop", 1)
            TriggerClientEvent('AJFW:Notify', src, 'Found a Laptop', 'success')        
        elseif rarevalue == "rare2" then
            Player.Functions.AddItem("tunerlaptop", 1)
        elseif rarevalue == "normal" then
            Player.Functions.AddMoney("cash",amount)	
            for i = 1, math.random(3,6), 1 do
                local item = RewardItems[math.random(1, #RewardItems)]
                local amount = math.random(20,50)
                Player.Functions.AddItem(item, amount)
                TriggerClientEvent('inventory:client:ItemBox', src, AJFW.Shared.Items[item], 'add', amount)
            end
        end
    end
end)
