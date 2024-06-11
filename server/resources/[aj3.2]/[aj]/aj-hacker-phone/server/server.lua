local AJFW = exports['aj-base']:GetCoreObject()

AJFW.Functions.CreateUseableItem("hackerphone", function(source)
   local src = source
   local Player = AJFW.Functions.GetPlayer(src)
   local name = Player.PlayerData.charinfo.firstname
   TriggerClientEvent('aj-hackerphone:client:openphone',src,name)
end)

AJFW.Functions.CreateUseableItem("tracker2", function(source)
   TriggerClientEvent('aj-hackerphone:client:vehicletracker',source)
end)

AJFW.Functions.CreateUseableItem("centralchip", function(source)
   TriggerClientEvent('aj-hackerphone:client:centralchip',source)
end)

RegisterNetEvent('aj-hackerphone:server:removeitem', function(item)
   local Player = AJFW.Functions.GetPlayer(source)
   Player.Functions.RemoveItem(item, 1)
end)

RegisterNetEvent('aj-hackerphone:server:targetinformation', function()
   local src = source
   local PlayerPed = GetPlayerPed(src)
   local pCoords = GetEntityCoords(PlayerPed)
   local found = false
      for k, v in pairs(AJFW.Functions.GetPlayers()) do
         local TargetPed = GetPlayerPed(v)
         local tCoords = GetEntityCoords(TargetPed)
         local dist = #(pCoords - tCoords)
         if PlayerPed ~= TargetPed and dist < 3.0 then
            found = true
            TargetPlayer = AJFW.Functions.GetPlayer(v)
         end
     end
  if found then 
         local targetinfo = {
            ['targetname'] = TargetPlayer.PlayerData.charinfo.firstname,
            ['targetlastname'] = TargetPlayer.PlayerData.charinfo.lastname,
            ['targetdob'] = TargetPlayer.PlayerData.charinfo.birthdate,
            ['targetphone'] = TargetPlayer.PlayerData.charinfo.phone,
            ['targetbank'] = TargetPlayer.PlayerData.money['bank']
          }
      TriggerClientEvent('aj-hackerphone:client:targetinfornui',src,targetinfo)
   else
      TriggerClientEvent('aj-hackerphone:client:notify',src)
   end
end)

