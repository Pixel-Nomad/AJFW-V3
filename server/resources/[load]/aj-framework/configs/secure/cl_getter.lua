local function SecureConfigGetter()
    AJFW.Functions.TriggerCallback('aj-framework:config:Secured', function(Data)
		Config.Secure = Data
	end)
end

exports('SecureConfigGetter', SecureConfigGetter)