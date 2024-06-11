local function Draw3DText(coords, text)
    local onScreen,_x,_y=World3dToScreen2d(coords)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

CreateThread(function()
    while true do
        local sleep = 2500
        if LocalPlayer.state.isLoggedIn and Config.Secure['Granny'] then
            sleep = 1500
            local pos = GetEntityCoords(GlobalPlayerPedID)
            local target = Config.Secure['Granny']
            local dist = #(pos-target)
            if dist <= 10 then
                if not IsPedInAnyVehicle(GlobalPlayerPedID) then
                    if dist <= 3 then
			            Draw3DText(target.x,target.y,target.z+0.5, '[E] - Check in for $4,000')
                        if IsControlJustPressed(0, 38) then
                            if GetEntityHealth(GlobalPlayerPedID) <= 200 or isDead or isLastStand then
                                AJFW.Functions.RequestAnimDict('missheistdockssetup1clipboard@base')
                                TaskPlayAnim( PlayerPedId(), "missheistdockssetup1clipboard@base", "base", 3.0, 1.0, -1, 49, 0, 0, 0, 0 ) 
                                AJFW.Functions.Progressbar("check-", "Checking in..",'red', 5000, false, true, {
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {}, {}, {}, function()
                                    AJFW.Functions.Notify("You're getting treated! ..", "success")
                                    Wait(10000)
                                    TriggerEvent('hospital:client:Revive')
                                    TriggerServerEvent('aj-grandmas:server:HealSomeShit')
                                    ClearPedTasks(GlobalPlayerPedID)
                                end, function() -- Cancel
                                    ClearPedTasks(GlobalPlayerPedID)
                                end) 
                            else
                                AJFW.Functions.Notify("You do not need medical attention ..", "error")
                            end
                        end
                    end
                end
            end
        end
        Wait(500)
    end
end)