AJFW = exports['aj-base']:GetCoreObject()

local photo = nil


AJFW.Commands.Add("addphoto", "Add Photo To ID", {{name="playerid", help="Player ID"},{name="url", help="URL"}}, true, function(source, args)
	local Player = AJFW.Functions.GetPlayer(source)
	local playerid = tonumber(args[1])
	local url = tostring(args[2])

	local target = AJFW.Functions.GetPlayer(playerid)
	local fetchcitizen = target.PlayerData.citizenid

    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then

		MySQL.query('UPDATE players SET photo = ? WHERE citizenid = ?', {url, fetchcitizen})
		local db = MySQL.query.await('SELECT * FROM mdt_data WHERE cid = ?',{fetchcitizen})
		if db[1] == nil then
			MySQL.insert('INSERT INTO mdt_data (cid, tags, gallery, pfp) VALUES (?, ?, ?, ?)',{fetchcitizen, '[]', '[]', url})
		end
	else
		TriggerClientEvent('AJFW:Notify', source, "You don't have Permission!", "error")
	end
end, 'government')


RegisterServerEvent('aj-idcard:server:fetchPhoto')
AddEventHandler('aj-idcard:server:fetchPhoto', function()
	local src     		= source
	local aj 		= AJFW.Functions.GetPlayer(src)
	local db = MySQL.query.await('SELECT * FROM players WHERE citizenid = ?', {aj.PlayerData.citizenid})
	if db ~= nil then
		for k,v in pairs(db) do
			photo = v.photo
		end
	end
end)




