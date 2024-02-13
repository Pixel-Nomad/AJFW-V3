Citizen.CreateThread(function()

    if(Config.UseCustomWeaponDamages)then
        while true do
            for k, v in pairs(Config.Weapons) do
                Citizen.Wait(50)
                SetWeaponDamageModifier(v.hash, v.damageMultiplier) 
            end
            Wait(100)
        end 
    end

end)