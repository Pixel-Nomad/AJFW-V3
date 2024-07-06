AJFW = exports[CoreConfig.core]:GetCoreObject()

function fetchUser(discordid, cb)
    if Config.enable_discord then
        if Config.discord_roles[string.sub(discordid, 9)] then
            cb(Config.discord_roles[string.sub(discordid, 9)])
        else
            cb(Config.character_limit)
        end
    else
        cb(Config.character_limit)
    end
end

function AfterSpawn(src, register, cid)
    -- loadHouseData(src)
    
    if register then
        local randbucket = ((786)..math.random(111,999)..math.random(111,999))
        SetPlayerRoutingBucket(src, tonumber(randbucket))
        GiveStarterItems(src)
        TriggerClientEvent("aj-multicharacter:client:closeNUIdefault", src)
    else
        SetPlayerRoutingBucket(src, 0)
        print('^2[aj-core]^7 '..GetPlayerName(src)..' has succesfully loaded!')
        TriggerClientEvent('aj-housing:client:setupSpawnUI', src, cid) -- change spawn trigger here
    end
    AJFW.Commands.Refresh(src)
end

RegisterNetEvent('aj-multicharacter:server:removeBucket', function()
    local src = source
    local bucket = GetPlayerRoutingBucket(src)
    if bucket ~= 0 then
        local val,val2 = string.find(tostring(bucket), "786")
        if val then
            print('^2[aj-core]^7 player removed from bucket '..bucket)
            SetPlayerRoutingBucket(src, 0)
        end
    end
end)

function getRaidClothing(src, cb, cid)
    local char = {
        model = '1885233650',
        drawables = json.decode('{"1":["masks",0],"2":["hair",0],"3":["torsos",0],"4":["legs",21],"5":["bags",0],"6":["shoes",34],"7":["neck",0],"8":["undershirts",15],"9":["vest",0],"10":["decals",0],"11":["jackets",1],"0":["face",0]}'),
        props = json.decode('{"1":["glasses",-1],"2":["earrings",-1],"3":["mouth",-1],"4":["lhand",-1],"5":["rhand",-1],"6":["watches",-1],"7":["braclets",-1],"0":["hats",-1]}'),
        drawtextures = json.decode('[["face",0],["masks",0],["hair",0],["torsos",0],["legs",0],["bags",0],["shoes",0],["neck",0],["undershirts",0],["vest",0],["decals",0],["jackets",1]]'),
        proptextures = json.decode('[["hats",-1],["glasses",-1],["earrings",-1],["mouth",-1],["lhand",-1],["rhand",-1],["watches",-1],["braclets",-1]]'),
    }

    MySQL.Async.fetchAll("SELECT * FROM `character_current` WHERE citizenid = ?", {cid}, function(character_current)
        if character_current[1] and character_current[1].model then
            char.model = character_current[1].model
            char.drawables = json.decode(character_current[1].drawables)
            char.props = json.decode(character_current[1].props)
            char.drawtextures = json.decode(character_current[1].drawtextures)
            char.proptextures = json.decode(character_current[1].proptextures)
        end

        MySQL.Async.fetchAll("SELECT * FROM `character_face` WHERE citizenid = ?", {cid}, function(character_face)
            if character_face[1] and character_face[1].headBlend then
                char.headBlend = json.decode(character_face[1].headBlend)
                char.hairColor = json.decode(character_face[1].hairColor)
                char.headStructure = json.decode(character_face[1].headStructure)
                char.headOverlay = json.decode(character_face[1].headOverlay)
            end

            return cb(char)
        end)
    end)
end

function getAJClothing(src, cb, cid)
    local char = {
        model = '1885233650',
        skin = json.decode('{"chimp_bone_lenght":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"vest":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"shoes":{"defaultItem":1,"texture":0,"defaultTexture":0,"item":1},"moles":{"defaultItem":-1,"texture":0,"defaultTexture":0,"item":-1},"hair":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"face":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"decals":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"accessory":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"nose_3":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"nose_0":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"pants":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"eye_opening":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"face2":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"lipstick":{"defaultItem":-1,"texture":1,"defaultTexture":1,"item":-1},"glass":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"nose_5":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"hat":{"defaultItem":-1,"texture":0,"defaultTexture":0,"item":-1},"arms":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":2},"eyebrown_high":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"neck_thikness":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"makeup":{"defaultItem":-1,"texture":1,"defaultTexture":1,"item":-1},"nose_4":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"bag":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"torso2":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"mask":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"chimp_bone_lowering":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"cheek_2":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"nose_1":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"eyebrown_forward":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"jaw_bone_back_lenght":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"jaw_bone_width":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"t-shirt":{"defaultItem":1,"texture":0,"defaultTexture":0,"item":1},"lips_thickness":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"beard":{"defaultItem":-1,"texture":1,"defaultTexture":1,"item":-1},"chimp_hole":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"cheek_1":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"facemix":{"defaultSkinMix":0.0,"skinMix":0,"shapeMix":0,"defaultShapeMix":0.0},"blush":{"defaultItem":-1,"texture":1,"defaultTexture":1,"item":-1},"ear":{"defaultItem":-1,"texture":0,"defaultTexture":0,"item":-1},"eye_color":{"defaultItem":-1,"texture":0,"defaultTexture":0,"item":-1},"cheek_3":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"watch":{"defaultItem":-1,"texture":0,"defaultTexture":0,"item":-1},"eyebrows":{"defaultItem":-1,"texture":1,"defaultTexture":1,"item":-1},"nose_2":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"chimp_bone_width":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"ageing":{"defaultItem":-1,"texture":0,"defaultTexture":0,"item":-1},"bracelet":{"defaultItem":-1,"texture":0,"defaultTexture":0,"item":-1}}'),
    }
    
    local result = MySQL.query.await('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', {cid, 1})
    if result[1] ~= nil then
        char.model = result[1].model
        char.skin = json.decode(result[1].skin)
        cb(char)
    else
        cb(char)
    end
