local aaaaa = 'Config/Server'

Config = Config or {}



Config.Queue = Config.Queue or {}

Config.Queue.Priority = {}
Config.Queue.RequireSteam = false
Config.Queue.PriorityOnly = false
Config.Queue.DisableHardCap = true
Config.Queue.ConnectTimeOut = 600
Config.Queue.QueueTimeOut   = 90
Config.Queue.EnableGrace    = true
Config.Queue.GracePower     = 5
Config.Queue.GraceTime      = 400
Config.Queue.AntiSpam = false
Config.Queue.AntiSpamTimer = 30
Config.Queue.PleaseWait = "Please wait %f seconds. The connection will start automatically!"
Config.Queue.JoinDelay = 90000
Config.Queue.Language = {
    joining = "\xF0\x9F\x8E\x89Joining...",
    connecting = "\xE2\x8F\xB3Connecting...",
    idrr = "\xE2\x9D\x97[AJ-FRAMEWORK] Error: Couldn't retrieve any of your id's, try restarting.",
    err = "\xE2\x9D\x97[AJ-FRAMEWORK] There was an error",
    pos = "\xF0\x9F\x90\x8CYou are %d/%d in queue \xF0\x9F\x95\x9C%s",
    connectingerr = "\xE2\x9D\x97[AJ-FRAMEWORK] Error: Error adding you to connecting list",
    timedout = "\xE2\x9D\x97[AJ-FRAMEWORK] Error: Timed out?",
    wlonly = "\xE2\x9D\x97[AJ-FRAMEWORK] You must be whitelisted to join this server",
    steam = "\xE2\x9D\x97 [AJ-FRAMEWORK] Error: Steam must be running"
}

Citizen.CreateThread(function()
	loadDatabaseQueue()
end)

function loadDatabaseQueue()
	MySQL.query('SELECT * FROM queue', {}, function(result)
		if result[1] then
			for k, v in pairs(result) do
				Config.Queue.Priority[v.license] = tonumber(v.priority)
			end
		end
	end)
    Citizen.Wait(5000)
    TriggerEvent('custom:queue:loadings', Config.Queue.Priority)
end

RegisterNetEvent('load:queue:db', function(data)
	loadDatabaseQueue()
end)