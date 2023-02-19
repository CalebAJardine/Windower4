_addon.name = 'MB'
_addon.author = 'Chasmic'
_addon.commands = {'mb'}
_addon.version = '1.0'
_libs = _libs or {}
_libs.luau = _libs.luau or require('luau')


windower.register_event('addon command', function(...)
	local args = T {...}
	local cmd = args[1]
	if cmd then
		if cmd:lower() == 'f2' then
			windower.send_command('input /ja "addendum: black" <me>"')
			windower.send_command('input /ma "fire II" <bt>')
		elseif cmd:lower() == 'a2' then
			windower.send_command('input /ma "aero II" <bt>')
		elseif cmd:lower() == 't2' then
			windower.send_command('input /ma "thunder II" <bt>')
		elseif cmd:lower() == 'i2' then
			windower.send_command('input /ma "ice III" <bt>')
		elseif cmd:lower() == 's2' then
			windower.send_command('input /ma "stone II" <bt>')
		elseif cmd:lower() == 't3' then
			windower.send_command('input /ma "aero V" <bt>')
		end
	end
end)