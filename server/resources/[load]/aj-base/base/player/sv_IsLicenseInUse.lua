---@param license any
---@return boolean
function AJFW.Functions.IsLicenseInUse(license)
    local players = GetPlayers()
    for _, player in pairs(players) do
        local playerLicense = AJFW.Functions.GetIdentifier(player, 'license')
        if playerLicense == license then return true end
    end
    return false
end