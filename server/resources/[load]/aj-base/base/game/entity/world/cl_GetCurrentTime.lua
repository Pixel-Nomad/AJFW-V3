function AJFW.Functions.GetCurrentTime()
    local obj = {}
    obj.min = GetClockMinutes()
    obj.hour = GetClockHours()

    if obj.hour <= 12 then
        obj.ampm = 'AM'
    elseif obj.hour >= 13 then
        obj.ampm = 'PM'
        obj.formattedHour = obj.hour - 12
    end

    if obj.min <= 9 then
        obj.formattedMin = '0' .. obj.min
    end

    return obj
end
