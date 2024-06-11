local timer = 0
local isWashing = false
local isCollecting = false
local ActiveWasherIndex = 0
local value = 0

local function openHouseAnim()
    AJFW.Functions.RequestAnimDict("anim@heists@keycard@") 
    TaskPlayAnim(PlayerPedId(), "anim@heists@keycard@", "exit", 5.0, 1.0, -1, 16, 0, 0, 0, 0 )
    Wait(400)
    ClearPedTasks(PlayerPedId())
end

local function WashAnimation()
    AJFW.Functions.RequestAnimDict("mp_car_bomb") 
    TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic" ,3.0, 3.0, -1, 16, 0, false, false, false)
    CreateThread(function()
        while isWashing do
            TaskPlayAnim(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 3.0, 3.0, -1, 16, 0, 0, 0, 0)
            Wait(2000)
        end
    end)
end

local function DrawText3D(coords, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 41, 11, 41, 60)    
    ClearDrawOrigin()
end

local function collectMoney()
    CreateThread(function()
        while isCollecting do
            local sleep = 500
            local pos = GetEntityCoords(GlobalPlayerPedID)
            local target = Config.Secure['MoneyWash']['Washers'][ActiveWasherIndex]
            local dist = #(pos - target)
            if dist <= 1.5 then
                DrawText3D(target, "~g~E~w~ - Collect Clean Money")
                if IsControlJustPressed(0, 38) then
                    WashAnimation()
                    AJFW.Functions.Progressbar("bills_collect", "Collecting clean bill\'s from washer...",'white', math.random(5000, 10000), false, true, {
                        disableMovement = false,
                        disableCarMovement = false,
                        disableMouse = false,
                        disableCombat = true,
                    }, {
                        animDict = "mp_car_bomb",
                        anim = "car_bomb_mechanic",
                        flags = 16,
                    }, {}, {}, function() -- Done
                        TriggerServerEvent('aj-moneywash:server:giveMoney', amt)
                        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
                        StopAnimTask(GlobalPlayerPedID, "mp_car_bomb", "car_bomb_mechanic", 1.0)
                        isCollecting = false                        
                    end, function()
                        AJFW.Functions.Notify("Canceled..", "error")
                    end) 
                end
            end
            Wait(sleep)
        end
    end)
end

local function WashTimer()
    CreateThread(function()
        while isWashing do
            local sleep = 500
            local pos = GetEntityCoords(GlobalPlayerPedID)
            local target = Config.Secure['MoneyWash']['Washers'][ActiveWasherIndex]
            local dist = #(pos - target)
            if dist <= 3 then
                sleep = 5
                DrawText3D(target, "Time left on washer: " .. timer .. ' seconds.')               
            end
            Wait(sleep)
        end
    end)
end

RegisterNetEvent('JcaobMoneyWash', function()
    local ped = GlobalPlayerPedID
    local pos = GetEntityCoords(ped)
    local target = Config.Secure['MoneyWash']['Enter']
    local dist = #(pos - target)
    if dist <= 1.5 then
        openHouseAnim()
        DoScreenFadeOut(500)
        Wait(1500)
        SetEntityCoords(ped, 1138.0439453125, -3199.1455078125, -39.6657371521)
        DoScreenFadeIn(500)
        TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_close", 0.1)
    end
end)

RegisterNetEvent('aj-moneywash:client:startTimer', function(amt)
    isWashing = true
    timer = math.ceil(0.005 * amt)
    if timer <= 60 then
        timer = 60
    end
    WashTimer()
    while isWashing do
        timer = timer - 1
        if timer <= 0 then
            isWashing = false
            isCollecting = true
            AJFW.Functions.Notify('Your clean cash is ready to be collected.', 'success', 50000)
            local taxes = (value / 100 * 5)
            local final = value - taxes
            collectMoney(final)
        end
        Wait(1000)
    end
end)

CreateThread(function()
    while true do
        local sleep = 2500
        if LocalPlayer.state.isLoggedIn then
            local pos = GetEntityCoords(GlobalPlayerPedID)
            local target = Config.Secure['MoneyWash']['Exit']
            local dist = #(pos - target)
            if dist <= 5 then
                sleep = 5
                if dist <= 1.5 then
                    DrawText3D(target, "~g~E~w~ - Exit")
                    if IsControlJustReleased(1, 38) then
                        openHouseAnim()
                        DoScreenFadeOut(500)
                        Citizen.Wait(1500)
                        SetEntityCoords(GlobalPlayerPedID, Config.Secure['MoneyWash']['Enter']['x'], Config.Secure['MoneyWash']['Enter']['y'], Config.Secure['MoneyWash']['Enter']['z'])
                        DoScreenFadeIn(500)
                        TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_close", 0.1)
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
        local sleep = 2500
        if LocalPlayer.state.isLoggedIn then
            local pos = GetEntityCoords(GlobalPlayerPedID)
            for i = 1, #Config.Secure['MoneyWash']['Washers'] do
                local target = Config.Secure['MoneyWash']['Washers'][i]
                local dist = #(pos - target)
                if dist <= 5 then
                    sleep = 5
                    DrawMarker(2, target, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.5, 0.15, 255, 55, 15, 255, false, false, false, true, false, false, false)
                    if dist <= 1.5 then
                        if not isWashing and not isCollecting then
                            DrawText3D(target, "~g~E~w~ - Start Washer")
                            if IsControlJustPressed(0, 38) then
                                AJFW.Functions.TriggerCallback('aj-moneywash:server:checkWash', function(result)
                                    if result then
                                        WashAnimation()
                                        AJFW.Functions.Progressbar("bills_wash", "Putting Black Money into the washer...",'black', math.random(2000, 5000), false, true, {
                                            disableMovement = false,
                                            disableCarMovement = false,
                                            disableMouse = false,
                                            disableCombat = true,
                                        }, {
                                            animDict = "mp_car_bomb",
                                            anim = "car_bomb_mechanic",
                                            flags = 16,
                                        }, {}, {}, function() -- Done
                                            TriggerServerEvent('aj-moneywash:server:checkInv', amt)
                                            StopAnimTask(PlayerPedId(), "mp_car_bomb", "car_bomb_mechanic", 1.0)
                                            ActiveWasherIndex = i
                                            value = tamount
                                        end, function()
                                            AJFW.Functions.Notify("Canceled..", "error")
                                        end) 
                                    else
                                        AJFW.Functions.Notify("Where is black money?..", "error")
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)