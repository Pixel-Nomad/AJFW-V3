local path = '/UpdateInventory'

local base64_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
 
function base64Encode(data)
    local res = {}
    local byte, b1, b2, b3, b4
    local i = 1

    while i <= #data do
        byte = string.byte(data, i)
        i = i + 1
        b1 = byte >> 2
        b2 = (byte & 3) << 4
        if i <= #data then
            byte = string.byte(data, i)
            i = i + 1
            b2 = b2 | (byte >> 4)
            b3 = (byte & 15) << 2
            if i <= #data then
                byte = string.byte(data, i)
                i = i + 1
                b3 = b3 | (byte >> 6)
                b4 = byte & 63
            else
                b4 = 64
            end
        else
            b3, b4 = 64, 64
        end

        res[#res + 1] = string.char(string.byte(base64_chars, b1 + 1))
        res[#res + 1] = string.char(string.byte(base64_chars, b2 + 1))
        res[#res + 1] = string.char(string.byte(base64_chars, b3 + 1))
        res[#res + 1] = string.char(string.byte(base64_chars, b4 + 1))
    end

    return table.concat(res)
end

local contentTypes = {
    jpg = "image/jpeg",
    png = "image/png",
    gif = "image/gif",
    -- Add more as needed
}


local function ConvertBase64(image)
    local imagePath = GetResourcePath(Config.ImageResourceName)..Config.ImagePath..image
    imagePath = imagePath:gsub("resources//", "resources/")
    local file = io.open(imagePath, "rb")
    local dataURL = ""
    if not file then
        dataURL = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGQAAABkCAYAAABw4pVUAAABNWlDQ1BBZG9iZSBSR0IgKDE5OTgpAAAokZWPv0rDUBSHvxtFxaFWCOLgcCdRUGzVwYxJW4ogWKtDkq1JQ5XSJNxc//QhHN06uLj7BE6OgoPiE/gGilMHhwjBqfSbvvPjcDg/MCp23WkYZRjEWrWbjnQ9X86/MscMAHTCLLVbrSOAOIkj/iPg5wMB8LZt150G07EYpkoDY2C3G2UhiArQv9apBjECzKCfahCPgKnO2jUQz0Cpl/s7UApy/wRKyvV8EN+A2XM9H4wFwAxyXwNMHd1ogFqSDtVF71zLqmVZ0u4mQSRPh5mOBpk8jMNEpYnq6KgL5P8BsJwvtpuO3Kha1sHmlL0n4nq+zO3rBAGIlZciKwgv1dWfCmNv8lzcGK3C8QPMjots/xbut2DprsjWq1DegafRL8KzT/57sqVFAAAACXBIWXMAAAsTAAALEwEAmpwYAAAJvGlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNi4wLWMwMDIgNzkuMTY0MzUyLCAyMDIwLzAxLzMwLTE1OjUwOjM4ICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1sbnM6cGhvdG9zaG9wPSJodHRwOi8vbnMuYWRvYmUuY29tL3Bob3Rvc2hvcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RFdnQ9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZUV2ZW50IyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIDIxLjEgKFdpbmRvd3MpIiB4bXA6Q3JlYXRlRGF0ZT0iMjAyMS0xMC0yM1QxNToxNDoxMyswMzowMCIgeG1wOk1vZGlmeURhdGU9IjIwMjEtMTAtMjNUMTU6MjU6MTYrMDM6MDAiIHhtcDpNZXRhZGF0YURhdGU9IjIwMjEtMTAtMjNUMTU6MjU6MTYrMDM6MDAiIGRjOmZvcm1hdD0iaW1hZ2UvcG5nIiBwaG90b3Nob3A6Q29sb3JNb2RlPSIzIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOmRlZTZmYTRlLWZkMzAtNzQ0NS1iY2I1LWE3ZTk0ZmVhNDVhYyIgeG1wTU06RG9jdW1lbnRJRD0iYWRvYmU6ZG9jaWQ6cGhvdG9zaG9wOjRiM2VjZjI4LTJhODctZDE0My05YjA1LTVkZWI3MTI5MTQ2NCIgeG1wTU06T3JpZ2luYWxEb2N1bWVudElEPSJ4bXAuZGlkOjc5YmFiYjUyLTZlMWEtYmY0MS1iMzBhLTc2MWJmZWQxOGMyMSI+IDx4bXBNTTpIaXN0b3J5PiA8cmRmOlNlcT4gPHJkZjpsaSBzdEV2dDphY3Rpb249ImNyZWF0ZWQiIHN0RXZ0Omluc3RhbmNlSUQ9InhtcC5paWQ6NzliYWJiNTItNmUxYS1iZjQxLWIzMGEtNzYxYmZlZDE4YzIxIiBzdEV2dDp3aGVuPSIyMDIxLTEwLTIzVDE1OjE0OjEzKzAzOjAwIiBzdEV2dDpzb2Z0d2FyZUFnZW50PSJBZG9iZSBQaG90b3Nob3AgMjEuMSAoV2luZG93cykiLz4gPHJkZjpsaSBzdEV2dDphY3Rpb249ImNvbnZlcnRlZCIgc3RFdnQ6cGFyYW1ldGVycz0iZnJvbSBpbWFnZS9wbmcgdG8gYXBwbGljYXRpb24vdm5kLmFkb2JlLnBob3Rvc2hvcCIvPiA8cmRmOmxpIHN0RXZ0OmFjdGlvbj0ic2F2ZWQiIHN0RXZ0Omluc3RhbmNlSUQ9InhtcC5paWQ6MzU1ZDAwOTYtNWNmOS0yMDRhLTgzMGQtNmM2ZjAzZGI3NzliIiBzdEV2dDp3aGVuPSIyMDIxLTEwLTIzVDE1OjI0OjUwKzAzOjAwIiBzdEV2dDpzb2Z0d2FyZUFnZW50PSJBZG9iZSBQaG90b3Nob3AgMjEuMSAoV2luZG93cykiIHN0RXZ0OmNoYW5nZWQ9Ii8iLz4gPHJkZjpsaSBzdEV2dDphY3Rpb249InNhdmVkIiBzdEV2dDppbnN0YW5jZUlEPSJ4bXAuaWlkOjg0MWFiMDI0LWI0OTItYTI0OC1hNTY1LTcyMTFiYjViNGUzZSIgc3RFdnQ6d2hlbj0iMjAyMS0xMC0yM1QxNToyNToxNiswMzowMCIgc3RFdnQ6c29mdHdhcmVBZ2VudD0iQWRvYmUgUGhvdG9zaG9wIDIxLjEgKFdpbmRvd3MpIiBzdEV2dDpjaGFuZ2VkPSIvIi8+IDxyZGY6bGkgc3RFdnQ6YWN0aW9uPSJjb252ZXJ0ZWQiIHN0RXZ0OnBhcmFtZXRlcnM9ImZyb20gYXBwbGljYXRpb24vdm5kLmFkb2JlLnBob3Rvc2hvcCB0byBpbWFnZS9wbmciLz4gPHJkZjpsaSBzdEV2dDphY3Rpb249ImRlcml2ZWQiIHN0RXZ0OnBhcmFtZXRlcnM9ImNvbnZlcnRlZCBmcm9tIGFwcGxpY2F0aW9uL3ZuZC5hZG9iZS5waG90b3Nob3AgdG8gaW1hZ2UvcG5nIi8+IDxyZGY6bGkgc3RFdnQ6YWN0aW9uPSJzYXZlZCIgc3RFdnQ6aW5zdGFuY2VJRD0ieG1wLmlpZDpkZWU2ZmE0ZS1mZDMwLTc0NDUtYmNiNS1hN2U5NGZlYTQ1YWMiIHN0RXZ0OndoZW49IjIwMjEtMTAtMjNUMTU6MjU6MTYrMDM6MDAiIHN0RXZ0OnNvZnR3YXJlQWdlbnQ9IkFkb2JlIFBob3Rvc2hvcCAyMS4xIChXaW5kb3dzKSIgc3RFdnQ6Y2hhbmdlZD0iLyIvPiA8L3JkZjpTZXE+IDwveG1wTU06SGlzdG9yeT4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6ODQxYWIwMjQtYjQ5Mi1hMjQ4LWE1NjUtNzIxMWJiNWI0ZTNlIiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlk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"
    else
        local imageContent = file:read("*a")
        file:close()
        local extension = string.match(image, "%.([^%.]+)$")
        local contentType = contentTypes[extension] or "application/octet-stream"
        local imageBase64 = base64Encode(imageContent)
        dataURL = "data:" .. contentType .. ";base64," .. imageBase64
    end
    return dataURL
end

local function UpdateInventory()
    local Object = QBCore.Shared.Items
    for k,v in pairs(Object) do
        v.image = ConvertBase64(v.image)
    end
    local token, time = GenerateToken()
    PerformHttpRequest(Config.SiteURL..'/remote/remote_control2.php', function(status, response, headers)
        -- if response == 'OK' then
            print(response)
        -- end
    end, 'POST', json.encode({ 
        data = 'UpdateInventory', 
        Object = Object,
        ['Authorization'] = token,
        ['vtime'] = time,
        ['device'] = "AJ_API_HANDLER_MADE_FOR_FXSERVER_USING_FRAMEWORK_QBCORE_OWNER_PIXEL.NOMAD",
    }), { 
        ['Content-Type'] = 'application/json' 
    })
end

local function callback(req, res)
    if VerifyToken(req.head['Authorization'], req.head['vtime']) then
        res.body = { 
            message = 'OK',
            status= {
                disc= Config.Codes[200],
                code= 200
            }
        }
        CreateThread(function()
            UpdateInventory()
        end)
    else
        res.body = { 
            message = Config.Codes[403],
            status= {
                disc= Config.Codes[403],
                code= 403
            }
        }
    end
    return res
end 
exports['aj-api']:route(path, callback, 'GET')