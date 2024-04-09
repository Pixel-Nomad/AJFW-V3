---@param source any
---@return table
function AJFW.Functions.GetPlayer(source)
    if type(source) == 'number' then
        return AJFW.Players[source]
    else
        return AJFW.Players[AJFW.Functions.GetSource(source)]
    end
end

---@return table
function AJFW.Functions.GetPlayers()
    local sources = {}
    for k in pairs(AJFW.Players) do
        sources[#sources + 1] = k
    end
    return sources
end

---@return table
function AJFW.Functions.GetAJPlayers()
    return AJFW.Players
end