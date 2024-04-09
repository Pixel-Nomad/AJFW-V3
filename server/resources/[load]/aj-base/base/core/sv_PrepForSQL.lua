---@param source any
---@param data any
---@param pattern any
---@return boolean
function AJFW.Functions.PrepForSQL(source, data, pattern)
    data = tostring(data)
    local src = source
    local player = AJFW.Functions.GetPlayer(src)
    local result = string.match(data, pattern)
    if not result or string.len(result) ~= string.len(data) then
        TriggerEvent('aj-log:server:CreateLog', 'anticheat', 'SQL Exploit Attempted', 'red', string.format('%s attempted to exploit SQL!', player.PlayerData.license))
        return false
    end
    return true
end