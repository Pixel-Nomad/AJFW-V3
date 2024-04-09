local permsobject = {
    'dev',
    'owner',
    'manager',
    'h-admin',
    'admin',
    'c-admin',
    's-mod',
    'mod'
}



---Toggle opt-in to admin messages
---@param source any
function AJFW.Functions.ToggleOptin(source)
    local src = source
    local license = AJFW.Functions.GetIdentifier(src, 'license')
    local Player = AJFW.Functions.GetPlayer(src)
    if license then
        for i = 1, #permsobject do
            if AJFW.Functions.HasPermission(src, permsobject[i]) then
                Player.PlayerData.optin = not Player.PlayerData.optin
                Player.Functions.SetPlayerData('optin', Player.PlayerData.optin)
            end
        end
    end
end