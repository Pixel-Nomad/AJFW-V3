function AJFW.Functions.GetPeds(ignoreList)
    local pedPool = GetGamePool('CPed')
    local peds = {}
    ignoreList = ignoreList or {}
    for i = 1, #pedPool, 1 do
        local found = false
        for j = 1, #ignoreList, 1 do
            if ignoreList[j] == pedPool[i] then
                found = true
            end
        end
        if not found then
            peds[#peds + 1] = pedPool[i]
        end
    end
    return peds
end