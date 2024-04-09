---@param source any
---@param model any
---@param coords vector
---@param warp boolean
---@return number
function AJFW.Functions.CreateAutomobile(source, model, coords, warp)
    model = type(model) == 'string' and joaat(model) or model
    if not coords then coords = GetEntityCoords(GetPlayerPed(source)) end
    local heading = coords.w and coords.w or 0.0
    local CreateAutomobile = `CREATE_AUTOMOBILE`
    local veh = Citizen.InvokeNative(CreateAutomobile, model, coords, heading, true, true)
    while not DoesEntityExist(veh) do Wait(0) end
    if warp then TaskWarpPedIntoVehicle(GetPlayerPed(source), veh, -1) end
    return veh
end