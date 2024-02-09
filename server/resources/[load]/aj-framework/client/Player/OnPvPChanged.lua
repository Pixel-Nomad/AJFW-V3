local aaaaa = 'Player/OnPvPChanged'


RegisterNetEvent('AJFW:Client:PvpHasToggled', function(pvp_state)
    SetCanAttackFriendly(PlayerPedId(), pvp_state, false)
    NetworkSetFriendlyFireOption(pvp_state)
end)