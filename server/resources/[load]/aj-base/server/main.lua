AJFW = {}
AJFW.Config = AJConfig
AJFW.Shared = AJShared
AJFW.Config.Server.PermissionList = {}
AJFW.Config.Server.PermissionListCommands = {}
AJFW.ClientCallbacks = {}
AJFW.ServerCallbacks = {}
AJFW.Functions = {}
AJFW.Player_Buckets = {}
AJFW.Entity_Buckets = {}
AJFW.UsableItems = {}
AJFW.Players = {}
AJFW.Player = {}
AJFW.Commands = {}
AJFW.Commands.List = {}

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

function AJFW.Functions.GetLeoDutyCount(array, single)
    local count = 0
    if single then
        for _, Player in pairs(AJFW.Players) do
            if Player.PlayerData.job.name == array then
                if Player.PlayerData.job.onduty then
                    count = count + 1
                end
            end
        end
    else
        for i = 1, #array do
            for _, Player in pairs(AJFW.Players) do
                if Player.PlayerData.job.name == array[i] then
                    if Player.PlayerData.job.onduty then
                        count = count + 1
                    end
                end
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
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local plicense = Player.PlayerData.license
    local pCID = Player.PlayerData.citizenid
    if Player then
        AJFW.Config.Server.PermissionList[pCID] = {
            license = plicense,
            cid = pCID,
            permission = permission:lower(),
        }
        MySQL.query.await('DELETE FROM permissions WHERE cid = ?', { pCID })

        MySQL.insert('INSERT INTO permissions (name, license, cid, permission) VALUES (?, ?, ?, ?)', {
            GetPlayerName(src),
            plicense,
            pCID,
            permission:lower()
        })

        Player.Functions.UpdatePlayerData()
        TriggerClientEvent('AJFW:Client:OnPermissionUpdate', src, permission)
    end
end

---Remove permission from player
---@param source any
---@param permission string
function AJFW.Functions.RemovePermission(source, permission)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local license = Player.PlayerData.license
    local pCID = Player.PlayerData.citizenid
    if Player then
        AJFW.Config.Server.PermissionList[pCID] = nil
        MySQL.query('DELETE FROM permissions WHERE cid = ?', { pCID })
        Player.Functions.UpdatePlayerData()
    end
end

-- Checking for Permission Level

---Check if player has permission
---@param source any
---@param permission string
---@return boolean
function AJFW.Functions.HasPermission(source, permission)
    local src = source
    local license = AJFW.Functions.GetIdentifier(src, 'license')
    local Player = AJFW.Functions.GetPlayer(src)
    local permission = tostring(permission:lower())
    if permission == 'user' then
        return true
    else
        if Player then
            local pCID = Player.PlayerData.citizenid
            if AJFW.Config.Server.PermissionList[pCID] then
                if AJFW.Config.Server.PermissionList[pCID].license == license then
                    if AJFW.Config.Server.PermissionList[pCID].cid == pCID then
                        if AJFW.Config.Server.PermissionList[pCID].permission == permission or AJFW.Config.Server.PermissionList[pCID].permission == 'dev' then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

---Get the players permissions
---@param source any
---@return table
function AJFW.Functions.HasPermissionCMD(source, command)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    if Player then
        local pCID = Player.PlayerData.citizenid
        if AJFW.Config.Server.PermissionListCommands[pCID] then
            if AJFW.Config.Server.PermissionListCommands[pCID][command] then
                return true
            end
        end
    end
    return false
end

---Get the players permissions
---@param source any
---@return table
function AJFW.Functions.GetPermission(source)
    local src = source
    local license = AJFW.Functions.GetIdentifier(src, 'license')
    local Player = AJFW.Functions.GetPlayer(src)
    if license then
        if Player then
            local pCID = Player.PlayerData.citizenid
            if AJFW.Config.Server.PermissionList[pCID] then
                if AJFW.Config.Server.PermissionList[pCID].license == license then
                    if AJFW.Config.Server.PermissionList[pCID].cid == pCID then
                        return AJFW.Config.Server.PermissionList[pCID].permission
                    end
                end
            end
        end
    end
    return 'user'
end


local permsobject = {
    'dev',
    'owner',
    'manager',
    'h-admin',
    'admin',
    'c-admin',
    's-mod',
    'mod'
}

function AJFW.Functions.IsOptin(source)
    local src = source
    local license = AJFW.Functions.GetIdentifier(src, 'license')
    local Player = AJFW.Functions.GetPlayer(src)
    if license then
        for i = 1, #permsobject do
            if AJFW.Functions.HasPermission(src, permsobject[i]) then
                return true
            end
        end
        return false
    else
        return false
    end
