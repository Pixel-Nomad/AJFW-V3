Framework = {}

function Framework.ESX()
    return GetResourceState("es_extended") ~= "missing"
end

function Framework.AJFW()
    return GetResourceState("aj-base") ~= "missing"
end
