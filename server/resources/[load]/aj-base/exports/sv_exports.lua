-- Add or change (a) method(s) in the AJFW.Functions table
local function SetMethod(methodName, handler)
    if type(methodName) ~= 'string' then
        return false, 'invalid_method_name'
    end

    AJFW.Functions[methodName] = handler

    TriggerEvent('AJFW:Server:UpdateObject')

    return true, 'success'
end

AJFW.Functions.SetMethod = SetMethod
exports('SetMethod', SetMethod)

-- Add or change (a) field(s) in the AJFW table
local function SetField(fieldName, data)
    if type(fieldName) ~= 'string' then
        return false, 'invalid_field_name'
    end

    AJFW[fieldName] = data

    TriggerEvent('AJFW:Server:UpdateObject')

    return true, 'success'
end

AJFW.Functions.SetField = SetField
exports('SetField', SetField)

-- Single add job function which should only be used if you planning on adding a single job
local function AddJob(jobName, job)
    if type(jobName) ~= 'string' then
        return false, 'invalid_job_name'
    end

    if AJFW.Shared.Jobs[jobName] then
        return false, 'job_exists'
    end

    AJFW.Shared.Jobs[jobName] = job

    TriggerClientEvent('AJFW:Client:OnSharedUpdate', -1, 'Jobs', jobName, job)
    TriggerEvent('AJFW:Server:UpdateObject')
    return true, 'success'
end

AJFW.Functions.AddJob = AddJob
exports('AddJob', AddJob)

