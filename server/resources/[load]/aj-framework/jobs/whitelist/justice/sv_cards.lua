AJFW.Functions.CreateUseableItem("lawyerpass", function(source, item)
    local Player = AJFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) then
        TriggerClientEvent("aj-justice:client:showLawyerLicense", -1, source, item.info)
    end
end)

AJFW.Commands.Add("mechanicid", "Give Mechanic ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then
        if OtherPlayer ~= nil then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("mecard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["mecard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Functions.CreateUseableItem("mayorpass", function(source, item)
    local Player = AJFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("aj-justice:client:showMayorPass", -1, source, item.info)
    end
end)