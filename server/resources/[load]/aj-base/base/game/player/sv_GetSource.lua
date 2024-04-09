---@param identifier string
---@return number
function AJFW.Functions.GetSource(identifier)
    for src, _ in pairs(AJFW.Players) do
        local idens = GetPlayerIdentifiers(src)
        for _, id in pairs(idens) do
            if identifier == id then
                return src
            end
        end
    end
    return 0
end
