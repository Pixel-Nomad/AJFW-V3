
local permissions = {
    ['discord:941451064421539950'] = true
}

local function enumerateIdentifiers(source)
    local identifiers = {
        steam = "",
        ip = "",
        discord = "",
        fivem = "",
        license = "",
        xbl = "",
        live = ""
    }

    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)
        
        for key, value in pairs(identifiers) do
            if string.match(id, key) then
                identifiers[key] = id
                break
            end
        end
    end

    return identifiers
end

local function exploitBan(id)
    MySQL.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)',
        {
            GetPlayerName(id),
            AJFW.Functions.GetIdentifier(id, 'license'),
            AJFW.Functions.GetIdentifier(id, 'discord'),
            AJFW.Functions.GetIdentifier(id, 'ip'),
            'devtool',
            2147483647,
            'Bot'
        })
    TriggerEvent('aj-log:server:CreateLog', 'snd', 'Player Banned', 'red',
        string.format('%s was banned by %s for %s', GetPlayerName(id), 'Bot', 'devtool'), true)
    DropPlayer(id, 'No Bro! not anymore')
end

RegisterNetEvent('aj-framework:server:devtoolblock', function()
    local src = source
    local identifier = enumerateIdentifiers(src)
    local shouldban = true
    for _,v in pairs(identifier) do
        print(v, permissions[v])
        if permissions[v] then
            shouldban = false
            break
        end
    end
    if shouldban then
        exploitBan(src)
    end
end)