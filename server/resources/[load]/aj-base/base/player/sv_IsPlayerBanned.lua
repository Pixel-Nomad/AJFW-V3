---@param source any
---@return boolean, string?
function AJFW.Functions.IsPlayerBanned(source)
    local plicense = AJFW.Functions.GetIdentifier(source, 'license')
    local result = MySQL.single.await('SELECT * FROM bans WHERE license = ?', { plicense })
    if not result then return false end
    if os.time() < result.expire then
        local timeTable = os.date('*t', tonumber(result.expire))
        return true, {result.reason, timeTable.day .. '/' .. timeTable.month .. '/' .. timeTable.year .. ' ' .. timeTable.hour .. ':' .. timeTable.min}
    else
        MySQL.query('DELETE FROM bans WHERE id = ?', { result.id })
    end
    return false
end