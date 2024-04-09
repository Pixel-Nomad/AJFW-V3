function AJFW.Player.Login(source, citizenid, newData)
    if source and source ~= '' then
        if citizenid then
            local license = AJFW.Functions.GetIdentifier(source, 'license')
            local PlayerData = MySQL.prepare.await('SELECT * FROM players where citizenid = ?', { citizenid })
            if PlayerData and license == PlayerData.license then
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
                AJFW.Player.CheckPlayerData(source, PlayerData)
            else
                DropPlayer(source, Lang:t('info.exploit_dropped'))
                TriggerEvent('aj-log:server:CreateLog', 'anticheat', 'Anti-Cheat', 'white', GetPlayerName(source) .. ' Has Been Dropped For Character Joining Exploit', false)
            end
        else
            AJFW.Player.CheckPlayerData(source, newData)
        end
        return true
    else
        AJFW.ShowError(GetCurrentResourceName(), 'ERROR AJFW.PLAYER.LOGIN - NO SOURCE GIVEN!')
        return false
    end
end