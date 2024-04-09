function AJFW.Functions.AddPlayerMethod(ids, methodName, handler)
    local idType = type(ids)
    if idType == 'number' then
        if ids == -1 then
            for _, v in pairs(AJFW.Players) do
                v.Functions.AddMethod(methodName, handler)
            end
        else
            if not AJFW.Players[ids] then return end

            AJFW.Players[ids].Functions.AddMethod(methodName, handler)
        end
    elseif idType == 'table' and table.type(ids) == 'array' then
        for i = 1, #ids do
            AJFW.Functions.AddPlayerMethod(ids[i], methodName, handler)
        end
    end
end