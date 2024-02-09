local aaaaa = 'Player/OnPlayerUnload'


local function StateChanger()
    LocalPlayer.state:set('isLoggedIn', false, false)
end

local function GarbageCleaner()
    TriggerServerEvent('AJFW:Server:playtime:leave', PlayerData.citizenid)
    PlayerData = {}
    PlayerJob = {}
    PlayerMeta = {}
    PlayerGang = {}
    PlayerCharinfo = {}
    PlayerMoney = {}
    isDead     = false
    isLastStand = false
    isCuffed    = false
end

local function StopLoops()
    -- Modular:StopLoop_government()
end

local function RemoveTextUI()
    exports['aj-base']:HideText(1)
    exports['aj-base']:HideText(2)
    exports['aj-base']:HideText(3)
    exports['aj-base']:HideText(4)
    exports['aj-base']:HideText(5)
    exports['aj-base']:HideText(6)
    exports['aj-base']:HideText(7)
    exports['aj-base']:HideText(8)
    exports['aj-base']:HideText(9)
    exports['aj-base']:HideText(10)
end

RegisterNetEvent('AJFW:Client:OnPlayerUnload', function()
    StateChanger()
    StopLoops()
    GarbageCleaner()
    -- leaveradio()
    RemoveTextUI()
end)

RegisterNetEvent('Custom:resourceStoper', function()
    StopLoops()
    StateChanger()
    -- leaveradio()
    RemoveTextUI()
end)