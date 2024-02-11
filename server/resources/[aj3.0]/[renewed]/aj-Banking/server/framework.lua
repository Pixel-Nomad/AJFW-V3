local Framework = Config.framework == 'aj' and 'aj' or Config.framework == 'esx' and 'esx' or 'Unknown'
local AJFW, ESX, Jobs, Gangs = nil, nil, nil, nil
local deadPlayers = {}

CreateThread(function()
    if Framework == 'Unknown' then
        StopResource(GetCurrentResourceName())
    end
    if Framework == 'aj'then
        AJFW = exports['aj-base']:GetCoreObject()
        Jobs = AJFW.Shared.Jobs
        Gangs = AJFW.Shared.Gangs

        -- Backwards Compatability
        ExportHandler("aj-management", "GetAccount", GetAccountMoney)
        ExportHandler("aj-management", "GetGangAccount", GetAccountMoney)
        ExportHandler("aj-management", "AddMoney", AddAccountMoney)
        ExportHandler("aj-management", "AddGangMoney", AddAccountMoney)
        ExportHandler("aj-management", "RemoveMoney", RemoveAccountMoney)
        ExportHandler("aj-management", "RemoveGangMoney", RemoveAccountMoney)
    elseif Framework == 'esx'then
        ESX = exports['es_extended']:getSharedObject()
        ESX.RefreshJobs()
        Jobs = ESX.GetJobs()

        -- Backwards Compatability
        ExportHandler("esx_society", "GetSociety", GetAccountMoney)
        RegisterServerEvent('esx_society:getSociety', GetAccountMoney)
        RegisterServerEvent('esx_society:depositMoney', AddAccountMoney)
        RegisterServerEvent('esx_society:withdrawMoney', RemoveAccountMoney)
    end
end)

function GetSocietyLabel(society)
    if Framework == 'aj' then
        return Jobs[society] and Jobs[society].label or AJFW.Shared.Gangs[society] and AJFW.Shared.Gangs[society].label or society
    elseif Framework == 'esx' then
        return Jobs[society] and Jobs[society].label or society
    end
end

function GetPlayerObject(source)
    if Framework == 'aj' then
        return AJFW.Functions.GetPlayer(source)
    elseif Framework == 'esx' then
        return ESX.GetPlayerFromId(source)
    end
end

function GetPlayerObjectFromID(identifier)
    if Framework == 'aj' then
        identifier = identifier:upper()
        return AJFW.Functions.GetPlayerByCitizenId(identifier)
    elseif Framework == 'esx' then
        return ESX.GetPlayerFromIdentifier(identifier)
    end
end

function GetCharacterName(Player)
    if Framework == 'aj' then
        return ("%s %s"):format(Player.PlayerData.charinfo.firstname, Player.PlayerData.charinfo.lastname)
    elseif Framework == 'esx' then
        return Player.name
    end
end

function GetIdentifier(Player)
    if Framework == 'aj' then
        return Player.PlayerData.citizenid
    elseif Framework == 'esx' then
        return Player.identifier
    end
end

function GetFunds(Player)
    if Framework == 'aj' then
        local funds = {
            cash = Player.PlayerData.money.cash,
            bank = Player.PlayerData.money.bank
        }
        return funds
    elseif Framework == 'esx' then
        local funds = {
            cash = Player.getAccount('money').money,
            bank = Player.getAccount('bank').money
        }
        return funds
    end
end

function AddMoney(Player, Amount, Type, comment)
    if Framework == 'aj' then
        Player.Functions.AddMoney(Type, Amount, comment)
    elseif Framework == 'esx' then
        if Type == 'cash' then
            Player.addAccountMoney('money', Amount, comment)
        elseif Type == 'bank' then
            Player.addAccountMoney('bank', Amount, comment)
        end
    end
end

function RemoveMoney(Player, Amount, Type, comment)
    if Framework == 'aj' then
        local currentAmount = Player.Functions.GetMoney(Type)
        if currentAmount >= Amount then
            Player.Functions.RemoveMoney(Type, Amount, comment)
            return true
        end
    elseif Framework == 'esx' then
        if Type == 'cash' then
            local currentAmount = Player.getAccount('money').money
            if currentAmount >= Amount then
                Player.removeAccountMoney('money', Amount, comment)
                return true
            end
        elseif Type == 'bank' then
            local currentAmount = Player.getAccount('bank').money
            if currentAmount >= Amount then
                Player.removeAccountMoney('bank', Amount, comment)
                return true
            end
        end
    end
    return false
end

function GetJobs(Player)
    if Framework == 'aj' then
        if Config.renewedMultiJob then
            local jobs = exports['aj-phone']:getJobs(Player.PlayerData.citizenid)
            local temp = {}
            for k,v in pairs(jobs) do
                temp[#temp+1] = {
                    name = k,
                    grade = tostring(v.grade)
                }
            end
            return temp
        else
            return {
                name = Player.PlayerData.job.name,
                grade = tostring(Player.PlayerData.job.grade.level)
            }
        end
    elseif Framework == 'esx' then
        return {
            name = Player.job.name,
            grade = tostring(Player.job.grade)
        }
    end
end

function GetGang(Player)
    if Framework == 'aj' then
        return Player.PlayerData.gang.name
    elseif Framework == 'esx' then
        return false
    end
end

function IsJobAuth(job, grade)
    local numGrade = tonumber(grade)
    if Framework == 'aj' then
        return Jobs[job].grades[grade] and Jobs[job].grades[grade].bankAuth or Jobs[job].grades[numGrade] and Jobs[job].grades[numGrade].bankAuth
    elseif Framework == 'esx' then
        return Jobs[job].grades[grade] and Jobs[job].grades[grade].name == 'boss' or Jobs[job].grades[numGrade] and Jobs[job].grades[numGrade].name == 'boss'
    end
end

function IsGangAuth(Player, gang)
    if Framework == 'aj' then
        local grade = tostring(Player.PlayerData.gang.grade.level)
        local gradeNum = tonumber(grade)
        return Gangs[gang].grades[grade] and Gangs[gang].grades[grade].bankAuth or Gangs[gang].grades[gradeNum] and Gangs[gang].grades[gradeNum].bankAuth
    elseif Framework == 'esx' then
        return false
    end
end

function Notify(src, settings)
    TriggerClientEvent("ox_lib:notify", src, settings)
end

function IsDead(Player)
    if Framework == 'aj' then
        return Player.PlayerData.metadata.isdead
    elseif Framework == 'esx' then
        return deadPlayers[Player.source]
    end
end

--Misc Framework Events

AddEventHandler('AJFW:Server:PlayerLoaded', function(Player)
    local cid = Player.PlayerData.citizenid
    UpdatePlayerAccount(cid)
end)

RegisterNetEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function()
	deadPlayers[source] = true
end)

RegisterNetEvent('esx:onPlayerSpawn')
AddEventHandler('esx:onPlayerSpawn', function()
    local Player = GetPlayerObject(source)
    local cid = GetIdentifier(Player)
	if deadPlayers[source] then
		deadPlayers[source] = nil
	end
    UpdatePlayerAccount(cid)
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	if deadPlayers[playerId] then
		deadPlayers[playerId] = nil
	end
end)


AddEventHandler('onResourceStart', function(resourceName)
    Wait(250)
    if resourceName == GetCurrentResourceName() then
        for _, v in ipairs(GetPlayers()) do
            local Player = GetPlayerObject(v)
            if Player then
                local cid = GetIdentifier(Player)
                UpdatePlayerAccount(cid)
            end
        end
    end
end)
