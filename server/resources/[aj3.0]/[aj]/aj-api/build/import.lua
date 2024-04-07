local lib = exports['aj-api']:getapi()
local http = { fetch = 'GET', post = 'POST' }

local aj_api = setmetatable({}, {
	__index = function(self, index)
		if http[index] ~= nil then
			return function(uri, cb, head, body)
				self.request(uri, {
					head = head or {},
					body = body or {}
				}, cb, http[index])
			end
		else
			return function(...)
				lib[index](...)
			end
		end
	end
})

_G.aj_api = aj_api