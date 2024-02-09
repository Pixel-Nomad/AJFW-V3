local aaaaa = 'Game/binds'
local RegisterCommands = {}
local function CreateBind(command, command2, label, keymap, callback, callback2)
    local UP = '+cmd_Wrapper__'..command
    local DOWN = nil
    if command2 then
        DOWN = '-cmd_Wrapper__'..command2
    end
    if callback and UP then
        RegisterCommand(UP, callback)
        TriggerEvent("chat:removeSuggestion", UP)
    end
    if  DOWN then
        RegisterCommand(DOWN, callback2)
        TriggerEvent("chat:removeSuggestion", DOWN)
    end
    if not RegisterCommands[UP] then
        RegisterCommands[UP] = true
        RegisterKeyMapping(UP, label, 'keyboard', keymap)
    end
end

exports('CreateBind', CreateBind)