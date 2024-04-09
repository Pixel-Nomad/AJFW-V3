function AJFW.Player.Logout(source)
    TriggerClientEvent('AJFW:Client:OnPlayerUnload', source)
    TriggerEvent('AJFW:Server:OnPlayerUnload', source)
    TriggerClientEvent('AJFW:Player:UpdatePlayerData', source)
    Wait(200)
    AJFW.Players[source] = nil
end
