local aaaaa = 'Player/SetDeathStatus'


RegisterNetEvent('hospital:server:SetDeathStatus', function(isdead)
    local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	if Player then
		-- TriggerClientEvent('aj-pausemenu:CloseMenu', src, isdead)
	end
end)