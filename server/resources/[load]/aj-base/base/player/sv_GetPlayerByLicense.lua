---@param license string
---@return table?
function AJFW.Functions.GetPlayerByLicense(license)
    if license then
        local source = AJFW.Functions.GetSource(license)
        if source > 0 then
            return AJFW.Players[source]
        else
            return AJFW.Player.GetOfflinePlayerByLicense(license)
        end
    end
    return nil
end

function AJFW.Player.GetPlayerByLicense(license)
    if license then
        local PlayerData = MySQL.prepare.await('SELECT * FROM players where license = ?', { license })
        if PlayerData then
            PlayerData.money = json.decode(PlayerData.money)
            PlayerData.job = json.decode(PlayerData.job)
            PlayerData.position = json.decode(PlayerData.position)
            PlayerData.metadata = json.decode(PlayerData.metadata)
            PlayerData.charinfo = json.decode(PlayerData.charinfo)
            if PlayerData.gang then
                PlayerData.gang = json.decode(PlayerData.gang)
            else
                PlayerData.gang = {}
            end

            return AJFW.Player.CheckPlayerData(nil, PlayerData)
        end
    end
    return nil
end