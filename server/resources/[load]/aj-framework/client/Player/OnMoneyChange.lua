local aaaaa = 'Player/OnMoneyChange'


RegisterNetEvent('hud:client:OnMoneyChange', function(moneyType)
    local playerMoney = AJFW.Functions.GetPlayerData().money
    -- exports.ui_pause._SendNUIMessage({action = "UpdateData", key = moneyType, value = tonumber(playerMoney[moneyType])})
end)