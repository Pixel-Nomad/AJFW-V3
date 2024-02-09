local AJFW = exports['aj-base']:GetCoreObject()

CreateThread(function()
    for _, v in pairs(AJFW.Shared.Vehicles) do
        local text
        if v.brand then
            text = v.brand..' '..v.name
        else
            text = v.name
        end
        if v.hash and v.hash ~= 0 then
            AddTextEntryByHash(v.hash, text)
        end
    end
end)