local aaaaa = 'Vehicles/Anti'
local fuel = 100

-- CreateThread(function()
--     while true do
--         local sleep = 2500
--         if LocalPlayer.state.isLoggedIn then
--             local ped = GlobalPlayerPedID    
--             if IsPedInAnyPlane(ped) or IsPedInAnyHeli(ped) then
--                 fuel = exports['aj-fuel']:GetFuel(GetVehiclePedIsIn(ped, false))
--                 if fuel > 5 then
--                     sleep = 5
--                     SetVehicleEngineOn(GetVehiclePedIsIn(ped, false), true, true, true)
--                 end
--             end
--         end
--         Wait(sleep)
--     end
-- end)