end

---Toggle opt-in to admin messages
---@param source any
function AJFW.Functions.ToggleOptin(source)
    local src = source
    local license = AJFW.Functions.GetIdentifier(src, 'license')
    local Player = AJFW.Functions.GetPlayer(src)
    if license then
        for i = 1, #permsobject do
            if AJFW.Functions.HasPermission(src, permsobject[i]) then
                Player.PlayerData.optin = not Player.PlayerData.optin
                Player.Functions.SetPlayerData('optin', Player.PlayerData.optin)
            end
        end
    end
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
        return true, {result.reason, timeTable.day .. '/' .. timeTable.month .. '/' .. timeTable.year .. ' ' .. timeTable.hour .. ':' .. timeTable.min}
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
    PlayerData.metadata['armor'] = PlayerData.metadata['armor'] or 0
    PlayerData.metadata['health'] = PlayerData.metadata['health'] or 200
    PlayerData.metadata['stress'] = PlayerData.metadata['stress'] or 0
    PlayerData.metadata['isdead'] = PlayerData.metadata['isdead'] or false
    PlayerData.metadata['inlaststand'] = PlayerData.metadata['inlaststand'] or false
    PlayerData.metadata['pursuit'] = PlayerData.metadata['pursuit'] or false
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

local function CallCommands(src,Player,command,args)
    local isDev         = AJFW.Functions.HasPermission(src, 'dev')
    local isOwner       = AJFW.Functions.HasPermission(src, 'owner')
    local isManager     = AJFW.Functions.HasPermission(src, 'manager')
    local is_h_admin    = AJFW.Functions.HasPermission(src, 'h-admin')
    local isAdmin       = AJFW.Functions.HasPermission(src, 'admin')
    local is_c_admin    = AJFW.Functions.HasPermission(src, 'c-admin')
    local is_s_mod      = AJFW.Functions.HasPermission(src, 's-mod')
    local isMod         = AJFW.Functions.HasPermission(src, 'mod')
    local isCommand     = AJFW.Functions.HasPermissionCMD(src, command)
    local isJob         = Player.PlayerData.job.name
    local isLeo         = Player.PlayerData.job.type
    if AJFW.Commands.List[command].permission == 'dev' then
        if isDev  or isCommand then
            if (AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and args[#AJFW.Commands.List[command].arguments] == nil) then
                TriggerClientEvent('AJFW:Notify', src, 'All arguments must be filled out!', 'error')
            else
                AJFW.Commands.List[command].callback(src, args)
            end
        else
            TriggerClientEvent('AJFW:Notify', src, 'No Access To This Command', 'error')
        end
    elseif AJFW.Commands.List[command].permission == 'owner' then
        if isOwner or isDev  or isCommand then
            if (AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and args[#AJFW.Commands.List[command].arguments] == nil) then
                TriggerClientEvent('AJFW:Notify', src, 'All arguments must be filled out!', 'error')
            else
                AJFW.Commands.List[command].callback(src, args)
            end
        else
            TriggerClientEvent('AJFW:Notify', src, 'No Access To This Command', 'error')
        end
    elseif AJFW.Commands.List[command].permission == 'manager' then
        if isManager or isOwner or isDev  or isCommand then
            if (AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and args[#AJFW.Commands.List[command].arguments] == nil) then
                TriggerClientEvent('AJFW:Notify', src, 'All arguments must be filled out!', 'error')
            else
                AJFW.Commands.List[command].callback(src, args)
            end
        else
            TriggerClientEvent('AJFW:Notify', src, 'No Access To This Command', 'error')
        end
    elseif AJFW.Commands.List[command].permission == 'h-admin' then
        if is_h_admin or isManager or isOwner or isDev  or isCommand then
            if (AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and args[#AJFW.Commands.List[command].arguments] == nil) then
                TriggerClientEvent('AJFW:Notify', src, 'All arguments must be filled out!', 'error')
            else
                AJFW.Commands.List[command].callback(src, args)
            end
        else
            TriggerClientEvent('AJFW:Notify', src, 'No Access To This Command', 'error')
        end
    elseif AJFW.Commands.List[command].permission == 'admin' then
        if isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
            if (AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and args[#AJFW.Commands.List[command].arguments] == nil) then
                TriggerClientEvent('AJFW:Notify', src, 'All arguments must be filled out!', 'error')
            else
                AJFW.Commands.List[command].callback(src, args)
            end
        else
            TriggerClientEvent('AJFW:Notify', src, 'No Access To This Command', 'error')
        end
    elseif AJFW.Commands.List[command].permission == 'c-admin' then
        if is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev  then
            if (AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and args[#AJFW.Commands.List[command].arguments] == nil) then
                TriggerClientEvent('AJFW:Notify', src, 'All arguments must be filled out!', 'error')
            else
                AJFW.Commands.List[command].callback(src, args)
            end
        else
            TriggerClientEvent('AJFW:Notify', src, 'No Access To This Command', 'error')
        end
    elseif AJFW.Commands.List[command].permission == 's-mod' then
        if is_s_mod or is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
            if (AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and args[#AJFW.Commands.List[command].arguments] == nil) then
                TriggerClientEvent('AJFW:Notify', src, 'All arguments must be filled out!', 'error')
            else
                AJFW.Commands.List[command].callback(src, args)
            end
        else
            TriggerClientEvent('AJFW:Notify', src, 'No Access To This Command', 'error')
        end
    elseif AJFW.Commands.List[command].permission == 'mod' then
        if isMod or is_s_mod or is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
            if (AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and args[#AJFW.Commands.List[command].arguments] == nil) then
                TriggerClientEvent('AJFW:Notify', src, 'All arguments must be filled out!', 'error')
            else
                AJFW.Commands.List[command].callback(src, args)
            end
        else
            TriggerClientEvent('AJFW:Notify', src, 'No Access To This Command', 'error')
        end
    elseif AJFW.Commands.List[command].permission == isLeo then
        if AJFW.Commands.List[command].permission == isLeo then
            if (AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and args[#AJFW.Commands.List[command].arguments] == nil) then
                TriggerClientEvent('AJFW:Notify', src, 'All arguments must be filled out!', 'error')
            else
                AJFW.Commands.List[command].callback(src, args)
            end
        else
            TriggerClientEvent('AJFW:Notify', src, 'No Access To This Command', 'error')
        end
    elseif AJFW.Commands.List[command].permission == isJob then
        if AJFW.Commands.List[command].permission == isJob then
            if (AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and args[#AJFW.Commands.List[command].arguments] == nil) then
                TriggerClientEvent('AJFW:Notify', src, 'All arguments must be filled out!', 'error')
            else
                AJFW.Commands.List[command].callback(src, args)
            end
        else
            TriggerClientEvent('AJFW:Notify', src, 'No Access To This Command', 'error')
        end
    elseif AJFW.Commands.List[command].permission == 'user' then
        if (AJFW.Commands.List[command].argsrequired and #AJFW.Commands.List[command].arguments ~= 0 and args[#AJFW.Commands.List[command].arguments] == nil) then
            TriggerClientEvent('AJFW:Notify', src, 'All arguments must be filled out!', 'error')
        else
            AJFW.Commands.List[command].callback(src, args)
        end
    end
end

local function HelpCommand(src,Player,command)
    local isDev         = AJFW.Functions.HasPermission(src, 'dev')
    local isOwner       = AJFW.Functions.HasPermission(src, 'owner')
    local isManager     = AJFW.Functions.HasPermission(src, 'manager')
    local is_h_admin    = AJFW.Functions.HasPermission(src, 'h-admin')
    local isAdmin       = AJFW.Functions.HasPermission(src, 'admin')
    local is_c_admin    = AJFW.Functions.HasPermission(src, 'c-admin')
    local is_s_mod      = AJFW.Functions.HasPermission(src, 's-mod')
    local isMod         = AJFW.Functions.HasPermission(src, 'mod')
    local isCommand     = AJFW.Functions.HasPermissionCMD(src, command)
    local isJob         = Player.PlayerData.job.name
    local isLeo         = Player.PlayerData.job.type
    local Templates     = ''
    for k,_ in pairs (AJFW.Commands.List) do
        if AJFW.Commands.List[k].permission == 'dev' then
            if isDev  or isCommand then
                Templates = Templates..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 'owner' then
            if isOwner or isDev  or isCommand then
                Templates = Templates..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 'manager' then
            if isManager or isOwner or isDev  or isCommand then
                Templates = Templates..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 'h-admin' then
            if is_h_admin or isManager or isOwner or isDev  or isCommand then
                Templates = Templates..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 'admin' then
            if isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
                Templates = Templates..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 'c-admin' then
            if is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
                Templates = Templates..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 's-mod' then
            if is_s_mod or is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
                Templates = Templates..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 'mod' then
            if isMod or is_s_mod or is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
                Templates = Templates..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == isJob then
            if AJFW.Commands.List[k].permission == isJob then
                Templates = Templates..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == isLeo then
            if AJFW.Commands.List[k].permission == isLeo then
                Templates = Templates..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
            end
        elseif AJFW.Commands.List[k].permission == 'user' then
            Templates = Templates..'<strong>'..k..' </strong>: '..AJFW.Commands.List[k].help..'<br>'
        end
    end
    Templates = Templates..'Press <strong>[ PageUP ]</strong> and <strong>[ PageDown ]</strong> on your <strong>keyboard</strong> to scroll in chat'
    TriggerClientEvent('chat:addMessage',src, {
        template = "<div class=chat-message server'>"..Templates.."</div>",
        args = {Templates}
    })
end


--###############   Exports   ##################

exports('GetCoreObject', function()
    return AJFW
end)

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

-- ########### EVENTS #####################

-- Event Handler

AddEventHandler('chatMessage', function(_, _, message)
    if string.sub(message, 1, 1) == '/' then
        CancelEvent()
        return
    end
end)

AddEventHandler('chatMessage', function(source, n, message)
    local src = source
    if string.sub(message, 1, 1) == '/' then
        local args = AJFW.Shared.SplitStr(message, ' ')
        local command = string.gsub(args[1]:lower(), '/', '')
        CancelEvent()
        if AJFW.Commands.List[command] then
            local Player = AJFW.Functions.GetPlayer(src)
            if Player then
                table.remove(args, 1)
                CallCommands(src,Player,command,args)
            end
        elseif command == 'help' or command == 'HELP' then
            local Player = AJFW.Functions.GetPlayer(src)
            if Player then
                HelpCommand(src,Player,command)
            end
        end
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
    if AJFW.Commands.List[command] then
        local Player = AJFW.Functions.GetPlayer(src)
        if Player then
            CallCommands(src,Player,command,args)
        end
    end
end)

RegisterNetEvent('Refresh:permissions',function()
    local result = MySQL.query.await('SELECT * FROM permissions', {})
    if result[1] then
        for k, v in pairs(result) do
            AJFW.Config.Server.PermissionList[v.cid] = {
                license = v.license,
                cid = v.cid,
                permission = v.permission,
                optin = true,
            }
        end
    end
end)

RegisterNetEvent('Refresh:permissions',function()
    local result = MySQL.query.await('SELECT * FROM permissionscommand', {})
    if result[1] then
        for k,v in pairs(result) do
            for l,m in pairs(v.commands) do
                AJFW.Config.Server.PermissionListCommands[v.cid] = {
                    [l] = true
                }
            end
        end
    end
end)


-- ############# Commands #################
CreateThread(function() -- Add ace to node for perm checking
    local permissions = AJFW.Config.Server.Permissions
    for i = 1, #permissions do
        local permission = permissions[i]
        ExecuteCommand(('add_ace ajfw.%s %s allow'):format(permission, permission))
    end
end)

-- Register & Refresh Commands

function AJFW.Commands.Add(name, help, arguments, argsrequired, callback, permission, ...)
    if AJFW.Commands[name] then
        permission = AJFW.Commands[name]
    else
        if type(permission) == 'string' then
            permission = permission:lower()
        else
            permission = 'user'
        end
    end

    AJFW.Commands.List[name:lower()] = {
        name = name:lower(),
        permission = permission,
        help = help,
        arguments = arguments,
        argsrequired = argsrequired,
        callback = callback
    }
end

local function CheckCommand(src,Player,command)
    local allowSuggestion = false
    local isDev         = AJFW.Functions.HasPermission(src, 'dev')
    local isOwner       = AJFW.Functions.HasPermission(src, 'owner')
    local isManager     = AJFW.Functions.HasPermission(src, 'manager')
    local is_h_admin    = AJFW.Functions.HasPermission(src, 'h-admin')
    local isAdmin       = AJFW.Functions.HasPermission(src, 'admin')
    local is_c_admin    = AJFW.Functions.HasPermission(src, 'c-admin')
    local is_s_mod      = AJFW.Functions.HasPermission(src, 's-mod')
    local isMod         = AJFW.Functions.HasPermission(src, 'mod')
    local isCommand     = AJFW.Functions.HasPermissionCMD(src, command)
    local isJob         = Player.PlayerData.job.name
    local isLeo         = Player.PlayerData.job.type
    if AJFW.Commands.List[command].permission == 'dev' then
        if isDev or isCommand then
            allowSuggestion = true
        end
    elseif AJFW.Commands.List[command].permission == 'owner' then
        if isOwner or isDev or isCommand then
            allowSuggestion = true
        end
    elseif AJFW.Commands.List[command].permission == 'manager' then
        if isManager or isOwner or isDev  or isCommand then
            allowSuggestion = true
        end
    elseif AJFW.Commands.List[command].permission == 'h-admin' then
        if is_h_admin or isManager or isOwner or isDev  or isCommand then
            allowSuggestion = true
        end
    elseif AJFW.Commands.List[command].permission == 'admin' then
        if isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
            allowSuggestion = true
        end
    elseif AJFW.Commands.List[command].permission == 'c-admin' then
        if is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
            allowSuggestion = true
        end
    elseif AJFW.Commands.List[command].permission == 's-mod' then
        if is_s_mod or is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
            allowSuggestion = true
        end
    elseif AJFW.Commands.List[command].permission == 'mod' then
        if isMod or is_s_mod or is_c_admin or isAdmin or is_h_admin or isManager or isOwner or isDev  or isCommand then
            allowSuggestion = true
        end
    elseif AJFW.Commands.List[command].permission == isLeo then
        allowSuggestion = true
    elseif AJFW.Commands.List[command].permission == isJob then
        allowSuggestion = true
    elseif AJFW.Commands.List[command].permission == 'user' then
        allowSuggestion = true
    end
    return allowSuggestion
end

function AJFW.Commands.Refresh(source)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)
    local suggestions = {}
    if Player then
        for command, info in pairs(AJFW.Commands.List) do
            local allowSuggestion = CheckCommand(src, Player, command)
            if allowSuggestion then
                suggestions[#suggestions + 1] = {
                    name = '/' .. command,
                    help = info.help,
                    params = info.arguments
                }
            else
                TriggerClientEvent('chat:removeSuggestion', src, '/'..command)
            end
        end
        TriggerClientEvent('chat:addSuggestions', tonumber(source), suggestions)
    end
end

-- ############## DEBUG ###############

local function tPrint(tbl, indent)
    indent = indent or 0
    if type(tbl) == 'table' then
        for k, v in pairs(tbl) do
            local tblType = type(v)
            local formatting = ('%s ^3%s:^0'):format(string.rep('  ', indent), k)

            if tblType == 'table' then
                print(formatting)
                tPrint(v, indent + 1)
            elseif tblType == 'boolean' then
                print(('%s^1 %s ^0'):format(formatting, v))
            elseif tblType == 'function' then
                print(('%s^9 %s ^0'):format(formatting, v))
            elseif tblType == 'number' then
                print(('%s^5 %s ^0'):format(formatting, v))
            elseif tblType == 'string' then
                print(("%s ^2'%s' ^0"):format(formatting, v))
            else
                print(('%s^2 %s ^0'):format(formatting, v))
            end
        end
    else
        print(('%s ^0%s'):format(string.rep('  ', indent), tbl))
    end
end

RegisterServerEvent('AJFW:DebugSomething', function(tbl, indent, resource)
    print(('\x1b[4m\x1b[36m[ %s : DEBUG]\x1b[0m'):format(resource))
    tPrint(tbl, indent)
    print('\x1b[4m\x1b[36m[ END DEBUG ]\x1b[0m')
end)

function AJFW.Debug(tbl, indent)
    TriggerEvent('AJFW:DebugSomething', tbl, indent, GetInvokingResource() or 'aj-base')
end

function AJFW.ShowError(resource, msg)
    print('\x1b[31m[' .. resource .. ':ERROR]\x1b[0m ' .. msg)
end

function AJFW.ShowSuccess(resource, msg)
    print('\x1b[32m[' .. resource .. ':LOG]\x1b[0m ' .. msg)
end

CreateThread(function()
    local result = MySQL.query.await('SELECT * FROM permissions', {})
    if result[1] then
        for k, v in pairs(result) do
            AJFW.Config.Server.PermissionList[v.cid] = {
                license = v.license,
                cid = v.cid,
                permission = v.permission,
                optin = true,
            }
        end
    end
end)

CreateThread(function()
    local result = MySQL.query.await('SELECT * FROM permissionscommand', {})
    if result[1] then
        for k,v in pairs(result) do
            local table = json.decode(v.commands)
            for l,m in pairs(table) do
                AJFW.Config.Server.PermissionListCommands[v.cid] = {
                    [l] = true
                }
            end
        end
    end
end)

-- ############## Will be removed soon