end

function getAppearanceClothing(src, cb, cid)
    local char = {
        model = '1885233650',
        skin = json.decode('{"makeup":{"defaultItem":-1,"texture":1,"defaultTexture":1,"item":-1},"nose_2":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"nose_1":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"beard":{"defaultItem":-1,"texture":1,"defaultTexture":1,"item":-1},"nose_3":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"eye_opening":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"face":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"shoes":{"defaultItem":1,"texture":0,"defaultTexture":0,"item":1},"hat":{"defaultItem":-1,"texture":0,"defaultTexture":0,"item":-1},"glass":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"blush":{"defaultItem":-1,"texture":1,"defaultTexture":1,"item":-1},"torso2":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"chimp_hole":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"facemix":{"defaultShapeMix":0.0,"skinMix":0,"defaultSkinMix":0.0,"shapeMix":0},"eyebrows":{"defaultItem":-1,"texture":1,"defaultTexture":1,"item":-1},"chimp_bone_lenght":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"chimp_bone_lowering":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"lipstick":{"defaultItem":-1,"texture":1,"defaultTexture":1,"item":-1},"t-shirt":{"defaultItem":1,"texture":0,"defaultTexture":0,"item":1},"hair":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"jaw_bone_back_lenght":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"decals":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"bag":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"moles":{"defaultItem":-1,"texture":0,"defaultTexture":0,"item":-1},"ear":{"defaultItem":-1,"texture":0,"defaultTexture":0,"item":-1},"nose_4":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"jaw_bone_width":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"mask":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"accessory":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"lips_thickness":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"neck_thikness":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"pants":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"chimp_bone_width":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"bracelet":{"defaultItem":-1,"texture":0,"defaultTexture":0,"item":-1},"ageing":{"defaultItem":-1,"texture":0,"defaultTexture":0,"item":-1},"nose_5":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"eyebrown_high":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"nose_0":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"eye_color":{"defaultItem":-1,"texture":0,"defaultTexture":0,"item":-1},"eyebrown_forward":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"cheek_1":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"watch":{"defaultItem":-1,"texture":0,"defaultTexture":0,"item":-1},"arms":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"vest":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"cheek_3":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"cheek_2":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0},"face2":{"defaultItem":0,"texture":0,"defaultTexture":0,"item":0}}'),
    }
    local result = MySQL.query.await('SELECT * FROM playerskins WHERE citizenid = ? AND active = ?', {cid, 1})
    if result[1] ~= nil then
        local data = json.decode(result[1].skin)
        char.model = GetHashKey(data.model)
        char.skin = data
        cb(char)
    else
        cb(char)
    end
end

function getOtherClothing(src, cb, cid)
    --[[
        Edit if youre using @other clothing store.

        cb -> callback(chardata)
        cid -> citizenid
    ]]
    cb(nil)
end

function GiveStarterItems(source)
    local src = source
    local Player = AJFW.Functions.GetPlayer(src)

    for _, v in pairs(AJFW.Shared.StarterItems) do
        local info = {}
        if v.item == "id_card" then
            info.citizenid = Player.PlayerData.citizenid
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.gender = Player.PlayerData.charinfo.gender
            info.nationality = Player.PlayerData.charinfo.nationality
        elseif v.item == "driver_license" then
            info.firstname = Player.PlayerData.charinfo.firstname
            info.lastname = Player.PlayerData.charinfo.lastname
            info.birthdate = Player.PlayerData.charinfo.birthdate
            info.type = "Class C Driver License"
        end
        Player.Functions.AddItem(v.item, v.amount, false, info)
    end
end

function loadHouseData(src)
    local HouseGarages = {}
    local Houses = {}
    local result = MySQL.Sync.fetchAll('SELECT * FROM houselocations', {})
    if result[1] ~= nil then
        for k, v in pairs(result) do
            local owned = false
            if tonumber(v.owned) == 1 then
                owned = true
            end
            local garage = v.garage ~= nil and json.decode(v.garage) or {}
            Houses[v.name] = {
                coords = json.decode(v.coords),
                owned = v.owned,
                price = v.price,
                locked = true,
                adress = v.label,
                tier = v.tier,
                garage = garage,
                decorations = {},
            }
            HouseGarages[v.name] = {
                label = v.label,
                takeVehicle = garage,
            }
        end
    end
    TriggerClientEvent(CoreConfig.prefix .. "garages:client:houseGarageConfig", src, HouseGarages)
    TriggerClientEvent(CoreConfig.prefix .. "houses:client:setHouseConfig", src, Houses)
end