function AJFW.Functions.AddPlayerField(ids, fieldName, data)
    local idType = type(ids)
    if idType == 'number' then
        if ids == -1 then
            for _, v in pairs(AJFW.Players) do
                v.Functions.AddField(fieldName, data)
            end
        else
            if not AJFW.Players[ids] then return end

            AJFW.Players[ids].Functions.AddField(fieldName, data)
        end
    elseif idType == 'table' and table.type(ids) == 'array' then
        for i = 1, #ids do
            AJFW.Functions.AddPlayerField(ids[i], fieldName, data)
        end
    end
end
