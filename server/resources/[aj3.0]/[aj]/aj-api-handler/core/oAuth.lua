local hmac = exports['aj-api']['hmac_sha256']

function GenerateKey(secret, shift)
    local newKey = ""
    local keyLength = string.len(secret)
    for i = 1, keyLength do
        local charCode = string.byte(secret, i)
        charCode = charCode + shift
        newKey = newKey .. string.char(charCode)
    end
    return newKey
end

function VerifyToken(token, time)
    local secretuseless = GenerateKey(Config.SITE_TOKEN, 2)
    local secret = GenerateKey(secretuseless .. time, 3)
    local secretfinal = GenerateKey(secret, 1)
    local expectedToken = hmac("sha256", secretfinal, secret)
    return token == expectedToken
end

function GenerateToken()
    local time = os.time()
    local secretuseless = GenerateKey(Config.SITE_TOKEN, 2)
    local secret = GenerateKey(secretuseless .. time, 3)
    local secretfinal = GenerateKey(secret, 1)
    
    local token = hmac("sha256", secretfinal, secret)
    return token, time
end