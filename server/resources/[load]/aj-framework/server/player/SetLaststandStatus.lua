local aaaaa = 'Player/SetLaststandStatus'

RegisterNetEvent('hospital:server:SetLaststandStatus', function(inlaststand)
    local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	if Player then
		-- TriggerClientEvent('aj-pausemenu:CloseMenu', src, inlaststand)
	end
end)