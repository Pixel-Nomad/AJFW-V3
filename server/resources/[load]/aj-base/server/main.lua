AJFW = {}
AJFW.Config = AJConfig
AJFW.Shared = AJShared
AJFW.ClientCallbacks = {}
AJFW.ServerCallbacks = {}
AJFW.Functions = {}
AJFW.Player_Buckets = {}
AJFW.Entity_Buckets = {}
AJFW.UsableItems = {}
AJFW.Players = {}
AJFW.Player = {}

--############## Functions ##################



-- Getters
-- Get your player first and then trigger a function on them
-- ex: local player = AJFW.Functions.GetPlayer(source)
-- ex: local example = player.Functions.functionname(parameter)

---Gets the coordinates of an entity
---@param entity number
---@return vector4
function AJFW.Functions.GetCoords(entity)
    local coords = GetEntityCoords(entity, false)
    local heading = GetEntityHeading(entity)
    return vector4(coords.x, coords.y, coords.z, heading)
end

---Gets player identifier of the given type
---@param source any
---@param idtype string
---@return string?
function AJFW.Functions.GetIdentifier(source, idtype)
    if GetConvarInt('sv_fxdkMode', 0) == 1 then return 'license:fxdk' end
    return GetPlayerIdentifierByType(source, idtype or 'license')
end

---Gets a players server id (source). Returns 0 if no player is found.
---@param identifier string
---@return number
function AJFW.Functions.GetSource(identifier)
    for src, _ in pairs(AJFW.Players) do
        local idens = GetPlayerIdentifiers(src)
        for _, id in pairs(idens) do
            if identifier == id then
                return src
            end
        end
    end
    return 0
end

---Get player with given server id (source)
---@param source any
---@return table
function AJFW.Functions.GetPlayer(source)
    if type(source) == 'number' then
        return AJFW.Players[source]
    else
        return AJFW.Players[AJFW.Functions.GetSource(source)]
    end
end

---Get player by citizen id
---@param citizenid string
---@return table?
function AJFW.Functions.GetPlayerByCitizenId(citizenid)
    for src in pairs(AJFW.Players) do
        if AJFW.Players[src].PlayerData.citizenid == citizenid then
            return AJFW.Players[src]
        end
    end
    return nil
end

---Get offline player by citizen id
---@param citizenid string
---@return table?
function AJFW.Functions.GetOfflinePlayerByCitizenId(citizenid)
    return AJFW.Player.GetOfflinePlayer(citizenid)
end

---Get player by license
---@param license string
---@return table?
function AJFW.Functions.GetPlayerByLicense(license)
    return AJFW.Player.GetPlayerByLicense(license)
end

---Get player by phone number
---@param number number
---@return table?
function AJFW.Functions.GetPlayerByPhone(number)
    for src in pairs(AJFW.Players) do
        if AJFW.Players[src].PlayerData.charinfo.phone == number then
            return AJFW.Players[src]
        end
    end
    return nil
end

---Get player by account id
---@param account string
---@return table?
function AJFW.Functions.GetPlayerByAccount(account)
    for src in pairs(AJFW.Players) do
        if AJFW.Players[src].PlayerData.charinfo.account == account then
            return AJFW.Players[src]
        end
    end
    return nil
end

---Get player passing property and value to check exists
---@param property string
---@param value string
---@return table?
function AJFW.Functions.GetPlayerByCharInfo(property, value)
    for src in pairs(AJFW.Players) do
        local charinfo = AJFW.Players[src].PlayerData.charinfo
        if charinfo[property] ~= nil and charinfo[property] == value then
            return AJFW.Players[src]
        end
    end
    return nil
end

