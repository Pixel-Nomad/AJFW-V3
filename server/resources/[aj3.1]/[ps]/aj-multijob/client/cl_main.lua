local AJFW = exports['aj-base']:GetCoreObject()

local function GetJobs()
    local p = promise.new()
    AJFW.Functions.TriggerCallback('aj-multijob:getJobs', function(result)
        p:resolve(result)
    end)
    return Citizen.Await(p)
end

local function OpenUI()
    local job = AJFW.Functions.GetPlayerData().job
    SetNuiFocus(true,true)
    SendNUIMessage({
        action = 'sendjobs',
        activeJob = job["name"],
        onDuty = job["onduty"],
        jobs = GetJobs(),
        side = Config.Side,
    })
end

RegisterNUICallback('selectjob', function(data, cb)
    TriggerServerEvent("aj-multijob:changeJob", data["name"], data["grade"])
    local onDuty = false
    if data["name"] ~= "police" then onDuty = AJFW.Shared.Jobs[data["name"]].defaultDuty end
    cb({onDuty = onDuty})
end)

RegisterNUICallback('closemenu', function(data, cb)
    cb({})
    SetNuiFocus(false,false)
end)

RegisterNUICallback('removejob', function(data, cb)
    TriggerServerEvent("aj-multijob:removeJob", data["name"], data["grade"])
    local jobs = GetJobs()
    jobs[data["name"]] = nil
    cb(jobs)
end)

RegisterNUICallback('toggleduty', function(data, cb)
    cb({})

    local job = AJFW.Functions.GetPlayerData().job.name

    if Config.DenyDuty[job] then
        TriggerEvent("AJFW:Notify", 'Not allowed to use this station for clock-in.', 'error')
        return
    end
    
    TriggerServerEvent("AJFW:ToggleDuty")
end)

RegisterNetEvent('AJFW:Client:OnJobUpdate', function(JobInfo)
    SendNUIMessage({
        action = 'updatejob',
        name = JobInfo["name"],
        label = JobInfo["label"],
        onDuty = JobInfo["onduty"],
        gradeLabel = JobInfo["grade"].name,
        grade = JobInfo["grade"].level,
        salary = JobInfo["payment"],
        isWhitelist = Config.WhitelistJobs[JobInfo["name"]] or false,
        description = Config.Descriptions[JobInfo["name"]] or "",
        icon = Config.FontAwesomeIcons[JobInfo["name"]] or "",
    })
end)

RegisterCommand("jobmenu", OpenUI, false)

RegisterKeyMapping('jobmenu', "Show Job Management", "keyboard", "J")

TriggerEvent('chat:removeSuggestion', '/jobmenu')