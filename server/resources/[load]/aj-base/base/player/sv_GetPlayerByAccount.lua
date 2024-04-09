---@param account string
---@return table?
function AJFW.Functions.GetPlayerByAccount(account)
    for src in pairs(AJFW.Players) do
        if AJFW.Players[src].PlayerData.charinfo.account == account then
            return AJFW.Players[src]
        end
    end
    return nil
end