AJFW.Commands.Add("setlawyer", "Set someone as a lawyer", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.name == "Mayor" or  Player.PlayerData.job.name == "doj" and Player.PlayerData.job.grade.name == "Chief Justice" then
        if OtherPlayer then
            local lawyerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
            OtherPlayer.Functions.SetJob("lawyer")
            OtherPlayer.Functions.AddItem("lawyerpass", 1, false, lawyerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have Hired as a lawyer")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "You are now a lawyer")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["lawyerpass"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,'government')

AJFW.Commands.Add("removelawyer", "Delete someone from lawyer", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or  Player.PlayerData.job.name == "doj" and Player.PlayerData.job.grade.name == "Chief Justice" then
        if OtherPlayer then
            --OtherPlayer.Functions.SetJob("unemployed")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "You are now unemployed")
            TriggerClientEvent("AJFW:Notify", source, "-".. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " , You are Fired as a lawyer")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,'government')

AJFW.Commands.Add("mayorpass", "Give Mayor Pass", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or  Player.PlayerData.job.name == "doj" and Player.PlayerData.job.grade.name == "Chief Justice" then
        if OtherPlayer then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("mayorpass", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received mayor pass.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now you can meet mayor! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["mayorpass"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("newsid", "Give Reporter ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then
        if OtherPlayer then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("wcard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["wcard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("taxiid", "Give Taxi ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then
        if OtherPlayer then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("taxicard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["taxicard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("towid", "Give Tow ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then
        if OtherPlayer then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("towcard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["towcard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("poid", "Give Postal ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then
        if OtherPlayer then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("pocard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["pocard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("idcard", "Give ID Card", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then
        if OtherPlayer then
            local playerInfo = {
                citizenid = OtherPlayer.PlayerData.citizenid,
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                birthdate = OtherPlayer.PlayerData.charinfo.birthdate,
                gender = OtherPlayer.PlayerData.charinfo.gender,
                nationality = OtherPlayer.PlayerData.charinfo.nationality,
            }
           
            OtherPlayer.Functions.AddItem("id_card", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received ID CARD.")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["id_card"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("policeid", "Give Police ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then
        if OtherPlayer then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                birthdate = OtherPlayer.PlayerData.charinfo.birthdate,
                gender = OtherPlayer.PlayerData.charinfo.gender,
                nationality = OtherPlayer.PlayerData.charinfo.nationality,
            }
           
            OtherPlayer.Functions.AddItem("pcard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["pcard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("mwid", "Give Police ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then
        if OtherPlayer then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                birthdate = OtherPlayer.PlayerData.charinfo.birthdate,
                gender = OtherPlayer.PlayerData.charinfo.gender,
                nationality = OtherPlayer.PlayerData.charinfo.nationality,
            }
           
            OtherPlayer.Functions.AddItem("mwcard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["mwcard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")


AJFW.Commands.Add("emsid", "Give EMS ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then
        if OtherPlayer then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("mcard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["mcard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("garbageid", "Give Garbage ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" or Player.PlayerData.job.grade.name == "Employee" then
        if OtherPlayer then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("garbagecard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["garbagecard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("setbe", "Set Someone Bahamas Employee", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "bahamas" and Player.PlayerData.job.grade.name == "Owner" then
        if OtherPlayer then
            local bahamasInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
            OtherPlayer.Functions.SetJob("bahamasemployee")

            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have Hired as a bahamas employee")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "You are now a bahamas employee")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end)

AJFW.Commands.Add("setce", "Set Someone Cinema Employee", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "cinema" and Player.PlayerData.job.grade.name == "Owner" then
        if OtherPlayer then
            local cinemaInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
            OtherPlayer.Functions.SetJob("cinemaemployee")

            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have Hired as a cinema employee")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "You are now a cinema employee")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end)

AJFW.Commands.Add("setcce", "Set Someone Comedy Club Employee", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "comclub" and Player.PlayerData.job.grade.name == "Owner" then
        if OtherPlayer then
            local cinemaInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
            OtherPlayer.Functions.SetJob("ccemployee")

            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have Hired as a Comedy Club employee")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "You are now a Comedy Club Employee")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end)

AJFW.Commands.Add("setmcde", "Set Someone MCD Employee", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "mcd" and Player.PlayerData.job.grade.name == "Owner" then
        if OtherPlayer then
            local cinemaInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
            OtherPlayer.Functions.SetJob("mcdemployee")

            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have Hired as a MCD Employee")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "You are now a MCD Employee")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end)

AJFW.Commands.Add("setcse", "Set Someone Coffee Employee", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "coffee" and Player.PlayerData.job.grade.name == "Owner" then
        if OtherPlayer then
            local cinemaInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
            OtherPlayer.Functions.SetJob("csemployee")

            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have Hired as a Coffee Employee")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "You are now a Coffee Employee")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end)

AJFW.Commands.Add("agentid", "Give Real Estate Agent ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" then
        if OtherPlayer then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("realestatecard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["realestatecard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("govid", "Give Government Employee ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" then
        if OtherPlayer then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("governmentcard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["governmentcard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("judgeid", "Give Judge ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" then
        if OtherPlayer then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("judgecard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["judgecard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("mayorid", "Give Mayor ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" then
        if OtherPlayer then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("mayorcard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["mayorcard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("businesslic", "Give Business License", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" then
        if OtherPlayer then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("businesscard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["businesscard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("empid", "Give Employee ID", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.grade.name == "Mayor" or Player.PlayerData.job.grade.name == "Secretery" then
        if OtherPlayer then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("employeecard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received JOB ID CARD.")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now Your Job is Legal! ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["employeecard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Commands.Add("surgerypass", "Give Surgery Pass", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "doctor" and Player.PlayerData.job.grade.name == "EMS Chief" or Player.PlayerData.job.grade.name == "Deputy EMS Chief" or Player.PlayerData.job.grade.name == "Captain" or Player.PlayerData.job.grade.name == "Lieutenant" then
        if OtherPlayer then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("surgerypass", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received Surgery Pass")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now You can go for Plastic Surgery ")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["surgerypass"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end, "doctor")

AJFW.Commands.Add("weaponpass", "Give Weapon Pass", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "police" and Player.PlayerData.job.grade.name == "Commissioner" or Player.PlayerData.job.grade.name == "Chief" or Player.PlayerData.job.grade.name == "Deputy Commissioner" or Player.PlayerData.job.grade.name == "Assistant Commissioner" or Player.PlayerData.job.grade.name == "Captain" or Player.PlayerData.job.grade.name == "Lieutenant" or Player.PlayerData.job.grade.name == "Sergeant" or Player.PlayerData.job.grade.name == "Corporal" then
        if OtherPlayer then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                gender = OtherPlayer.PlayerData.charinfo.gender,
                citizenid = OtherPlayer.PlayerData.citizenid,
            }
           
            OtherPlayer.Functions.AddItem("weaponlicense", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received Weapon Pass")
            TriggerClientEvent("AJFW:Notify", OtherPlayer.PlayerData.source, "Now You can go for Weapon Pass")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["weaponlicense"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"police")

AJFW.Commands.Add("dojcard", "Give DOJ CARD", {{name="id", help="Player ID"}}, true, function(source, args)
    local Player = AJFW.Functions.GetPlayer(source)
    local playerId = tonumber(args[1])
    local OtherPlayer = AJFW.Functions.GetPlayer(playerId)
    if Player.PlayerData.job.name == "government" and Player.PlayerData.job.grade.name == "Governor" or Player.PlayerData.job.name == "Mayor" or  Player.PlayerData.job.name == "doj" and Player.PlayerData.job.grade.name == "Chief Justice" then
        if OtherPlayer then
            local playerInfo = {
                id = math.random(100000, 999999),
                firstname = OtherPlayer.PlayerData.charinfo.firstname,
                lastname = OtherPlayer.PlayerData.charinfo.lastname,
                citizenid = OtherPlayer.PlayerData.citizenid,
                gender = OtherPlayer.PlayerData.charinfo.gender,
            }
           
            OtherPlayer.Functions.AddItem("dojcard", 1, false, playerInfo)
            TriggerClientEvent("AJFW:Notify", source, "- " .. OtherPlayer.PlayerData.charinfo.firstname .. " " .. OtherPlayer.PlayerData.charinfo.lastname ..  " ,You have received DOJ CARD")
            TriggerClientEvent('inventory:client:ItemBox', OtherPlayer.PlayerData.source, AJFW.Shared.Items["dojcard"], "add")
        else
            TriggerClientEvent("AJFW:Notify", source, "This person is not present..", "error")
        end
    else
        TriggerClientEvent("AJFW:Notify", source, "You have no rights..", "error")
    end
end,"government")

AJFW.Functions.CreateUseableItem("wcard", function(source, item)
    -- local Player = AJFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showWCard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local Players = AJFW.Functions.GetPlayers()
	local photo
	MySQL.query('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Weazel News'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('aj-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('aj-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

AJFW.Functions.CreateUseableItem("taxicard", function(source, item)
    -- local Player = AJFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showTaxiCard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local Players = AJFW.Functions.GetPlayers()
	local photo
	MySQL.query('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Taxi'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('aj-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('aj-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

AJFW.Functions.CreateUseableItem("towcard", function(source, item)
    -- local Player = AJFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showTowCard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local Players = AJFW.Functions.GetPlayers()
	local photo
	MySQL.query('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Tow'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('aj-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('aj-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

AJFW.Functions.CreateUseableItem("pocard", function(source, item)
    -- local Player = AJFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showPoCard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local Players = AJFW.Functions.GetPlayers()
	local photo
	MySQL.query('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Go Postal'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('aj-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('aj-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

AJFW.Functions.CreateUseableItem("mcard", function(source, item)
    -- local Player = AJFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showMcard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local Players = AJFW.Functions.GetPlayers()
	local photo
	MySQL.query('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'EMS'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('aj-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('aj-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

AJFW.Functions.CreateUseableItem("mecard", function(source, item)
    -- local Player = AJFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showMecard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local Players = AJFW.Functions.GetPlayers()
	local photo
	MySQL.query('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Mechanic'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('aj-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('aj-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

AJFW.Functions.CreateUseableItem("garbagecard", function(source, item)
    -- local Player = AJFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showGarbageCard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local Players = AJFW.Functions.GetPlayers()
	local photo
	MySQL.query('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Grabage'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('aj-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('aj-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

AJFW.Functions.CreateUseableItem("realestatecard", function(source, item)
    -- local Player = AJFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showrealestateCard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local Players = AJFW.Functions.GetPlayers()
	local photo
	MySQL.query('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Real Estate'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('aj-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('aj-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

AJFW.Functions.CreateUseableItem("governmentcard", function(source, item)
    -- local Player = AJFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showgovernmentCard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local Players = AJFW.Functions.GetPlayers()
	local photo
	MySQL.query('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Government'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('aj-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('aj-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

AJFW.Functions.CreateUseableItem("judgecard", function(source, item)
    -- local Player = AJFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showjudgeCard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local Players = AJFW.Functions.GetPlayers()
	local photo
	MySQL.query('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Judge'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('aj-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('aj-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

AJFW.Functions.CreateUseableItem("mayorcard", function(source, item)
    -- local Player = AJFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showmayorCard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local Players = AJFW.Functions.GetPlayers()
	local photo
	MySQL.query('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Mayor'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('aj-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('aj-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

AJFW.Functions.CreateUseableItem("businesscard", function(source, item)
    -- local Player = AJFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:ShowbusinessLicense", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local Players = AJFW.Functions.GetPlayers()
	local photo
	MySQL.query('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Business Owner'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('aj-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('aj-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

AJFW.Functions.CreateUseableItem("employeecard", function(source, item)
    -- local Player = AJFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:Showemployeecard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local Players = AJFW.Functions.GetPlayers()
	local photo
	MySQL.query('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Employee'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('aj-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('aj-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

AJFW.Functions.CreateUseableItem("pcard", function(source, item)
    local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local Players = AJFW.Functions.GetPlayers()
	local photo
	MySQL.query('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Law Officer'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('aj-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('aj-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

AJFW.Functions.CreateUseableItem("mwcard", function(source, item)
    local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local Players = AJFW.Functions.GetPlayers()
	local photo
	MySQL.query('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Merry Weather'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('aj-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('aj-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

AJFW.Functions.CreateUseableItem("weaponlicense", function(source, item)
    -- local Player = AJFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:showweaponlicense", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local Players = AJFW.Functions.GetPlayers()
	local photo
	MySQL.query('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Weapon License'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('aj-idcard:client:Weaponopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('aj-idcard:client:Weaponopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

AJFW.Functions.CreateUseableItem("dojcard", function(source, item)
    -- local Player = AJFW.Functions.GetPlayer(source)
	-- if Player.Functions.GetItemBySlot(item.slot) ~= nil then
    --     TriggerClientEvent("inventory:client:Showdojcard", -1, source, Player.PlayerData.citizenid, item.info)
    -- end
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local Players = AJFW.Functions.GetPlayers()
	local photo
	MySQL.query('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = 'Doj'
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('aj-idcard:client:Jobopen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('aj-idcard:client:Jobopen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)

AJFW.Functions.CreateUseableItem("petlicense", function(source, item)
    local Player = AJFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("inventory:client:Showpetlicense", -1, source, Player.PlayerData.citizenid, item.info)
    end
end)


AJFW.Functions.CreateUseableItem("covidcert", function(source, item)
    local Player = AJFW.Functions.GetPlayer(source)
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
        TriggerClientEvent("inventory:client:showcovidcer", -1, source, Player.PlayerData.citizenid, item.info)
    end
end)

AJFW.Functions.CreateUseableItem("id_card", function(source, item)
	local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local Players = AJFW.Functions.GetPlayers()
	local photo
	MySQL.query('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
		end
	end)
	Citizen.Wait(500)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = item.info.birthdate
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('aj-idcard:client:open', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('aj-idcard:client:open', src, csn, name, name2, birth, gender, national, photo)
	end
end)

AJFW.Functions.CreateUseableItem("driver_license", function(source, item)
    local src = source
	local Player = AJFW.Functions.GetPlayer(src)
	local Players = AJFW.Functions.GetPlayers()
	local photo
	MySQL.query('SELECT * FROM players WHERE citizenid = ?', {Player.PlayerData.citizenid}, function(result)
		for k,v in pairs(result) do
			photo = v.photo
			-- print(photo)
		end
	end)
	Citizen.Wait(500)
	-- print(photo)
	local gender = "Man"
	if item.info.gender == 1 then
		gender = "Woman"
	end
	local csn = item.info.citizenid
	local name = item.info.firstname
	local name2 = item.info.lastname
	local birth = item.info.birthdate
	local gender = gender
	local national = item.info.nationality
	if Player.Functions.GetItemBySlot(item.slot) ~= nil then
		for k,v in pairs(Players) do
			local ply = GetPlayerPed(src)
			local target = GetPlayerPed(v)
			local dist = #( GetEntityCoords(ply) - GetEntityCoords(target) )
			if dist < 3 then
				TriggerClientEvent('aj-idcard:client:driveropen', v, csn, name, name2, birth, gender, national, photo)
			end
		end
		TriggerClientEvent('aj-idcard:client:driveropen', src, csn, name, name2, birth, gender, national, photo)
	end	
end)