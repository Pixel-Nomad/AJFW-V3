local aaaaa = 'Jobs/Police'
local previousStatus = ''


RegisterNetEvent("Priority:updateStatus", function(Status,newStatus)
    if previousStatus ~= Status then
        previousStatus = Status
        if Status == "inactive" then
            TriggerEvent('hud:client:updatePriority', false, false)
        elseif Status == "cooldown" then
            TriggerEvent('hud:client:updatePriority', false, true)
        elseif Status == "active" then
            TriggerEvent('hud:client:updatePriority', true, false)
        end
    end
end)