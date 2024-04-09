---@param source any
---@return boolean
function AJFW.Functions.IsWhitelisted(source)
    if not AJFW.Config.Server.Whitelist then return true end
    if AJFW.Functions.HasPermission(source, AJFW.Config.Server.WhitelistPermission) then return true end
    return false
end
