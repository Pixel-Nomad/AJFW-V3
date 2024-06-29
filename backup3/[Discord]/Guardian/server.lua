--------------------------------------------------------------------------------------------
-- Server- A Far More Advanced FiveM Script Than DiscordWhitelist, Made By Jordan.#2139 --
--------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------
                  -- !WARNING! !WARNING! !WARNING! !WARNING! !WARNING! --
        -- DO NOT TOUCH THIS FILE OR YOU /WILL/ FUCK SHIT UP! EDIT THE CONFIG.LUA --
-- DO NOT BE STUPID AND WHINE TO ME ABOUT THIS BEING BROKEN IF YOU TOUCHED THE LINES BELOW. --
----------------------------------------------------------------------------------------------
function ExtractIdentifiers(src)
    local identifiers = {
        discord = ""
    }

    --Loop over all identifiers
    for i = 0, GetNumPlayerIdentifiers(src) - 1 do
        local id = GetPlayerIdentifier(src, i)

        --Convert it to a nice table.
        if string.find(id, "discord") then
            identifiers.discord = id
        end
    end
    return identifiers
end

roleList = Config.WhitelistRoles;

AddEventHandler("playerConnecting", function(name, setCallback, deferrals)
    local Config = Config
    deferrals.defer()
    local src = source
    local identifierDiscord = "";
    local identifierSteam = nil;
    local identifierlicense = nil;
    deferrals.update("Checking Whitelist Permissions For " .. Config.ServerName)
		
    Citizen.Wait(0); -- Necessary Citizen.Wait() before deferrals.done()

    for k, v in ipairs(GetPlayerIdentifiers(src)) do
        if string.sub(v, 1, string.len("discord:")) == "discord:" then
            identifierDiscord = v
        end
        if string.sub(v, 1, string.len("license:")) == "license:" then
            identifierlicense = v
        end
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            identifierSteam = v
        end
    end
        local isWhitelisted = false;
        if identifierDiscord then
            local roleIDs = exports.Badger_Discord_API:GetDiscordRoles(src)
            if not (roleIDs == false) then
                local canBypass = false
                for i = 1, #roleList do
                    for j = 1, #roleIDs do
                        if exports.Badger_Discord_API:CheckEqual(roleList[i], roleIDs[j]) then
                            print("[AJ] (playerConnecting) Allowing " .. GetPlayerName(src) .. " to join with the role "  .. roleList[i])
                            print("[AJ] (playerConnecting) Player " .. GetPlayerName(src) .. "  Attempted to connect with Server, They were allowed entry")
                            isWhitelisted = true;
                            canBypass = true;
                        else
                            if isWhitelisted == false then 
                            isWhitelisted = false;
                            end
                        end
                    end
                end
                if canBypass then
                    if Config.bypass[identifierlicense] then
                        print("[AJ] (playerConnecting) Allowing " .. GetPlayerName(src) .. " to join with the bypass ")
                        print("[AJ] (playerConnecting) Player " .. GetPlayerName(src) .. "  Attempted to connect with Server, They were allowed entry")
                        isWhitelisted = true;
                    end
                end
            else
                if Config.bypass[identifierlicense] then
                    print("[AJ] (playerConnecting) Allowing " .. GetPlayerName(src) .. " to join with the bypass ")
                    print("[AJ] (playerConnecting) Player " .. GetPlayerName(src) .. "  Attempted to connect with Server, They were allowed entry")
                    isWhitelisted = true;
                else
                    print("[AJ] (playerConnecting) Player " .. GetPlayerName(src) or identifierSteam or "NO ID FOUND" .. "  Could not connect because role id\'s were not present")
                    print("[AJ] (playerConnecting) Player " .. GetPlayerName(src) or identifierSteam or "NO ID FOUND" .. "  Attempted to connect with Server, however they failed")
                    deferrals.done(Config.RoleIdsYeet)
                    CancelEvent()
                    return;
                end
            end
        else
            if Config.bypass == identifierlicense then
                print("[AJ] (playerConnecting) Allowing " .. GetPlayerName(src) .. " to join with the bypass ")
                print("[AJ] (playerConnecting) Player " .. GetPlayerName(src) .. "  Attempted to connect with Server, They were allowed entry")
                isWhitelisted = true;
            else
                print("[AJ] (playerConnecting) Declined connection from " .. GetPlayerName(src) or identifierSteam or "NO ID FOUND" .. "  because they did not have Discord open")
                print("[AJ] (playerConnecting) Player " .. GetPlayerName(src) or identifierSteam or "NO ID FOUND" .. "  Attempted to connect with Server, however they failed")
                deferrals.done(Config.DiscordYeet)
                CancelEvent()
                return;
            end
        end
        if isWhitelisted then 
          deferrals.done();
        else
          deferrals.done(Config.WhitelistYeet);
          CancelEvent()
        end
end)
