---@param property string
---@param value string
---@return table?
function AJFW.Functions.GetPlayerByCharInfo(property, value)
    for src in pairs(AJFW.Players) do
        local charinfo = AJFW.Players[src].PlayerData.charinfo
        if charinfo[property] ~= nil and charinfo[property] == value then
            return AJFW.Players[src]
        end
    end
    return nil
end