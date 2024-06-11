local aaaaa = 'Player/OnPlayerLoaded'

local function GameNatives()
    ShutdownLoadingScreenNui()
    SetCanAttackFriendly(GlobalPlayerPedID, true, false)
    NetworkSetFriendlyFireOption(true)
end

local function StateChanger()
    LocalPlayer.state:set('isLoggedIn', true, false)
end

local function HelpMessage()
    TriggerEvent('chat:addMessage', {
        template = "<div class=chat-message server'>Type <strong>/help</strong> To Get Commands</div>",
        args = {}
    })
    TriggerEvent('chat:addMessage', {
        template = "<div class=chat-message server'>Press [ <strong>F11</strong> ] To see More About Location</div>",
        args = {}
    })
end

local function GarbageCollection()
    PlayerData = AJFW.Functions.GetPlayerData()
    PlayerJob = PlayerData.job
    PlayerMeta = PlayerData.metadata
    PlayerGang = PlayerData.gang
    PlayerCharinfo = PlayerData.charinfo
    PlayerMoney = PlayerData.money
    isDead     = PlayerData.metadata['isdead']
    isLastStand = PlayerData.metadata['inlaststand']
    isCuffed    = PlayerData.metadata['ishandcuffed']
    TriggerServerEvent('AJFW:Server:playtime:join', PlayerData.citizenid)
end

local function StartLoops()
    if PlayerJob.name == 'government' then
        Modular:StartLoop_government()
    end 
end

RegisterNetEvent('AJFW:Client:OnPlayerLoaded', function()
    GameNatives()
    StateChanger()
    HelpMessage()
    GarbageCollection()
    Modular:LocationGetter_Teleporters()
    Modular:SecureConfigGetter()

    Wait(500)

    TriggerServerEvent('aj-sounds:client:get')

    Wait(500)

    StartLoops()
end)

RegisterNetEvent('Custom:resourceStarter', function()
    GameNatives()
    StateChanger()
    HelpMessage()
    GarbageCollection()
    Modular:LocationGetter_Teleporters()
    Modular:SecureConfigGetter()

    Wait(500)

    TriggerServerEvent('aj-sounds:client:get')

    Wait(500)

    StartLoops()
end)