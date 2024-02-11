local AJFW = exports['aj-base']:GetCoreObject()

AJFW.Functions.CreateCallback('aj-spawn:server:getOwnedHouses', function(_, cb, cid)
    if cid ~= nil then
        local houses = MySQL.query.await('SELECT * FROM player_houses WHERE identifier = ?', {cid})
        if houses[1] ~= nil then
            cb(houses)
        else
            cb(nil)
        end
    else
        cb(nil)
    end
end)

AJFW.Commands.Add("addloc", "Add location for spawn (Dev Only)", {}, false, function(source)
    local src = source
    TriggerClientEvent('aj-spawn:client:OpenUIForSelectCoord', src)
end, "god")
