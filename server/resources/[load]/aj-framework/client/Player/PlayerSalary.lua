local aaaaa = 'Player/PlayerSalary'


CreateThread(function()
	while true do
		Wait(5000)
		if LocalPlayer.state.isLoggedIn then
			Wait((1000 * 60) * 10)
			TriggerServerEvent("AJFW:Player:UpdatePlayerPayment")
		end
	end
end)