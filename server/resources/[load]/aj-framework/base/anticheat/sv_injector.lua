local aaaaa = 'Base/Anticheat'
 

local validResourceList = {}
local function collectValidResourceList()
    validResourceList = {}
    for i=0,GetNumResources()-1 do
        validResourceList[GetResourceByFindIndex(i)] = true
    end
end
collectValidResourceList()

-- This makes sure that the resource list is always accurate
AddEventHandler("onResourceListRefresh", collectValidResourceList)

RegisterNetEvent("ac:server:checkMyResources", function(givenList)
    for _, resource in ipairs(givenList) do
        if not validResourceList[resource] then
            -- bad client!
            local src = source
            TriggerEvent("aj-log:server:CreateLog", "anticheat", "Player kicked!", "red", "** @everyone " ..GetPlayerName(src).. "** has more resources than server.")
            DropPlayer(src, "You Have Been Kicked For Cheating. Contact Staff (or dont): https://discord.gg/FahMruHq6B")
            break
        end
    end
end)