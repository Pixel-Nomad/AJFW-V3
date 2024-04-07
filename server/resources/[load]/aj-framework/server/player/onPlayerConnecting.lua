local aaaaa = 'Player/OnPlayerConnecting'

local Queue_OOP = {}

function Queue_OOP:NEW()
    local data = {
        cardExample = '{"type":"AdaptiveCard","$schema":"http://adaptivecards.io/schemas/adaptive-card.json","version":"1.6","body":[{"type":"Image","url":"image_url","horizontalAlignment":"Center","size":"Stretch"},{"type":"Container","items":[{"type":"TextBlock","text":"Welcome To Server_Name","wrap":true,"fontType":"Default","size":"ExtraLarge","weight":"Bolder","color":"Light","horizontalAlignment":"Center"},{"type":"TextBlock","text":"Hello playerName","wrap":true,"size":"Large","weight":"Bolder","color":"Light","horizontalAlignment":"Center"},{"type":"TextBlock","text":"whatsgoingon","wrap":true,"color":"Light","size":"Medium","horizontalAlignment":"Center"}],"style":"default","bleed":true,"height":"stretch"}]}',
        cardExampleBan = '{"type":"AdaptiveCard","$schema":"http://adaptivecards.io/schemas/adaptive-card.json","version":"1.6","body":[{"type":"Image","url":"image_url","horizontalAlignment":"Center","size":"Stretch"},{"type":"Container","items":[{"type":"TextBlock","text":"Message from Server_Name","wrap":true,"fontType":"Default","size":"ExtraLarge","weight":"Bolder","color":"Light","horizontalAlignment":"Center"},{"type":"TextBlock","text":"You Have Been Banned From Server Reason:","color": "Attention","wrap":true,"color":"Light","size":"Medium","horizontalAlignment":"Center"},{"type":"TextBlock","text":"reason!","wrap":true,"color":"Light","size":"Medium","horizontalAlignment":"Center"},{"type":"TextBlock","text":"Expire : TimeStamp","wrap":true,"color":"Light","size":"Medium","horizontalAlignment":"Center"}],"style":"default","bleed":true,"height":"stretch"}]}',
        myCard = '',
        start = false
    }
    setmetatable(data, { __index = self })
    return data
end

function Queue_OOP:GetCard() return self.myCard end
function Queue_OOP:SetStatus(bool) self.start = bool end
function Queue_OOP:GetStatus() return self.start end
function Queue_OOP:SetImage(image)
    self.cardExample = string.gsub(self.cardExample, "image_url", image)
    self.cardExampleBan = string.gsub(self.cardExampleBan, "image_url", image)
end
function Queue_OOP:SetServerName(name)
    self.cardExample = string.gsub(self.cardExample, "Server_Name", name)
    self.cardExampleBan = string.gsub(self.cardExampleBan, "Server_Name", name)
end
function Queue_OOP:SetPlayerName(name)
    self.cardExample = string.gsub(self.cardExample, "playerName", name)
end
function Queue_OOP:SetMessage(Message)
    if type(Message) == 'table' then
        self.myCard = string.gsub(self.cardExampleBan, "reason!", Message[1])
        self.myCard = string.gsub(self.myCard, "TimeStamp", Message[2])
    else
        self.myCard = string.gsub(self.cardExample, "whatsgoingon", Message)
    end
end
function Queue_OOP:Show(deferrals, obj)
    while obj:GetStatus() do
        deferrals.presentCard(obj:GetCard())
        Wait(500)
    end
end

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

    local obj = Queue_OOP:NEW()
    obj:SetStatus(true)
    obj:SetImage("https://forum.cfx.re/uploads/default/original/3X/a/6/a6ad03c9fb60fa7888424e7c9389402846107c7e.png")
    obj:SetServerName('AJFW')
    obj:SetPlayerName(name)
    obj:SetMessage('Initiating......')
    -- mandatory wait!
    Wait(500)
    CreateThread(function()
        Queue_OOP:Show(deferrals, obj)
    end)
    obj:SetMessage('Checking Your Documents')

    for _, v in pairs(identifiers) do
        if string.find(v, 'license') then
            license = v
            break
        end
    end

    -- mandatory wait!
    Wait(2500)

    obj:SetMessage('Checking Visa Status')

    local isBanned, Reason = AJFW.Functions.IsPlayerBanned(player)
    local isLicenseAlreadyInUse = AJFW.Functions.IsLicenseInUse(license)

    Wait(2500)

    if GetConvarInt("sv_fxdkMode", false) then
        license = 'license:AAAAAAAAAAAAAAAA' -- Dummy License
    end    
    if not license then
        obj:SetMessage('Valid License not found in document')
        Wait(5000)
        obj:SetStatus(false)
    elseif isBanned then
        obj:SetMessage(Reason)
        Wait(5000)
        obj:SetStatus(false)
    elseif isLicenseAlreadyInUse then
        obj:SetMessage('Duplicate License Found in document')
        Wait(5000)
        obj:SetStatus(false)
    else
        obj:SetMessage('Welcome on Board '..name..', I hope You\'ll have a great flight')
        Wait(1000)
        connectqueue_playerConnect(src,name, setKickReason, deferrals, obj)
        TriggerClientEvent('AJFW:Client:SharedUpdate', src, AJFW.Shared)
    end
    --Add any additional defferals you may need!
end

AddEventHandler('playerConnecting', OnPlayerConnecting)