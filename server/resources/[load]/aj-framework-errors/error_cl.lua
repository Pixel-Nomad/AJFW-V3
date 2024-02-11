local oldError = error
local oldTrace = Citizen.Trace

local errorWords = {
    "failure",
    "error",
    "not",
    "failed",
    "not safe",
    "invalid",
    "cannot",
    ".lua",
    "server",
    "client",
    "attempt",
    "traceback",
    "stack",
    "function"
}

function error(...)
    local resource = GetCurrentResourceName()
    TriggerServerEvent("aj-error:logged", resource, args, 'client')
end

function Citizen.Trace(...)
    oldTrace(...)

    if type(...) == "string" then
        args = string.lower(...)
        
        for _, word in ipairs(errorWords) do
            if string.find(args, word) then
                error(...)
                return
            end
        end
    end
end
