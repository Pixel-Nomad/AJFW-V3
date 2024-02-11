if not Framework.AJFW() then return end

local AJFW = exports["aj-base"]:GetCoreObject()

function Framework.GetPlayerID(src)
    local Player = AJFW.Functions.GetPlayer(src)
    if Player then
        return Player.PlayerData.citizenid
    end
end

function Framework.HasMoney(src, type, money)
    local Player = AJFW.Functions.GetPlayer(src)
    return Player.PlayerData.money[type] >= money
end

function Framework.RemoveMoney(src, type, money)
    local Player = AJFW.Functions.GetPlayer(src)
    return Player.Functions.RemoveMoney(type, money)
end

function Framework.GetJob(src)
    local Player = AJFW.Functions.GetPlayer(src)
    return Player.PlayerData.job
end

function Framework.GetGang(src)
    local Player = AJFW.Functions.GetPlayer(src)
    return Player.PlayerData.gang
end

function Framework.SaveAppearance(appearance, citizenID)
    Database.PlayerSkins.UpdateActiveField(citizenID, 0)
    Database.PlayerSkins.DeleteByModel(citizenID, appearance.model)
    Database.PlayerSkins.Add(citizenID, appearance.model, json.encode(appearance), 1)
end

function Framework.GetAppearance(citizenID, model)
    local result = Database.PlayerSkins.GetByCitizenID(citizenID, model)
    if result then
        return json.decode(result)
    end
end