---Get all players. Returns the server ids of all players.
---@return table
function AJFW.Functions.GetPlayers()
    local sources = {}
    for k in pairs(AJFW.Players) do
        sources[#sources + 1] = k
    end
    return sources
end

---Will return an array of AJ Player class instances
---unlike the GetPlayers() wrapper which only returns IDs
---@return table
function AJFW.Functions.GetAJPlayers()
    return AJFW.Players
end

---Gets a list of all on duty players of a specified job and the number
---@param job string
---@return table, number
function AJFW.Functions.GetPlayersOnDuty(job)
    local players = {}
    local count = 0
    for src, Player in pairs(AJFW.Players) do
        if Player.PlayerData.job.name == job then
            if Player.PlayerData.job.onduty then
                players[#players + 1] = src
                count += 1
            end
        end
    end
    return players, count
end

---Returns only the amount of players on duty for the specified job
---@param job any
---@return number
function AJFW.Functions.GetDutyCount(job)
    local count = 0
    for _, Player in pairs(AJFW.Players) do
        if Player.PlayerData.job.name == job then
            if Player.PlayerData.job.onduty then
                count += 1
            end
        end
    end
    return count
end

-- Routing buckets (Only touch if you know what you are doing)

---Returns the objects related to buckets, first returned value is the player buckets, second one is entity buckets
---@return table, table
function AJFW.Functions.GetBucketObjects()
    return AJFW.Player_Buckets, AJFW.Entity_Buckets
end

---Will set the provided player id / source into the provided bucket id
---@param source any
---@param bucket any
---@return boolean
function AJFW.Functions.SetPlayerBucket(source, bucket)
    if source and bucket then
        local plicense = AJFW.Functions.GetIdentifier(source, 'license')
        Player(source).state:set('instance', bucket, true)
        SetPlayerRoutingBucket(source, bucket)
        AJFW.Player_Buckets[plicense] = { id = source, bucket = bucket }
        return true
    else
        return false
    end
end

---Will set any entity into the provided bucket, for example peds / vehicles / props / etc.
---@param entity number
---@param bucket number
---@return boolean
function AJFW.Functions.SetEntityBucket(entity, bucket)
    if entity and bucket then
        SetEntityRoutingBucket(entity, bucket)
        AJFW.Entity_Buckets[entity] = { id = entity, bucket = bucket }
        return true
    else
        return false
    end
end

---Will return an array of all the player ids inside the current bucket
---@param bucket number
---@return table|boolean
function AJFW.Functions.GetPlayersInBucket(bucket)
    local curr_bucket_pool = {}
    if AJFW.Player_Buckets and next(AJFW.Player_Buckets) then
        for _, v in pairs(AJFW.Player_Buckets) do
            if v.bucket == bucket then
                curr_bucket_pool[#curr_bucket_pool + 1] = v.id
            end
        end
        return curr_bucket_pool
    else
        return false
    end
end

---Will return an array of all the entities inside the current bucket
---(not for player entities, use GetPlayersInBucket for that)
---@param bucket number
---@return table|boolean
function AJFW.Functions.GetEntitiesInBucket(bucket)
    local curr_bucket_pool = {}
    if AJFW.Entity_Buckets and next(AJFW.Entity_Buckets) then
        for _, v in pairs(AJFW.Entity_Buckets) do
            if v.bucket == bucket then
                curr_bucket_pool[#curr_bucket_pool + 1] = v.id
            end
        end
        return curr_bucket_pool
    else
        return false
    end
end

---Server side vehicle creation with optional callback
---the CreateVehicle RPC still uses the client for creation so players must be near
---@param source any
---@param model any
---@param coords vector
---@param warp boolean
---@return number
function AJFW.Functions.SpawnVehicle(source, model, coords, warp)
    local ped = GetPlayerPed(source)
    model = type(model) == 'string' and joaat(model) or model
    if not coords then coords = GetEntityCoords(ped) end
    local heading = coords.w and coords.w or 0.0
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, heading, true, true)
    while not DoesEntityExist(veh) do Wait(0) end
    if warp then
        while GetVehiclePedIsIn(ped) ~= veh do
            Wait(0)
            TaskWarpPedIntoVehicle(ped, veh, -1)
        end
    end
    while NetworkGetEntityOwner(veh) ~= source do Wait(0) end
    return veh
end

---Server side vehicle creation with optional callback
---the CreateAutomobile native is still experimental but doesn't use client for creation
---doesn't work for all vehicles!
---comment
---@param source any
---@param model any
---@param coords vector
---@param warp boolean
---@return number
function AJFW.Functions.CreateAutomobile(source, model, coords, warp)
    model = type(model) == 'string' and joaat(model) or model
    if not coords then coords = GetEntityCoords(GetPlayerPed(source)) end
    local heading = coords.w and coords.w or 0.0
    local CreateAutomobile = `CREATE_AUTOMOBILE`
    local veh = Citizen.InvokeNative(CreateAutomobile, model, coords, heading, true, true)
    while not DoesEntityExist(veh) do Wait(0) end
    if warp then TaskWarpPedIntoVehicle(GetPlayerPed(source), veh, -1) end
    return veh
end

--- New & more reliable server side native for creating vehicles
---comment
---@param source any
---@param model any
---@param vehtype any
-- The appropriate vehicle type for the model info.
-- Can be one of automobile, bike, boat, heli, plane, submarine, trailer, and (potentially), train.
-- This should be the same type as the type field in vehicles.meta.
---@param coords vector
---@param warp boolean
---@return number
function AJFW.Functions.CreateVehicle(source, model, vehtype, coords, warp)
    model = type(model) == 'string' and joaat(model) or model
    vehtype = type(vehtype) == 'string' and tostring(vehtype) or vehtype
    if not coords then coords = GetEntityCoords(GetPlayerPed(source)) end
    local heading = coords.w and coords.w or 0.0
    local veh = CreateVehicleServerSetter(model, vehtype, coords, heading)
    while not DoesEntityExist(veh) do Wait(0) end
    if warp then TaskWarpPedIntoVehicle(GetPlayerPed(source), veh, -1) end
    return veh
end

---Paychecks (standalone - don't touch)
function PaycheckInterval()
    if next(AJFW.Players) then
        for _, Player in pairs(AJFW.Players) do
            if Player then
                local payment = AJShared.Jobs[Player.PlayerData.job.name]['grades'][tostring(Player.PlayerData.job.grade.level)].payment
                if not payment then payment = Player.PlayerData.job.payment end
                if Player.PlayerData.job and payment > 0 and (AJShared.Jobs[Player.PlayerData.job.name].offDutyPay or Player.PlayerData.job.onduty) then
                    if AJFW.Config.Money.PayCheckSociety then
                        local account = exports['aj-banking']:GetAccountBalance(Player.PlayerData.job.name)
                        if account ~= 0 then          -- Checks if player is employed by a society
                            if account < payment then -- Checks if company has enough money to pay society
                                TriggerClientEvent('AJFW:Notify', Player.PlayerData.source, Lang:t('error.company_too_poor'), 'error')
                            else
                                Player.Functions.AddMoney('bank', payment, 'paycheck')
                                exports['aj-banking']:RemoveMoney(Player.PlayerData.job.name, payment, 'Employee Paycheck')
                                TriggerClientEvent('AJFW:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', { value = payment }))
                            end
                        else
                            Player.Functions.AddMoney('bank', payment, 'paycheck')
                            TriggerClientEvent('AJFW:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', { value = payment }))
                        end
                    else
                        Player.Functions.AddMoney('bank', payment, 'paycheck')
                        TriggerClientEvent('AJFW:Notify', Player.PlayerData.source, Lang:t('info.received_paycheck', { value = payment }))
                    end
                end
            end
        end
    end
    SetTimeout(AJFW.Config.Money.PayCheckTimeOut * (60 * 1000), PaycheckInterval)
end

-- Callback Functions --

---Trigger Client Callback
---@param name string
---@param source any
---@param cb function
---@param ... any
function AJFW.Functions.TriggerClientCallback(name, source, cb, ...)
    AJFW.ClientCallbacks[name] = cb
    TriggerClientEvent('AJFW:Client:TriggerClientCallback', source, name, ...)
end

---Create Server Callback
---@param name string
---@param cb function
function AJFW.Functions.CreateCallback(name, cb)
    AJFW.ServerCallbacks[name] = cb
end

---Trigger Serv er Callback
---@param name string
---@param source any
---@param cb function
---@param ... any
function AJFW.Functions.TriggerCallback(name, source, cb, ...)
    if not AJFW.ServerCallbacks[name] then return end
    AJFW.ServerCallbacks[name](source, cb, ...)
end

-- Items

---Create a usable item
---@param item string
---@param data function
function AJFW.Functions.CreateUseableItem(item, data)
    AJFW.UsableItems[item] = data
end

---Checks if the given item is usable
---@param item string
---@return any
function AJFW.Functions.CanUseItem(item)
    return AJFW.UsableItems[item]
end

---Use item
---@param source any
---@param item string
function AJFW.Functions.UseItem(source, item)
    if GetResourceState('aj-inventory') == 'missing' then return end
    exports['aj-inventory']:UseItem(source, item)
end

---Kick Player
---@param source any
---@param reason string
---@param setKickReason boolean
---@param deferrals boolean
function AJFW.Functions.Kick(source, reason, setKickReason, deferrals)
    reason = '\n' .. reason .. '\n🔸 Check our Discord for further information: ' .. AJFW.Config.Server.Discord
    if setKickReason then
        setKickReason(reason)
    end
    CreateThread(function()
        if deferrals then
            deferrals.update(reason)
            Wait(2500)
        end
        if source then
            DropPlayer(source, reason)
        end
        for _ = 0, 4 do
            while true do
                if source then
                    if GetPlayerPing(source) >= 0 then
                        break
                    end
                    Wait(100)
                    CreateThread(function()
                        DropPlayer(source, reason)
                    end)
                end
            end
            Wait(5000)
        end
    end)
end

---Check if player is whitelisted, kept like this for backwards compatibility or future plans
---@param source any
---@return boolean
function AJFW.Functions.IsWhitelisted(source)
    if not AJFW.Config.Server.Whitelist then return true end
    if AJFW.Functions.HasPermission(source, AJFW.Config.Server.WhitelistPermission) then return true end
    return false
end

-- Setting & Removing Permissions

---Add permission for player
---@param source any
---@param permission string
function AJFW.Functions.AddPermission(source, permission)
    if not IsPlayerAceAllowed(source, permission) then
        ExecuteCommand(('add_principal player.%s ajfw.%s'):format(source, permission))
        AJFW.Commands.Refresh(source)
    end
end

---Remove permission from player
---@param source any
---@param permission string
function AJFW.Functions.RemovePermission(source, permission)
    if permission then
        if IsPlayerAceAllowed(source, permission) then
            ExecuteCommand(('remove_principal player.%s ajfw.%s'):format(source, permission))
            AJFW.Commands.Refresh(source)
        end
    else
        for _, v in pairs(AJFW.Config.Server.Permissions) do
            if IsPlayerAceAllowed(source, v) then
                ExecuteCommand(('remove_principal player.%s ajfw.%s'):format(source, v))
                AJFW.Commands.Refresh(source)
            end
        end
    end
end

-- Checking for Permission Level

---Check if player has permission
---@param source any
---@param permission string
---@return boolean
function AJFW.Functions.HasPermission(source, permission)
    if type(permission) == 'string' then
        if IsPlayerAceAllowed(source, permission) then return true end
    elseif type(permission) == 'table' then
        for _, permLevel in pairs(permission) do
            if IsPlayerAceAllowed(source, permLevel) then return true end
        end
    end

    return false
end

---Get the players permissions
---@param source any
---@return table
function AJFW.Functions.GetPermission(source)
    local src = source
    local perms = {}
    for _, v in pairs(AJFW.Config.Server.Permissions) do
        if IsPlayerAceAllowed(src, v) then
            perms[v] = true
        end
    end
    return perms
end

---Get admin messages opt-in state for player
---@param source any
---@return boolean
function AJFW.Functions.IsOptin(source)
    local license = AJFW.Functions.GetIdentifier(source, 'license')
    if not license or not AJFW.Functions.HasPermission(source, 'admin') then return false end
    local Player = AJFW.Functions.GetPlayer(source)
    return Player.PlayerData.optin
end

---Toggle opt-in to admin messages
---@param source any
function AJFW.Functions.ToggleOptin(source)
    local license = AJFW.Functions.GetIdentifier(source, 'license')
    if not license or not AJFW.Functions.HasPermission(source, 'admin') then return end
    local Player = AJFW.Functions.GetPlayer(source)
    Player.PlayerData.optin = not Player.PlayerData.optin
    Player.Functions.SetPlayerData('optin', Player.PlayerData.optin)
end

---Check if player is banned
---@param source any
---@return boolean, string?
function AJFW.Functions.IsPlayerBanned(source)
    local plicense = AJFW.Functions.GetIdentifier(source, 'license')
    local result = MySQL.single.await('SELECT * FROM bans WHERE license = ?', { plicense })
    if not result then return false end
    if os.time() < result.expire then
        local timeTable = os.date('*t', tonumber(result.expire))
        return true, 'You have been banned from the server:\n' .. result.reason .. '\nYour ban expires ' .. timeTable.day .. '/' .. timeTable.month .. '/' .. timeTable.year .. ' ' .. timeTable.hour .. ':' .. timeTable.min .. '\n'
    else
        MySQL.query('DELETE FROM bans WHERE id = ?', { result.id })
    end
    return false
end

---Check for duplicate license
---@param license any
---@return boolean
function AJFW.Functions.IsLicenseInUse(license)
    local players = GetPlayers()
    for _, player in pairs(players) do
        local playerLicense = AJFW.Functions.GetIdentifier(player, 'license')
        if playerLicense == license then return true end
    end
    return false
end

-- Utility functions

---Check if a player has an item [deprecated]
---@param source any
---@param items table|string
---@param amount number
---@return boolean
function AJFW.Functions.HasItem(source, items, amount)
    if GetResourceState('aj-inventory') == 'missing' then return end
    return exports['aj-inventory']:HasItem(source, items, amount)
end

---Notify
---@param source any
---@param text string
---@param type string
---@param length number
function AJFW.Functions.Notify(source, text, type, length)
    TriggerClientEvent('AJFW:Notify', source, text, type, length)
end

---???? ... ok
---@param source any
---@param data any
---@param pattern any
---@return boolean
function AJFW.Functions.PrepForSQL(source, data, pattern)
    data = tostring(data)
    local src = source
    local player = AJFW.Functions.GetPlayer(src)
    local result = string.match(data, pattern)
    if not result or string.len(result) ~= string.len(data) then
        TriggerEvent('aj-log:server:CreateLog', 'anticheat', 'SQL Exploit Attempted', 'red', string.format('%s attempted to exploit SQL!', player.PlayerData.license))
        return false
    end
    return true
end



-- On player login get their data or set defaults
-- Don't touch any of this unless you know what you are doing
-- Will cause major issues!

function AJFW.Player.Login(source, citizenid, newData)
    if source and source ~= '' then
        if citizenid then
            local license = AJFW.Functions.GetIdentifier(source, 'license')
            local PlayerData = MySQL.prepare.await('SELECT * FROM players where citizenid = ?', { citizenid })
            if PlayerData and license == PlayerData.license then
                PlayerData.money = json.decode(PlayerData.money)
                PlayerData.job = json.decode(PlayerData.job)
                PlayerData.position = json.decode(PlayerData.position)
                PlayerData.metadata = json.decode(PlayerData.metadata)
                PlayerData.charinfo = json.decode(PlayerData.charinfo)
                if PlayerData.gang then
                    PlayerData.gang = json.decode(PlayerData.gang)
                else
                    PlayerData.gang = {}
                end
                AJFW.Player.CheckPlayerData(source, PlayerData)
            else
                DropPlayer(source, Lang:t('info.exploit_dropped'))
                TriggerEvent('aj-log:server:CreateLog', 'anticheat', 'Anti-Cheat', 'white', GetPlayerName(source) .. ' Has Been Dropped For Character Joining Exploit', false)
            end
        else
            AJFW.Player.CheckPlayerData(source, newData)
        end
        return true
    else
        AJFW.ShowError(GetCurrentResourceName(), 'ERROR AJFW.PLAYER.LOGIN - NO SOURCE GIVEN!')
        return false
    end
end

function AJFW.Player.GetOfflinePlayer(citizenid)
    if citizenid then
        local PlayerData = MySQL.prepare.await('SELECT * FROM players where citizenid = ?', { citizenid })
        if PlayerData then
            PlayerData.money = json.decode(PlayerData.money)
            PlayerData.job = json.decode(PlayerData.job)
            PlayerData.position = json.decode(PlayerData.position)
            PlayerData.metadata = json.decode(PlayerData.metadata)
            PlayerData.charinfo = json.decode(PlayerData.charinfo)
            if PlayerData.gang then
                PlayerData.gang = json.decode(PlayerData.gang)
            else
                PlayerData.gang = {}
            end

            return AJFW.Player.CheckPlayerData(nil, PlayerData)
        end
    end
    return nil
end

function AJFW.Player.GetPlayerByLicense(license)
    if license then
        local PlayerData = MySQL.prepare.await('SELECT * FROM players where license = ?', { license })
        if PlayerData then
            PlayerData.money = json.decode(PlayerData.money)
            PlayerData.job = json.decode(PlayerData.job)
            PlayerData.position = json.decode(PlayerData.position)
            PlayerData.metadata = json.decode(PlayerData.metadata)
            PlayerData.charinfo = json.decode(PlayerData.charinfo)
            if PlayerData.gang then
                PlayerData.gang = json.decode(PlayerData.gang)
            else
                PlayerData.gang = {}
            end

            return AJFW.Player.CheckPlayerData(nil, PlayerData)
        end
    end
    return nil
end

function AJFW.Player.CheckPlayerData(source, PlayerData)
    PlayerData = PlayerData or {}
    local Offline = true
    if source then
        PlayerData.source = source
        PlayerData.license = PlayerData.license or AJFW.Functions.GetIdentifier(source, 'license')
        PlayerData.name = GetPlayerName(source)
        Offline = false
    end

    PlayerData.citizenid = PlayerData.citizenid or AJFW.Player.CreateCitizenId()
    PlayerData.cid = PlayerData.cid or 1
    PlayerData.money = PlayerData.money or {}
    PlayerData.optin = PlayerData.optin or true
    for moneytype, startamount in pairs(AJFW.Config.Money.MoneyTypes) do
        PlayerData.money[moneytype] = PlayerData.money[moneytype] or startamount
    end

    -- Charinfo
    PlayerData.charinfo = PlayerData.charinfo or {}
    PlayerData.charinfo.firstname = PlayerData.charinfo.firstname or 'Firstname'
    PlayerData.charinfo.lastname = PlayerData.charinfo.lastname or 'Lastname'
    PlayerData.charinfo.birthdate = PlayerData.charinfo.birthdate or '00-00-0000'
    PlayerData.charinfo.gender = PlayerData.charinfo.gender or 0
    PlayerData.charinfo.backstory = PlayerData.charinfo.backstory or 'placeholder backstory'
    PlayerData.charinfo.nationality = PlayerData.charinfo.nationality or 'USA'
    PlayerData.charinfo.phone = PlayerData.charinfo.phone or AJFW.Functions.CreatePhoneNumber()
    PlayerData.charinfo.account = PlayerData.charinfo.account or AJFW.Functions.CreateAccountNumber()
    -- Metadata
    PlayerData.metadata = PlayerData.metadata or {}
    PlayerData.metadata['hunger'] = PlayerData.metadata['hunger'] or 100
    PlayerData.metadata['thirst'] = PlayerData.metadata['thirst'] or 100
    PlayerData.metadata['stress'] = PlayerData.metadata['stress'] or 0
    PlayerData.metadata['isdead'] = PlayerData.metadata['isdead'] or false
    PlayerData.metadata['inlaststand'] = PlayerData.metadata['inlaststand'] or false
    PlayerData.metadata['armor'] = PlayerData.metadata['armor'] or 0
    PlayerData.metadata['ishandcuffed'] = PlayerData.metadata['ishandcuffed'] or false
    PlayerData.metadata['tracker'] = PlayerData.metadata['tracker'] or false
    PlayerData.metadata['injail'] = PlayerData.metadata['injail'] or 0
    PlayerData.metadata['jailitems'] = PlayerData.metadata['jailitems'] or {}
    PlayerData.metadata['status'] = PlayerData.metadata['status'] or {}
    PlayerData.metadata['phone'] = PlayerData.metadata['phone'] or {}
    PlayerData.metadata['fitbit'] = PlayerData.metadata['fitbit'] or {}
    PlayerData.metadata['bloodtype'] = PlayerData.metadata['bloodtype'] or AJFW.Config.Player.Bloodtypes[math.random(1, #AJFW.Config.Player.Bloodtypes)]
    PlayerData.metadata['dealerrep'] = PlayerData.metadata['dealerrep'] or 0
    PlayerData.metadata['craftingrep'] = PlayerData.metadata['craftingrep'] or 0
    PlayerData.metadata['attachmentcraftingrep'] = PlayerData.metadata['attachmentcraftingrep'] or 0
    PlayerData.metadata['currentapartment'] = PlayerData.metadata['currentapartment'] or nil
    PlayerData.metadata['jobrep'] = PlayerData.metadata['jobrep'] or {}
    PlayerData.metadata['jobrep']['tow'] = PlayerData.metadata['jobrep']['tow'] or 0
    PlayerData.metadata['jobrep']['trucker'] = PlayerData.metadata['jobrep']['trucker'] or 0
    PlayerData.metadata['jobrep']['taxi'] = PlayerData.metadata['jobrep']['taxi'] or 0
    PlayerData.metadata['jobrep']['hotdog'] = PlayerData.metadata['jobrep']['hotdog'] or 0
    PlayerData.metadata['callsign'] = PlayerData.metadata['callsign'] or 'NO CALLSIGN'
    PlayerData.metadata['fingerprint'] = PlayerData.metadata['fingerprint'] or AJFW.Player.CreateFingerId()
    PlayerData.metadata['walletid'] = PlayerData.metadata['walletid'] or AJFW.Player.CreateWalletId()
    PlayerData.metadata['criminalrecord'] = PlayerData.metadata['criminalrecord'] or {
        ['hasRecord'] = false,
        ['date'] = nil
    }
    PlayerData.metadata['licences'] = PlayerData.metadata['licences'] or {
        ['driver'] = true,
        ['business'] = false,
        ['weapon'] = false
    }
    PlayerData.metadata['inside'] = PlayerData.metadata['inside'] or {
        house = nil,
        apartment = {
            apartmentType = nil,
            apartmentId = nil,
        }
    }
    PlayerData.metadata['phonedata'] = PlayerData.metadata['phonedata'] or {
        SerialNumber = AJFW.Player.CreateSerialNumber(),
        InstalledApps = {},
    }
    -- Job
    if PlayerData.job and PlayerData.job.name and not AJFW.Shared.Jobs[PlayerData.job.name] then PlayerData.job = nil end
    PlayerData.job = PlayerData.job or {}
    PlayerData.job.name = PlayerData.job.name or 'unemployed'
    PlayerData.job.label = PlayerData.job.label or 'Civilian'
    PlayerData.job.payment = PlayerData.job.payment or 10
    PlayerData.job.type = PlayerData.job.type or 'none'
    if AJFW.Shared.ForceJobDefaultDutyAtLogin or PlayerData.job.onduty == nil then
        PlayerData.job.onduty = AJFW.Shared.Jobs[PlayerData.job.name].defaultDuty
    end
    PlayerData.job.isboss = PlayerData.job.isboss or false
    PlayerData.job.grade = PlayerData.job.grade or {}
    PlayerData.job.grade.name = PlayerData.job.grade.name or 'Freelancer'
    PlayerData.job.grade.level = PlayerData.job.grade.level or 0
    -- Gang
    if PlayerData.gang and PlayerData.gang.name and not AJFW.Shared.Gangs[PlayerData.gang.name] then PlayerData.gang = nil end
    PlayerData.gang = PlayerData.gang or {}
    PlayerData.gang.name = PlayerData.gang.name or 'none'
    PlayerData.gang.label = PlayerData.gang.label or 'No Gang Affiliaton'
    PlayerData.gang.isboss = PlayerData.gang.isboss or false
    PlayerData.gang.grade = PlayerData.gang.grade or {}
    PlayerData.gang.grade.name = PlayerData.gang.grade.name or 'none'
    PlayerData.gang.grade.level = PlayerData.gang.grade.level or 0
    -- Other
    PlayerData.position = PlayerData.position or AJFW.Config.DefaultSpawn
    PlayerData.items = GetResourceState('aj-inventory') ~= 'missing' and exports['aj-inventory']:LoadInventory(PlayerData.source, PlayerData.citizenid) or {}
    return AJFW.Player.CreatePlayer(PlayerData, Offline)
end

-- On player logout

function AJFW.Player.Logout(source)
    TriggerClientEvent('AJFW:Client:OnPlayerUnload', source)
    TriggerEvent('AJFW:Server:OnPlayerUnload', source)
    TriggerClientEvent('AJFW:Player:UpdatePlayerData', source)
    Wait(200)
    AJFW.Players[source] = nil
end

-- Create a new character
-- Don't touch any of this unless you know what you are doing
-- Will cause major issues!

function AJFW.Player.CreatePlayer(PlayerData, Offline)
    local self = {}
    self.Functions = {}
    self.PlayerData = PlayerData
    self.Offline = Offline

    function self.Functions.UpdatePlayerData()
        if self.Offline then return end -- Unsupported for Offline Players
        TriggerEvent('AJFW:Player:SetPlayerData', self.PlayerData)
        TriggerClientEvent('AJFW:Player:SetPlayerData', self.PlayerData.source, self.PlayerData)
    end

    function self.Functions.SetJob(job, grade)
        job = job:lower()
        grade = tostring(grade) or '0'
        if not AJFW.Shared.Jobs[job] then return false end
        self.PlayerData.job.name = job
        self.PlayerData.job.label = AJFW.Shared.Jobs[job].label
        self.PlayerData.job.onduty = AJFW.Shared.Jobs[job].defaultDuty
        self.PlayerData.job.type = AJFW.Shared.Jobs[job].type or 'none'
        if AJFW.Shared.Jobs[job].grades[grade] then
            local jobgrade = AJFW.Shared.Jobs[job].grades[grade]
            self.PlayerData.job.grade = {}
            self.PlayerData.job.grade.name = jobgrade.name
            self.PlayerData.job.grade.level = tonumber(grade)
            self.PlayerData.job.payment = jobgrade.payment or 30
            self.PlayerData.job.isboss = jobgrade.isboss or false
        else
            self.PlayerData.job.grade = {}
            self.PlayerData.job.grade.name = 'No Grades'
            self.PlayerData.job.grade.level = 0
            self.PlayerData.job.payment = 30
            self.PlayerData.job.isboss = false
        end

        if not self.Offline then
            self.Functions.UpdatePlayerData()
            TriggerEvent('AJFW:Server:OnJobUpdate', self.PlayerData.source, self.PlayerData.job)
            TriggerClientEvent('AJFW:Client:OnJobUpdate', self.PlayerData.source, self.PlayerData.job)
        end

        return true
    end

    function self.Functions.SetGang(gang, grade)
        gang = gang:lower()
        grade = tostring(grade) or '0'
        if not AJFW.Shared.Gangs[gang] then return false end
        self.PlayerData.gang.name = gang
        self.PlayerData.gang.label = AJFW.Shared.Gangs[gang].label
        if AJFW.Shared.Gangs[gang].grades[grade] then
            local ganggrade = AJFW.Shared.Gangs[gang].grades[grade]
            self.PlayerData.gang.grade = {}
            self.PlayerData.gang.grade.name = ganggrade.name
            self.PlayerData.gang.grade.level = tonumber(grade)
            self.PlayerData.gang.isboss = ganggrade.isboss or false
        else
            self.PlayerData.gang.grade = {}
            self.PlayerData.gang.grade.name = 'No Grades'
            self.PlayerData.gang.grade.level = 0
            self.PlayerData.gang.isboss = false
        end

        if not self.Offline then
            self.Functions.UpdatePlayerData()
            TriggerEvent('AJFW:Server:OnGangUpdate', self.PlayerData.source, self.PlayerData.gang)
            TriggerClientEvent('AJFW:Client:OnGangUpdate', self.PlayerData.source, self.PlayerData.gang)
        end

        return true
    end

    function self.Functions.Notify(text, type, lenght)
        TriggerClientEvent('AJFW:Notify', self.PlayerData.source, text, type, lenght)
    end

    function self.Functions.HasItem(items, amount)
        AJFW.Functions.HasItem(self.PlayerData.source, items, amount)
    end

    function self.Functions.SetJobDuty(onDuty)
        self.PlayerData.job.onduty = not not onDuty -- Make sure the value is a boolean if nil is sent
        TriggerEvent('AJFW:Server:OnJobUpdate', self.PlayerData.source, self.PlayerData.job)
        TriggerClientEvent('AJFW:Client:OnJobUpdate', self.PlayerData.source, self.PlayerData.job)
        self.Functions.UpdatePlayerData()
    end

    function self.Functions.SetPlayerData(key, val)
        if not key or type(key) ~= 'string' then return end
        self.PlayerData[key] = val
        self.Functions.UpdatePlayerData()
    end

    function self.Functions.SetMetaData(meta, val)
        if not meta or type(meta) ~= 'string' then return end
        if meta == 'hunger' or meta == 'thirst' then
            val = val > 100 and 100 or val
        end
        self.PlayerData.metadata[meta] = val
        self.Functions.UpdatePlayerData()
    end

    function self.Functions.GetMetaData(meta)
        if not meta or type(meta) ~= 'string' then return end
        return self.PlayerData.metadata[meta]
    end

    function self.Functions.AddJobReputation(amount)
        if not amount then return end
        amount = tonumber(amount)
        self.PlayerData.metadata['jobrep'][self.PlayerData.job.name] = self.PlayerData.metadata['jobrep'][self.PlayerData.job.name] + amount
        self.Functions.UpdatePlayerData()
    end

    function self.Functions.AddMoney(moneytype, amount, reason)
        reason = reason or 'unknown'
        moneytype = moneytype:lower()
        amount = tonumber(amount)
        if amount < 0 then return end
        if not self.PlayerData.money[moneytype] then return false end
        self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] + amount

        if not self.Offline then
            self.Functions.UpdatePlayerData()
            if amount > 100000 then
                TriggerEvent('aj-log:server:CreateLog', 'playermoney', 'AddMoney', 'lightgreen', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') added, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason, true)
            else
                TriggerEvent('aj-log:server:CreateLog', 'playermoney', 'AddMoney', 'lightgreen', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') added, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason)
            end
            TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, false)
            TriggerClientEvent('AJFW:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'add', reason)
            TriggerEvent('AJFW:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'add', reason)
        end

        return true
    end

    function self.Functions.RemoveMoney(moneytype, amount, reason)
        reason = reason or 'unknown'
        moneytype = moneytype:lower()
        amount = tonumber(amount)
        if amount < 0 then return end
        if not self.PlayerData.money[moneytype] then return false end
        for _, mtype in pairs(AJFW.Config.Money.DontAllowMinus) do
            if mtype == moneytype then
                if (self.PlayerData.money[moneytype] - amount) < 0 then
                    return false
                end
            end
        end
        self.PlayerData.money[moneytype] = self.PlayerData.money[moneytype] - amount

        if not self.Offline then
            self.Functions.UpdatePlayerData()
            if amount > 100000 then
                TriggerEvent('aj-log:server:CreateLog', 'playermoney', 'RemoveMoney', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') removed, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason, true)
            else
                TriggerEvent('aj-log:server:CreateLog', 'playermoney', 'RemoveMoney', 'red', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') removed, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason)
            end
            TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, true)
            if moneytype == 'bank' then
                TriggerClientEvent('aj-phone:client:RemoveBankMoney', self.PlayerData.source, amount)
            end
            TriggerClientEvent('AJFW:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'remove', reason)
            TriggerEvent('AJFW:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'remove', reason)
        end

        return true
    end

    function self.Functions.SetMoney(moneytype, amount, reason)
        reason = reason or 'unknown'
        moneytype = moneytype:lower()
        amount = tonumber(amount)
        if amount < 0 then return false end
        if not self.PlayerData.money[moneytype] then return false end
        local difference = amount - self.PlayerData.money[moneytype]
        self.PlayerData.money[moneytype] = amount

        if not self.Offline then
            self.Functions.UpdatePlayerData()
            TriggerEvent('aj-log:server:CreateLog', 'playermoney', 'SetMoney', 'green', '**' .. GetPlayerName(self.PlayerData.source) .. ' (citizenid: ' .. self.PlayerData.citizenid .. ' | id: ' .. self.PlayerData.source .. ')** $' .. amount .. ' (' .. moneytype .. ') set, new ' .. moneytype .. ' balance: ' .. self.PlayerData.money[moneytype] .. ' reason: ' .. reason)
            TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, math.abs(difference), difference < 0)
            TriggerClientEvent('AJFW:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'set', reason)
            TriggerEvent('AJFW:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'set', reason)
        end

        return true
    end

    function self.Functions.GetMoney(moneytype)
        if not moneytype then return false end
        moneytype = moneytype:lower()
        return self.PlayerData.money[moneytype]
    end

    function self.Functions.SetCreditCard(cardNumber)
        self.PlayerData.charinfo.card = cardNumber
        self.Functions.UpdatePlayerData()
    end

    function self.Functions.GetCardSlot(cardNumber, cardType)
        local item = tostring(cardType):lower()
        local slots = exports['aj-inventory']:GetSlotsByItem(self.PlayerData.items, item)
        for _, slot in pairs(slots) do
            if slot then
                if self.PlayerData.items[slot].info.cardNumber == cardNumber then
                    return slot
                end
            end
        end
        return nil
    end

    function self.Functions.Save()
        if self.Offline then
            AJFW.Player.SaveOffline(self.PlayerData)
        else
            AJFW.Player.Save(self.PlayerData.source)
        end
    end

    function self.Functions.Logout()
        if self.Offline then return end -- Unsupported for Offline Players
        AJFW.Player.Logout(self.PlayerData.source)
    end

    function self.Functions.AddMethod(methodName, handler)
        self.Functions[methodName] = handler
    end

    function self.Functions.AddField(fieldName, data)
        self[fieldName] = data
    end

    if self.Offline then
        return self
    else
        AJFW.Players[self.PlayerData.source] = self
        AJFW.Player.Save(self.PlayerData.source)

        -- At this point we are safe to emit new instance to third party resource for load handling
        TriggerEvent('AJFW:Server:PlayerLoaded', self)
        self.Functions.UpdatePlayerData()
    end
end

-- Add a new function to the Functions table of the player class
-- Use-case:
--[[
    AddEventHandler('AJFW:Server:PlayerLoaded', function(Player)
        AJFW.Functions.AddPlayerMethod(Player.PlayerData.source, "functionName", function(oneArg, orMore)
            -- do something here
        end)
    end)
]]

function AJFW.Functions.AddPlayerMethod(ids, methodName, handler)
    local idType = type(ids)
    if idType == 'number' then
        if ids == -1 then
            for _, v in pairs(AJFW.Players) do
                v.Functions.AddMethod(methodName, handler)
            end
        else
            if not AJFW.Players[ids] then return end

            AJFW.Players[ids].Functions.AddMethod(methodName, handler)
        end
    elseif idType == 'table' and table.type(ids) == 'array' then
        for i = 1, #ids do
            AJFW.Functions.AddPlayerMethod(ids[i], methodName, handler)
        end
    end
end

-- Add a new field table of the player class
-- Use-case:
--[[
    AddEventHandler('AJFW:Server:PlayerLoaded', function(Player)
        AJFW.Functions.AddPlayerField(Player.PlayerData.source, "fieldName", "fieldData")
    end)
]]

function AJFW.Functions.AddPlayerField(ids, fieldName, data)
    local idType = type(ids)
    if idType == 'number' then
        if ids == -1 then
            for _, v in pairs(AJFW.Players) do
                v.Functions.AddField(fieldName, data)
            end
        else
            if not AJFW.Players[ids] then return end

            AJFW.Players[ids].Functions.AddField(fieldName, data)
        end
    elseif idType == 'table' and table.type(ids) == 'array' then
        for i = 1, #ids do
            AJFW.Functions.AddPlayerField(ids[i], fieldName, data)
        end
    end
end

-- Save player info to database (make sure citizenid is the primary key in your database)

function AJFW.Player.Save(source)
    local ped = GetPlayerPed(source)
    local pcoords = GetEntityCoords(ped)
    local PlayerData = AJFW.Players[source].PlayerData
    if PlayerData then
        MySQL.insert('INSERT INTO players (citizenid, cid, license, name, money, charinfo, job, gang, position, metadata) VALUES (:citizenid, :cid, :license, :name, :money, :charinfo, :job, :gang, :position, :metadata) ON DUPLICATE KEY UPDATE cid = :cid, name = :name, money = :money, charinfo = :charinfo, job = :job, gang = :gang, position = :position, metadata = :metadata', {
            citizenid = PlayerData.citizenid,
            cid = tonumber(PlayerData.cid),
            license = PlayerData.license,
            name = PlayerData.name,
            money = json.encode(PlayerData.money),
            charinfo = json.encode(PlayerData.charinfo),
            job = json.encode(PlayerData.job),
            gang = json.encode(PlayerData.gang),
            position = json.encode(pcoords),
            metadata = json.encode(PlayerData.metadata)
        })
        if GetResourceState('aj-inventory') ~= 'missing' then exports['aj-inventory']:SaveInventory(source) end
        AJFW.ShowSuccess(GetCurrentResourceName(), PlayerData.name .. ' PLAYER SAVED!')
    else
        AJFW.ShowError(GetCurrentResourceName(), 'ERROR AJFW.PLAYER.SAVE - PLAYERDATA IS EMPTY!')
    end
end

function AJFW.Player.SaveOffline(PlayerData)
    if PlayerData then
        MySQL.Async.insert('INSERT INTO players (citizenid, cid, license, name, money, charinfo, job, gang, position, metadata) VALUES (:citizenid, :cid, :license, :name, :money, :charinfo, :job, :gang, :position, :metadata) ON DUPLICATE KEY UPDATE cid = :cid, name = :name, money = :money, charinfo = :charinfo, job = :job, gang = :gang, position = :position, metadata = :metadata', {
            citizenid = PlayerData.citizenid,
            cid = tonumber(PlayerData.cid),
            license = PlayerData.license,
            name = PlayerData.name,
            money = json.encode(PlayerData.money),
            charinfo = json.encode(PlayerData.charinfo),
            job = json.encode(PlayerData.job),
            gang = json.encode(PlayerData.gang),
            position = json.encode(PlayerData.position),
            metadata = json.encode(PlayerData.metadata)
        })
        if GetResourceState('aj-inventory') ~= 'missing' then exports['aj-inventory']:SaveInventory(PlayerData, true) end
        AJFW.ShowSuccess(GetCurrentResourceName(), PlayerData.name .. ' OFFLINE PLAYER SAVED!')
    else
        AJFW.ShowError(GetCurrentResourceName(), 'ERROR AJFW.PLAYER.SAVEOFFLINE - PLAYERDATA IS EMPTY!')
    end
end

-- Delete character

local playertables = { -- Add tables as needed
    { table = 'players' },
    { table = 'apartments' },
    { table = 'bank_accounts' },
    { table = 'crypto_transactions' },
    { table = 'phone_invoices' },
    { table = 'phone_messages' },
    { table = 'playerskins' },
    { table = 'player_contacts' },
    { table = 'player_houses' },
    { table = 'player_mails' },
    { table = 'player_outfits' },
    { table = 'player_vehicles' }
}

function AJFW.Player.DeleteCharacter(source, citizenid)
    local license = AJFW.Functions.GetIdentifier(source, 'license')
    local result = MySQL.scalar.await('SELECT license FROM players where citizenid = ?', { citizenid })
    if license == result then
        local query = 'DELETE FROM %s WHERE citizenid = ?'
        local tableCount = #playertables
        local queries = table.create(tableCount, 0)

        for i = 1, tableCount do
            local v = playertables[i]
            queries[i] = { query = query:format(v.table), values = { citizenid } }
        end

        MySQL.transaction(queries, function(result2)
            if result2 then
                TriggerEvent('aj-log:server:CreateLog', 'joinleave', 'Character Deleted', 'red', '**' .. GetPlayerName(source) .. '** ' .. license .. ' deleted **' .. citizenid .. '**..')
            end
        end)
    else
        DropPlayer(source, Lang:t('info.exploit_dropped'))
        TriggerEvent('aj-log:server:CreateLog', 'anticheat', 'Anti-Cheat', 'white', GetPlayerName(source) .. ' Has Been Dropped For Character Deletion Exploit', true)
    end
end

function AJFW.Player.ForceDeleteCharacter(citizenid)
    local result = MySQL.scalar.await('SELECT license FROM players where citizenid = ?', { citizenid })
    if result then
        local query = 'DELETE FROM %s WHERE citizenid = ?'
        local tableCount = #playertables
        local queries = table.create(tableCount, 0)
        local Player = AJFW.Functions.GetPlayerByCitizenId(citizenid)

        if Player then
            DropPlayer(Player.PlayerData.source, 'An admin deleted the character which you are currently using')
        end
        for i = 1, tableCount do
            local v = playertables[i]
            queries[i] = { query = query:format(v.table), values = { citizenid } }
        end

        MySQL.transaction(queries, function(result2)
            if result2 then
                TriggerEvent('aj-log:server:CreateLog', 'joinleave', 'Character Force Deleted', 'red', 'Character **' .. citizenid .. '** got deleted')
            end
        end)
    end
end

-- Inventory Backwards Compatibility

function AJFW.Player.SaveInventory(source)
    if GetResourceState('aj-inventory') == 'missing' then return end
    exports['aj-inventory']:SaveInventory(source, false)
end

function AJFW.Player.SaveOfflineInventory(PlayerData)
    if GetResourceState('aj-inventory') == 'missing' then return end
    exports['aj-inventory']:SaveInventory(PlayerData, true)
end

function AJFW.Player.GetTotalWeight(items)
    if GetResourceState('aj-inventory') == 'missing' then return end
    return exports['aj-inventory']:GetTotalWeight(items)
end

function AJFW.Player.GetSlotsByItem(items, itemName)
    if GetResourceState('aj-inventory') == 'missing' then return end
    return exports['aj-inventory']:GetSlotsByItem(items, itemName)
end

function AJFW.Player.GetFirstSlotByItem(items, itemName)
    if GetResourceState('aj-inventory') == 'missing' then return end
    return exports['aj-inventory']:GetFirstSlotByItem(items, itemName)
end

-- Util Functions

function AJFW.Player.CreateCitizenId()
    local UniqueFound = false
    local CitizenId = nil
    while not UniqueFound do
        CitizenId = tostring(AJFW.Shared.RandomStr(3) .. AJFW.Shared.RandomInt(5)):upper()
        local result = MySQL.prepare.await('SELECT COUNT(*) as count FROM players WHERE citizenid = ?', { CitizenId })
        if result == 0 then
            UniqueFound = true
        end
    end
    return CitizenId
end

function AJFW.Functions.CreateAccountNumber()
    local UniqueFound = false
    local AccountNumber = nil
    while not UniqueFound do
        AccountNumber = 'US0' .. math.random(1, 9) .. 'AJFW' .. math.random(1111, 9999) .. math.random(1111, 9999) .. math.random(11, 99)
        local query = '%' .. AccountNumber .. '%'
        local result = MySQL.prepare.await('SELECT COUNT(*) as count FROM players WHERE charinfo LIKE ?', { query })
        if result == 0 then
            UniqueFound = true
        end
    end
    return AccountNumber
end

function AJFW.Functions.CreatePhoneNumber()
    local UniqueFound = false
    local PhoneNumber = nil
    while not UniqueFound do
        PhoneNumber = math.random(100, 999) .. math.random(1000000, 9999999)
        local query = '%' .. PhoneNumber .. '%'
        local result = MySQL.prepare.await('SELECT COUNT(*) as count FROM players WHERE charinfo LIKE ?', { query })
        if result == 0 then
            UniqueFound = true
        end
    end
    return PhoneNumber
end

function AJFW.Player.CreateFingerId()
    local UniqueFound = false
    local FingerId = nil
    while not UniqueFound do
        FingerId = tostring(AJFW.Shared.RandomStr(2) .. AJFW.Shared.RandomInt(3) .. AJFW.Shared.RandomStr(1) .. AJFW.Shared.RandomInt(2) .. AJFW.Shared.RandomStr(3) .. AJFW.Shared.RandomInt(4))
        local query = '%' .. FingerId .. '%'
        local result = MySQL.prepare.await('SELECT COUNT(*) as count FROM `players` WHERE `metadata` LIKE ?', { query })
        if result == 0 then
            UniqueFound = true
        end
    end
    return FingerId
end

function AJFW.Player.CreateWalletId()
    local UniqueFound = false
    local WalletId = nil
    while not UniqueFound do
        WalletId = 'AJ-' .. math.random(11111111, 99999999)
        local query = '%' .. WalletId .. '%'
        local result = MySQL.prepare.await('SELECT COUNT(*) as count FROM players WHERE metadata LIKE ?', { query })
        if result == 0 then
            UniqueFound = true
        end
    end
    return WalletId
end

function AJFW.Player.CreateSerialNumber()
    local UniqueFound = false
    local SerialNumber = nil
    while not UniqueFound do
        SerialNumber = math.random(11111111, 99999999)
        local query = '%' .. SerialNumber .. '%'
        local result = MySQL.prepare.await('SELECT COUNT(*) as count FROM players WHERE metadata LIKE ?', { query })
        if result == 0 then
            UniqueFound = true
        end
    end
    return SerialNumber
end

PaycheckInterval() -- This starts the paycheck system


--###############   Exports   ##################

exports('GetCoreObject', function()
    return AJFW
end)

-- ########### EVENTS #####################

-- Event Handler

AddEventHandler('chatMessage', function(_, _, message)
    if string.sub(message, 1, 1) == '/' then
        CancelEvent()
        return
    end
end)

AddEventHandler('playerDropped', function(reason)
    local src = source
    if not AJFW.Players[src] then return end
    local Player = AJFW.Players[src]
    TriggerEvent('aj-log:server:CreateLog', 'joinleave', 'Dropped', 'red', '**' .. GetPlayerName(src) .. '** (' .. Player.PlayerData.license .. ') left..' .. '\n **Reason:** ' .. reason)
    Player.Functions.Save()
    AJFW.Player_Buckets[Player.PlayerData.license] = nil
    AJFW.Players[src] = nil
end)

-- Open & Close Server (prevents players from joining)

RegisterNetEvent('AJFW:Server:CloseServer', function(reason)
    local src = source
    if AJFW.Functions.HasPermission(src, 'admin') then
        reason = reason or 'No reason specified'
        AJFW.Config.Server.Closed = true
        AJFW.Config.Server.ClosedReason = reason
        for k in pairs(AJFW.Players) do
            if not AJFW.Functions.HasPermission(k, AJFW.Config.Server.WhitelistPermission) then
                AJFW.Functions.Kick(k, reason, nil, nil)
            end
        end
    else
        AJFW.Functions.Kick(src, Lang:t('error.no_permission'), nil, nil)
    end
end)

RegisterNetEvent('AJFW:Server:OpenServer', function()
    local src = source
    if AJFW.Functions.HasPermission(src, 'admin') then
        AJFW.Config.Server.Closed = false
    else
        AJFW.Functions.Kick(src, Lang:t('error.no_permission'), nil, nil)
    end
end)

-- Callback Events --

-- Client Callback
RegisterNetEvent('AJFW:Server:TriggerClientCallback', function(name, ...)
    if AJFW.ClientCallbacks[name] then
        AJFW.ClientCallbacks[name](...)
        AJFW.ClientCallbacks[name] = nil
    end
end)

-- Server Callback
RegisterNetEvent('AJFW:Server:TriggerCallback', function(name, ...)
    local src = source
    AJFW.Functions.TriggerCallback(name, src, function(...)
        TriggerClientEvent('AJFW:Client:TriggerCallback', src, name, ...)
    end, ...)
end)


RegisterNetEvent('AJFW:CallCommand', function(command, args)
    local src = source
    if not AJFW.Commands.List[command] then return end
    local Player = AJFW.Functions.GetPlayer(src)
    if not Player then return end
    local hasPerm = AJFW.Functions.HasPermission(src, 'command.' .. AJFW.Commands.List[command].name)
    if hasPerm then
        if AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and not args[#AJFW.Commands.List[command].arguments] then
            TriggerClientEvent('AJFW:Notify', src, Lang:t('error.missing_args2'), 'error')
        else
            AJFW.Commands.List[command].callback(src, args)
        end
    else
        TriggerClientEvent('AJFW:Notify', src, Lang:t('error.no_access'), 'error')
    end
end)


-- ############## Will be removed soon



-- Player Connecting

local function onPlayerConnecting(name, _, deferrals)
    local src = source
    deferrals.defer()

    if AJFW.Config.Server.Closed and not IsPlayerAceAllowed(src, 'ajadmin.join') then
        return deferrals.done(AJFW.Config.Server.ClosedReason)
    end

    if AJFW.Config.Server.Whitelist then
        Wait(0)
        deferrals.update(string.format(Lang:t('info.checking_whitelisted'), name))
        if not AJFW.Functions.IsWhitelisted(src) then
            return deferrals.done(Lang:t('error.not_whitelisted'))
        end
    end

    Wait(0)
    deferrals.update(string.format('Hello %s. Your license is being checked', name))
    local license = AJFW.Functions.GetIdentifier(src, 'license')

    if not license then
        return deferrals.done(Lang:t('error.no_valid_license'))
    elseif AJFW.Config.Server.CheckDuplicateLicense and AJFW.Functions.IsLicenseInUse(license) then
        return deferrals.done(Lang:t('error.duplicate_license'))
    end

    Wait(0)
    deferrals.update(string.format(Lang:t('info.checking_ban'), name))

    local success, isBanned, reason = pcall(AJFW.Functions.IsPlayerBanned, src)
    if not success then return deferrals.done(Lang:t('error.connecting_database_error')) end
    if isBanned then return deferrals.done(reason) end

    Wait(0)
    deferrals.update(string.format(Lang:t('info.join_server'), name))
    deferrals.done()

    TriggerClientEvent('AJFW:Client:SharedUpdate', src, AJFW.Shared)
end

AddEventHandler('playerConnecting', onPlayerConnecting)


-- Player

RegisterNetEvent('AJFW:UpdatePlayer', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    if not Player then return end
    local newHunger = Player.PlayerData.metadata['hunger'] - AJFW.Config.Player.HungerRate
    local newThirst = Player.PlayerData.metadata['thirst'] - AJFW.Config.Player.ThirstRate
    if newHunger <= 0 then
        newHunger = 0
    end
    if newThirst <= 0 then
        newThirst = 0
    end
    Player.Functions.SetMetaData('thirst', newThirst)
    Player.Functions.SetMetaData('hunger', newHunger)
    TriggerClientEvent('hud:client:UpdateNeeds', src, newHunger, newThirst)
    Player.Functions.Save()
end)

RegisterNetEvent('AJFW:ToggleDuty', function()
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    if not Player then return end
    if Player.PlayerData.job.onduty then
        Player.Functions.SetJobDuty(false)
        TriggerClientEvent('AJFW:Notify', src, Lang:t('info.off_duty'))
    else
        Player.Functions.SetJobDuty(true)
        TriggerClientEvent('AJFW:Notify', src, Lang:t('info.on_duty'))
    end

    TriggerEvent('AJFW:Server:SetDuty', src, Player.PlayerData.job.onduty)
    TriggerClientEvent('AJFW:Client:SetDuty', src, Player.PlayerData.job.onduty)
end)

-- BaseEvents

-- Vehicles
RegisterServerEvent('baseevents:enteringVehicle', function(veh, seat, modelName)
    local src = source
    local data = {
        vehicle = veh,
        seat = seat,
        name = modelName,
        event = 'Entering'
    }
    TriggerClientEvent('AJFW:Client:VehicleInfo', src, data)
end)

RegisterServerEvent('baseevents:enteredVehicle', function(veh, seat, modelName)
    local src = source
    local data = {
        vehicle = veh,
        seat = seat,
        name = modelName,
        event = 'Entered'
    }
    TriggerClientEvent('AJFW:Client:VehicleInfo', src, data)
end)

RegisterServerEvent('baseevents:enteringAborted', function()
    local src = source
    TriggerClientEvent('AJFW:Client:AbortVehicleEntering', src)
end)

RegisterServerEvent('baseevents:leftVehicle', function(veh, seat, modelName)
    local src = source
    local data = {
        vehicle = veh,
        seat = seat,
        name = modelName,
        event = 'Left'
    }
    TriggerClientEvent('AJFW:Client:VehicleInfo', src, data)
end)

-- Non-Chat Command Calling (ex: aj-adminmenu)


-- Use this for player vehicle spawning
-- Vehicle server-side spawning callback (netId)
-- use the netid on the client with the NetworkGetEntityFromNetworkId native
-- convert it to a vehicle via the NetToVeh native
AJFW.Functions.CreateCallback('AJFW:Server:SpawnVehicle', function(source, cb, model, coords, warp)
    local veh = AJFW.Functions.SpawnVehicle(source, model, coords, warp)
    cb(NetworkGetNetworkIdFromEntity(veh))
end)

-- Use this for long distance vehicle spawning
-- vehicle server-side spawning callback (netId)
-- use the netid on the client with the NetworkGetEntityFromNetworkId native
-- convert it to a vehicle via the NetToVeh native
AJFW.Functions.CreateCallback('AJFW:Server:CreateVehicle', function(source, cb, model, coords, warp)
    local veh = AJFW.Functions.CreateAutomobile(source, model, coords, warp)
    cb(NetworkGetNetworkIdFromEntity(veh))
end)

--AJFW.Functions.CreateCallback('AJFW:HasItem', function(source, cb, items, amount)
-- https://github.com/qbcore-framework/aj-inventory/blob/e4ef156d93dd1727234d388c3f25110c350b3bcf/server/main.lua#L2066
--end)
