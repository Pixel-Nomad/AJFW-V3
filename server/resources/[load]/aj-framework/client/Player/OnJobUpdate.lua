local aaaaa = 'Player/OnJobUpdate'

local function UpdateLoops()
    -- if PlayerJob.name == 'government' then
    --     Modular:StartLoop_government()
    -- else
    --     Modular:StopLoop_government()
    -- end 
end

RegisterNetEvent('AJFW:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    -- exports.ui_pause._SendNUIMessage({
    --     action = "UpdateData", 
    --     key = "job", 
    --     value = PlayerJob.label.." - "..PlayerJob.grade.name
    -- })
    UpdateLoops()
end)