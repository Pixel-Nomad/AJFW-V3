CreateThread(function()
    Wait(1500)
    print("^5[aj Multichar] ^7Loaded successfully")
end)

local function get(source, cb)
    local license = AJFW.Functions.GetIdentifier(source, "license")
    local discord = AJFW.Functions.GetIdentifier(source, "discord")
    fetchUser(discord, function(limit)
        MySQL.Async.fetchAll(
            "SELECT * FROM `players` WHERE `license` = ? ORDER BY `cid` ASC",
            {license}, function(result)
                local characters = {}
                if result then
                    for k,v in pairs(result) do
                        if v.cid ~= 0 then
                            local data = {}
                            local charinfo = json.decode(v.charinfo)
                            local money = json.decode(v.money)
                            local firstname = charinfo.firstname
                            local lastname  = charinfo.lastname
                            local fullname  = firstname .. " " .. lastname
                            data.name = fullname
                            data.nickname = charinfo.nickname
                            data.citizenid = v.citizenid
                            data.cid = v.cid
                            local gender = "Female"
                            if charinfo.gender then
                                if charinfo.gender == 0 then
                                    gender = "Male"
                                end
                            end
                            data.gender = gender
                            data.cash = money.cash
                            data.bank = money.bank
                            data.birth = charinfo.birthday
                            local job = json.decode(v.job)
                            data.job  = job.label
                            local charactercount = #characters+1
                            characters[charactercount] = data
                        end
                    end
                    cb(#characters >= 1 and characters or {},limit)
                else
                    cb({}, limit)
                end
            end
        )
    end)
end

AJFW.Functions.CreateCallback("aj-multichar:server:get", function(source, cb)
    local ped = GetPlayerPed(source)
    local random = math.random(1,999)
    local bucket = ped..random
    SetPlayerRoutingBucket(source, bucket)
    get(source, cb)
end)



RegisterNetEvent("aj-multichar:server:spawnPlayer", function(citizenid)
    local src = source
    local player = AJFW.Player.Login(source, citizenid)
    if player then
        player = AJFW.Functions.GetPlayer(src)
        AfterSpawn(src, false, player.PlayerData)
    end
end)

AJFW.Functions.CreateCallback("aj-multichar:server:createCharacter", function(source, cb, charinfo)
    if CoreConfig.char_english_only then
        local chars = "[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]"
        local firstname = charinfo.firstname
        local lastname = charinfo.lastname
        if not firstname.match(firstname, chars) then
            TriggerClientEvent(CoreConfig.notify, source, "First name can contain English letters only", "error")
            return cb(false)
        end
        if not lastname.match(lastname, chars) then
            TriggerClientEvent(CoreConfig.notify, source, "Last name can contain English letters only", "error")
            return cb(false)
        end
    end
    print(source, false, data)
    local data = {}
    data.charinfo = charinfo
    data.cid = 1
    local license = AJFW.Functions.GetIdentifier(source)
    local PlayerData = MySQL.prepare.await('SELECT * FROM players where license = ? and cid = ?', {license, data.cid })
    if PlayerData then
        repeat 
            data.cid = data.cid + 1
            PlayerData = MySQL.prepare.await('SELECT * FROM players where license = ? and cid = ?', {license, data.cid })
        until not PlayerData
    end
    print(data.charinfo, data.cid)
    local player = AJFW.Player.Login(source, false, data)
    if player then
        player = AJFW.Functions.GetPlayer(source)
        cb(true)
        
        return AfterSpawn(source, true, player)
    end
    TriggerClientEvent(CoreConfig.notify, source, "Unknown error", "error")
    return cb(false)
end)

AJFW.Functions.CreateCallback("aj-multichar:server:deleteCharacter", function(source, cb, citizenid)
    local player = AJFW.Player.DeleteCharacter(source, citizenid)
    Wait(1000)
    get(source, cb)
end)

AJFW.Functions.CreateCallback("aj-multichar:server:getSkin", function(source, cb, citizenid)
    if CoreConfig.clothing_base == "aj" then
        getAJClothing(source, cb, citizenid)
    elseif CoreConfig.clothing_base == "aj-clothMenu" then
        getAppearanceClothing(source, cb, citizenid)
    elseif CoreConfig.clothing_base == "raid" then
        getRaidClothing(source, cb, citizenid)
    else
        getOtherClothing(source, cb, citizenid)
    end 
end)

AJFW.Commands.Add("relog", 'Relog', {}, false, function(source, args)
    local src = source
    AJFW.Player.Logout(src)
    TriggerClientEvent('aj-multicharacter:client:chooseChar', src)
end, "admin")