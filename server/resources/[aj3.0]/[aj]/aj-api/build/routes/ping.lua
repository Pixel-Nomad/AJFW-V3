aj_api.route('/ping', function(req, res)
	res.body = { 'pong' }
	return res
end, 'GET')