-- Multiple Add Jobs
local function AddJobs(jobs)
    local shouldContinue = true
    local message = 'success'
    local errorItem = nil

    for key, value in pairs(jobs) do
        if type(key) ~= 'string' then
            message = 'invalid_job_name'
            shouldContinue = false
            errorItem = jobs[key]
            break
        end

        if AJFW.Shared.Jobs[key] then
            message = 'job_exists'
            shouldContinue = false
            errorItem = jobs[key]
            break
        end

        AJFW.Shared.Jobs[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('AJFW:Client:OnSharedUpdateMultiple', -1, 'Jobs', jobs)
    TriggerEvent('AJFW:Server:UpdateObject')
    return true, message, nil
end

AJFW.Functions.AddJobs = AddJobs
exports('AddJobs', AddJobs)

-- Single Remove Job
local function RemoveJob(jobName)
    if type(jobName) ~= 'string' then
        return false, 'invalid_job_name'
    end

    if not AJFW.Shared.Jobs[jobName] then
        return false, 'job_not_exists'
    end

    AJFW.Shared.Jobs[jobName] = nil

    TriggerClientEvent('AJFW:Client:OnSharedUpdate', -1, 'Jobs', jobName, nil)
    TriggerEvent('AJFW:Server:UpdateObject')
    return true, 'success'
end

AJFW.Functions.RemoveJob = RemoveJob
exports('RemoveJob', RemoveJob)

-- Single Update Job
local function UpdateJob(jobName, job)
    if type(jobName) ~= 'string' then
        return false, 'invalid_job_name'
    end

    if not AJFW.Shared.Jobs[jobName] then
        return false, 'job_not_exists'
    end

    AJFW.Shared.Jobs[jobName] = job

    TriggerClientEvent('AJFW:Client:OnSharedUpdate', -1, 'Jobs', jobName, job)
    TriggerEvent('AJFW:Server:UpdateObject')
    return true, 'success'
end

AJFW.Functions.UpdateJob = UpdateJob
exports('UpdateJob', UpdateJob)

-- Single add item
local function AddItem(itemName, item)
    if type(itemName) ~= 'string' then
        return false, 'invalid_item_name'
    end

    if AJFW.Shared.Items[itemName] then
        return false, 'item_exists'
    end

    AJFW.Shared.Items[itemName] = item

    TriggerClientEvent('AJFW:Client:OnSharedUpdate', -1, 'Items', itemName, item)
    TriggerEvent('AJFW:Server:UpdateObject')
    return true, 'success'
end

AJFW.Functions.AddItem = AddItem
exports('AddItem', AddItem)

-- Single update item
local function UpdateItem(itemName, item)
    if type(itemName) ~= 'string' then
        return false, 'invalid_item_name'
    end
    if not AJFW.Shared.Items[itemName] then
        return false, 'item_not_exists'
    end
    AJFW.Shared.Items[itemName] = item
    TriggerClientEvent('AJFW:Client:OnSharedUpdate', -1, 'Items', itemName, item)
    TriggerEvent('AJFW:Server:UpdateObject')
    return true, 'success'
end

AJFW.Functions.UpdateItem = UpdateItem
exports('UpdateItem', UpdateItem)

-- Multiple Add Items
local function AddItems(items)
    local shouldContinue = true
    local message = 'success'
    local errorItem = nil

    for key, value in pairs(items) do
        if type(key) ~= 'string' then
            message = 'invalid_item_name'
            shouldContinue = false
            errorItem = items[key]
            break
        end

        if AJFW.Shared.Items[key] then
            message = 'item_exists'
            shouldContinue = false
            errorItem = items[key]
            break
        end

        AJFW.Shared.Items[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('AJFW:Client:OnSharedUpdateMultiple', -1, 'Items', items)
    TriggerEvent('AJFW:Server:UpdateObject')
    return true, message, nil
end

AJFW.Functions.AddItems = AddItems
exports('AddItems', AddItems)

-- Single Remove Item
local function RemoveItem(itemName)
    if type(itemName) ~= 'string' then
        return false, 'invalid_item_name'
    end

    if not AJFW.Shared.Items[itemName] then
        return false, 'item_not_exists'
    end

    AJFW.Shared.Items[itemName] = nil

    TriggerClientEvent('AJFW:Client:OnSharedUpdate', -1, 'Items', itemName, nil)
    TriggerEvent('AJFW:Server:UpdateObject')
    return true, 'success'
end

AJFW.Functions.RemoveItem = RemoveItem
exports('RemoveItem', RemoveItem)

-- Single Add Gang
local function AddGang(gangName, gang)
    if type(gangName) ~= 'string' then
        return false, 'invalid_gang_name'
    end

    if AJFW.Shared.Gangs[gangName] then
        return false, 'gang_exists'
    end

    AJFW.Shared.Gangs[gangName] = gang

    TriggerClientEvent('AJFW:Client:OnSharedUpdate', -1, 'Gangs', gangName, gang)
    TriggerEvent('AJFW:Server:UpdateObject')
    return true, 'success'
end

AJFW.Functions.AddGang = AddGang
exports('AddGang', AddGang)

-- Multiple Add Gangs
local function AddGangs(gangs)
    local shouldContinue = true
    local message = 'success'
    local errorItem = nil

    for key, value in pairs(gangs) do
        if type(key) ~= 'string' then
            message = 'invalid_gang_name'
            shouldContinue = false
            errorItem = gangs[key]
            break
        end

        if AJFW.Shared.Gangs[key] then
            message = 'gang_exists'
            shouldContinue = false
            errorItem = gangs[key]
            break
        end

        AJFW.Shared.Gangs[key] = value
    end

    if not shouldContinue then return false, message, errorItem end
    TriggerClientEvent('AJFW:Client:OnSharedUpdateMultiple', -1, 'Gangs', gangs)
    TriggerEvent('AJFW:Server:UpdateObject')
    return true, message, nil
end

AJFW.Functions.AddGangs = AddGangs
exports('AddGangs', AddGangs)

-- Single Remove Gang
local function RemoveGang(gangName)
    if type(gangName) ~= 'string' then
        return false, 'invalid_gang_name'
    end

    if not AJFW.Shared.Gangs[gangName] then
        return false, 'gang_not_exists'
    end

    AJFW.Shared.Gangs[gangName] = nil

    TriggerClientEvent('AJFW:Client:OnSharedUpdate', -1, 'Gangs', gangName, nil)
    TriggerEvent('AJFW:Server:UpdateObject')
    return true, 'success'
end

AJFW.Functions.RemoveGang = RemoveGang
exports('RemoveGang', RemoveGang)

-- Single Update Gang
local function UpdateGang(gangName, gang)
    if type(gangName) ~= 'string' then
        return false, 'invalid_gang_name'
    end

    if not AJFW.Shared.Gangs[gangName] then
        return false, 'gang_not_exists'
    end

    AJFW.Shared.Gangs[gangName] = gang

    TriggerClientEvent('AJFW:Client:OnSharedUpdate', -1, 'Gangs', gangName, gang)
    TriggerEvent('AJFW:Server:UpdateObject')
    return true, 'success'
end

AJFW.Functions.UpdateGang = UpdateGang
exports('UpdateGang', UpdateGang)

local function GetCoreVersion(InvokingResource)
    local resourceVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
    if InvokingResource and InvokingResource ~= '' then
        print(('%s called ajfw version check: %s'):format(InvokingResource or 'Unknown Resource', resourceVersion))
    end
    return resourceVersion
end

AJFW.Functions.GetCoreVersion = GetCoreVersion
exports('GetCoreVersion', GetCoreVersion)

local function ExploitBan(playerId, origin)
    local name = GetPlayerName(playerId)
    MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        name,
        AJFW.Functions.GetIdentifier(playerId, 'license'),
        AJFW.Functions.GetIdentifier(playerId, 'discord'),
        AJFW.Functions.GetIdentifier(playerId, 'ip'),
        origin,
        2147483647,
        'Anti Cheat'
    })
    DropPlayer(playerId, Lang:t('info.exploit_banned', { discord = AJFW.Config.Server.Discord }))
    TriggerEvent('aj-log:server:CreateLog', 'anticheat', 'Anti-Cheat', 'red', name .. ' has been banned for exploiting ' .. origin, true)
end

exports('ExploitBan', ExploitBan)