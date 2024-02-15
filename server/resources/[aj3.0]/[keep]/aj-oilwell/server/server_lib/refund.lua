local AJFW = exports['aj-base']:GetCoreObject()
local vehicles = {}

RegisterNetEvent('aj-oilwell:server_lib:update_vehicle', function(vehiclePlate, items)
     local src = source
     if not vehicles[src] then
          vehicles[src] = {}
     end
     vehicles[src][vehiclePlate] = vehiclePlate
     exports['aj-inventory']:addTrunkItems(vehiclePlate, items)
end)

AJFW.Functions.CreateCallback('aj-oilwell:server:refund_truck', function(source, cb, vehiclePlate)
     if vehicles[source] then
          if vehicles[source][vehiclePlate] then
               local player = AJFW.Functions.GetPlayer(source)
               player.Functions.AddMoney('bank', Oilwell_config.Delivery.refund, 'oil_barells')
               vehicles[source][vehiclePlate] = nil
               cb(true)
               return
          end
     end
     cb(false)
end)
