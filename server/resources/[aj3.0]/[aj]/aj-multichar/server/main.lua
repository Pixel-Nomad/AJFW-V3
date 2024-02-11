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
                    cb(characters,limit)
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
        AfterSpawn(src, false, citizenid)
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
    local cid = -1
    local array1 = {}
    array1 = array1[source]
    array1 = array1[1]
    for i = 1, array1, 1 do
        local str = tostring(i)
        local array2 = {}
        array2 = array2[source]
        array2 = array2[2]
        str = str.match(str, array2)
        if not str then
            cid = str
        end
    end
    if cid == -1 then
        TriggerClientEvent(CoreConfig.notify, source, "You cant open more characters", "error")
        return cb(false)
    end
    charinfo.cid = cid
    local data = {}
    data.charinfo = charinfo
    data.cid = charinfo.cid
    local player = AJFW.Player.Login(source, false, data)
    if player then
        AfterSpawn(source, true, player.citizenid)
        return cb(true)
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
    elseif CoreConfig.clothing_base == "fivem-appearance" then
        getAppearanceClothing(source, cb, citizenid)
    elseif CoreConfig.clothing_base == "raid" then
        getRaidClothing(source, cb, citizenid)
    else
        getOtherClothing(source, cb, citizenid)
    end 
end)