function AJFW.Functions.GetPeds(ignoreList)
    local pedPool = GetGamePool('CPed')
    local peds = {}
    local ignoreTable = {}
    ignoreList = ignoreList or {}
    for i = 1, #ignoreList do
        ignoreTable[ignoreList[i]] = true
    end
    for i = 1, #pedPool do
        if not ignoreTable[pedPool[i]] then
            peds[#peds + 1] = pedPool[i]
        end
    end
    return peds
end