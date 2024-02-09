local aaaaa = 'Base/Queue'
 

Queue = {}
Queue.Ready = false
Queue.Exports = nil
Queue.ReadyCbs = {}
Queue.CurResource = GetCurrentResourceName()

if Queue.CurResource == "aj-framework" then return end


function Queue.OnReady(cb)
    if not cb then return end
    if Queue.IsReady() then cb() return end
    table.insert(Queue.ReadyCbs, cb)
end

function Queue.OnJoin(cb)
    if not cb then return end
    Queue.Exports:OnJoin(cb, Queue.CurResource)
end

function Queue.AddPriority(id, power, temp)
    if not Queue.IsReady() then return end
    Queue.Exports:AddPriority(id, power, temp)
end

function Queue.RemovePriority(id)
    if not Queue.IsReady() then return end
    Queue.Exports:RemovePriority(id)
end

function Queue.IsReady()
    return Queue.Ready
end

function Queue.LoadExports()
    Queue.Exports = exports['aj-framework']:GetQueueExports()
    Queue.Ready = true
    Queue.ReadyCallbacks()
end

function Queue.ReadyCallbacks()
    if not Queue.IsReady() then return end
    for _, cb in ipairs(Queue.ReadyCbs) do
        cb()
    end
end

AddEventHandler("onResourceStart", function(resource)
    if resource == "aj-framework" then
        while GetResourceState(resource) ~= "started" do Citizen.Wait(0) end
        Citizen.Wait(1)
        Queue.LoadExports()
    end
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == "aj-framework" then
        Queue.Ready = false
        Queue.Exports = nil
    end
end)

SetTimeout(1, function() Queue.LoadExports() end)

CreateThread(function()
    while true do
        Wait(3600000)
        local database = MySQL.query.await('SELECT * FROM queue',{})
        local time = os.date("*t")
        if time.hour == 00 then
            for k,v in pairs(database) do
                if v.expiredd == 1 then
                    if v.days > 1 then
                        local remain = v.days - 1
                        MySQL.query('UPDATE queue SET days = ? WHERE license = ?',{remain, v.license})
                    elseif v.days == 1 then
                        MySQL.query('DELETE FROM queue WHERE license = ? ',{v.license})
                    end
                end
            end
        end
    end
end)