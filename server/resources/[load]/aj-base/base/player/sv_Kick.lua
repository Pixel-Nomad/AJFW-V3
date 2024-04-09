---@param source any
---@param reason string
---@param setKickReason boolean
---@param deferrals boolean
function AJFW.Functions.Kick(source, reason, setKickReason, deferrals)
    reason = '\n' .. reason .. '\n🔸 Check our Discord for further information: ' .. AJFW.Config.Server.Discord
    if setKickReason then
        setKickReason(reason)
    end
    CreateThread(function()
        if deferrals then
            deferrals.update(reason)
            Wait(2500)
        end
        if source then
            DropPlayer(source, reason)
        end
        for _ = 0, 4 do
            while true do
                if source then
                    if GetPlayerPing(source) >= 0 then
                        break
                    end
                    Wait(100)
                    CreateThread(function()
                        DropPlayer(source, reason)
                    end)
                end
            end
            Wait(5000)
        end
    end)
end