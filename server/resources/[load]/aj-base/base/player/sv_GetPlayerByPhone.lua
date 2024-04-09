---@param number number
---@return table?
function AJFW.Functions.GetPlayerByPhone(number)
    for src in pairs(AJFW.Players) do
        if AJFW.Players[src].PlayerData.charinfo.phone == number then
            return AJFW.Players[src]
        end
    end
    return nil
end