_addon.name = 'Notify'

_addon.author = 'Chasmic'

_addon.commands = {'Note'}

_addon.version = '1.0'

_libs = _libs or {}

_libs.luau = _libs.luau or require('luau')


local function send_delay(delay, command)
	coroutine.schedule(function() windower.send_command(command) end, delay)
end



windower.register_event('incoming text',function (original)

	if string.contains(original, 'cast aspir') then
	
		windower.send_command('input /ma "aspir II" <bt>')
		
	elseif original.contains(original, 'Protect') then

		windower.send_command('input /ma "geo-refresh" <me>')
		--send_delay(4.5, 'input /ma "fire IV" <bt>')

	elseif original.contains(original, 'shell') then

		windower.send_command('input /ma "refresh" Chasmic')
		--send_delay(4.5, 'input /ma "aero IV" <bt>');
		
	elseif original.contains(original, 'cast thunder') then

		windower.send_command('input /ma "thunder IV" <bt>')
		--send_delay(4.5, 'input /ma "thunder IV" <bt>')
		
	elseif original.contains(original, 'Scholar:') then

		send_delay(2.5, 'input /mn')
		--windower.send_command('input /ma "" <me>')
		--send_delay(4.5, 'input /ma geo-malaise <bt>')
	
	-- elseif original.contains(original, 'Chasmic casts') then

		-- windower.send_command('input /ma "geo-malaise" <bt>')
		
	-- elseif original.contains(original, 'malaise') then

		-- windower.send_command('input /ma "geo-malaise" <bt>')	
		
	elseif original.contains(original, 'Distortion') then

		windower.send_command('input /ma "water V" <bt>')
		send_delay(1.0, 'input /tell Spasmic malaise')
		send_delay(4.5, 'input /ma "Water VI" <bt>')
		
	
		
	--elseif original.contains(original, 'readies Leaden Salute') then
		
		-- windower.send_command('input /assist Pillage')
		-- send_delay(1, 'input /ma "Blizzard V" <t>')
		-- send_delay(3.5, 'input /ma "Stone V" <t>')

	end

end)