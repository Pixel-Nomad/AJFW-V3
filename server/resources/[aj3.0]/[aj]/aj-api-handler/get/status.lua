local path = '/status'

local totalItems = 0
local totalJobs = 0
local totalGangs = 0
local totalVehicles = 0
local totalWeapons = 0

for _,_ in pairs(QBCore.Shared.Items) do
    totalItems = totalItems + 1
end

for _,_ in pairs(QBCore.Shared.Jobs) do
    totalJobs = totalJobs + 1
end

for _,_ in pairs(QBCore.Shared.Gangs) do
    totalGangs = totalGangs + 1
end

for _,_ in pairs(QBCore.Shared.Vehicles) do
    totalVehicles = totalVehicles + 1
end

for _,_ in pairs(QBCore.Shared.Weapons) do
    totalWeapons = totalWeapons + 1
end

local function GetTotalPlayersOnline()
    local Players = QBCore.Functions.GetPlayers()
    local retval = 0
    if Players then
        retval = #Players
    end
    return retval
end

local function callback(req, res)
    if VerifyToken(req.head['Authorization'], req.head['vtime']) then
        local players = GetTotalPlayersOnline()
        res.body = { 
            message = 'OK',
            status= {
                disc= Config.Codes[200],
                code= 200
            },
            data = {
                data = {
                    players = players,
                    items = totalItems,
                    jobs = totalJobs,
                    gangs = totalGangs,
                    vehicles = totalVehicles,
                    weapons = totalWeapons,
                }
            }
        }
    else
        res.body = { 
            message = Config.Codes[400],
            status= {
                disc= Config.Codes[400],
                code= 400
            }
        }
    end
    return res
end 
exports['aj-api']:route(path, callback, 'GET')