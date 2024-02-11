local aaaaa = 'Player/OnPlayerConnecting'


local function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = source
    local src = source
    local license
    local name = GetPlayerName(player)
    local identifiers = GetPlayerIdentifiers(player)
    local a1 = json.encode(GetPlayerIdentifiers(player))
	local a2 = json.decode(a1)
	local b1,b2,b3,b4,b5,b6,b7,b8
	if a2[1]==nil then b1='null'else b1=a2[1]end
	if a2[2]==nil then b2='null'else b2=a2[2]end
	if a2[3]==nil then b3='null'else b3=a2[3]end
	if a2[4]==nil then b4='null'else b4=a2[4]end
	if a2[5]==nil then b5='null'else b5=a2[5]end
	if a2[6]==nil then b6='null'else b6=a2[6]end
	if a2[7]==nil then b7='null'else b7=a2[7]end
    if a2[8]==nil then b8='null'else b8=a2[8]end
	TriggerEvent("aj-log:server:CreateLog", "joinleave", "Queue", "orange", "**"..name .. "** ```"..b1..
                                                                                              "\n"..b2..
                                                                                              "\n"..b3..
                                                                                              "\n"..b4..
                                                                                              "\n"..b5..
                                                                                              "\n"..b6..
                                                                                              "\n"..b7..
                                                                                              "\n"..b8..
                                                                                              "\n".."``` in queue..")
    deferrals.defer()

    -- mandatory wait!
    Wait(0)

    deferrals.update(string.format('Hello %s. Validating Your Rockstar License', name))

    for _, v in pairs(identifiers) do
        if string.find(v, 'license') then
            license = v
            break
        end
    end

    -- mandatory wait!
    Wait(2500)

    deferrals.update(string.format('Hello %s. We are checking if you are banned.', name))

    local isBanned, Reason = AJFW.Functions.IsPlayerBanned(player)
    local isLicenseAlreadyInUse = AJFW.Functions.IsLicenseInUse(license)

    Wait(2500)

    deferrals.update(string.format('Welcome %s to {Server Name}.', name))
    if GetConvarInt("sv_fxdkMode", false) then
        license = 'license:AAAAAAAAAAAAAAAA' -- Dummy License
    end
    if not license then
        deferrals.done('No Valid Rockstar License Found')
    elseif isBanned then
        deferrals.done(Reason)
    elseif isLicenseAlreadyInUse then
        deferrals.done('Duplicate Rockstar License Found')
    else
        deferrals.done()
        Wait(1000)
        TriggerEvent('connectqueue:playerConnect', name, setKickReason, deferrals)
        TriggerClientEvent('AJFW:Client:SharedUpdate', src, AJFW.Shared)
    end
    --Add any additional defferals you may need!
end

AddEventHandler('playerConnecting', OnPlayerConnecting)