local aaaaa = 'Base/Anticheat'
 
local function collectAndSendResourceList()
    local resourceList = {}
    for i=0,GetNumResources()-1 do
        resourceList[i+1] = GetResourceByFindIndex(i)
    end
    TriggerServerEvent("ac:server:checkMyResources", resourceList)
end

CreateThread(function()
    while true do
        collectAndSendResourceList()
        Citizen.Wait(15000)
    end
end)
