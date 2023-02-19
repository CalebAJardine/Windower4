_addon.name = 'GeoBot'

_addon.author = 'Chasmic'

_addon.commands = {'gb', 'geobot'}

_addon.version = '1.0'

_libs = _libs or {}

_libs.luau = _libs.luau or require('luau')

_libs = _libs or {}

res = require('resources')
config = require('config')
texts = require('texts')
packets = require('packets')
files = require('files')

lastEntrust = 0
entrustRecast = 610
resummon = 10
indi = ''
entrustSpell = ''
geo = ''
player = ''
entrustTarg = ''
entrustActive = false
geobotActive = false


spells = S{
	'wilt', 'frailty', 'slip', 'torpor', 'fade', 'malaise', 'vex', 'languor', 'poison', 'slow', 'paralysis', 'gravity',
	'regen', 'refresh', 'haste', 'fury', 'barrier', 'precision', 'voidance', 'acumen', 'fend', 'focus', 'attunement', 
	'str', 'dex', 'vit', 'agi', 'mnd', 'int', 'chr'
}

eTargGeo = S{
	'geo-wilt', 'geo-frailty', 'geo-slip', 'geo-torpor', 'geo-fade', 'geo-malaise', 'geo-vex', 'geo-languor', 'geo-poison', 'geo-slow', 'geo-paralysis', 'geo-gravity'
}

pTargGeo = S{
	'geo-regen', 'geo-refresh', 'geo-haste', 'geo-fury', 'geo-barrier', 'geo-precision', 'geo-voidance', 'geo-acumen', 'geo-fend', 'geo-focus', 'geo-attunement', 
	'geo-str', 'geo-dex', 'geo-vit', 'geo-agi', 'geo-mnd', 'geo-int', 'geo-chr'
}


windower.register_event('load', function()
	windower.add_to_chat(262,'Welcome to GeoBot! To see a list of commands, type //gb help')
	actionStart = os.clock()
	lastAction = os.clock()
	attemptCD = 5
	lastAttempt = os.clock()
end)


function gb_output(msg)
	windower.add_to_chat(262, msg)
end


function buff_active(...)
	local args = S{...}:map(string.lower)
	local player = windower.ffxi.get_player()
	if (player ~= nil) and (player.buffs ~= nil) then
		for _,bid in pairs(player.buffs) do
			local buff = res.buffs[bid]
			if args:contains(buff.en:lower()) then
				return true
			end
		end
	end
	return false
end


windower.register_event('prerender', function()
	if geobotActive then

		local mob = windower.ffxi.get_mob_by_target('bt') or false
		local pet = windower.ffxi.get_mob_by_target('pet') or false

		if not buff_active('Colure Active') then
			if (os.clock() - lastAttempt > attemptCD and indi ~= '') then
				windower.send_command('input /ma ' .. indi .. ' <me>')
				lastAttempt = os.clock()
			end
		end
				
		if (os.clock() - lastAttempt > attemptCD) and mob then
			if not pet then
				if (pTargGeo:contains(geo) and geo ~= '')then
					windower.send_command( 'input /ma ' .. geo .. ' <me>')
				elseif (eTargGeo:contains(geo) and geo ~= '' and mob and mob.index < 0x401)then
					windower.send_command('input /ma ' .. geo .. ' <bt>')
				end
				lastAttempt = os.clock()
			end
		end
		
		if (os.clock() - lastAttempt > attemptCD) then
			if pet and pet.hpp < resummon then
				lastAttempt = os.clock()
				windower.send_command('input /ja "Full Circle" <me>')
				lastAttempt = os.clock()
			end
		end
	end
end)


local function send_delay(delay, command)
	coroutine.schedule(function() windower.send_command(command) end, delay)
end

windower.register_event('zone change', function()
	geobotActive = false
end)

windower.register_event('addon command', function()
	return function(command, ...)
		
		
		if command == 'e' then
            assert(loadstring(table.concat({...}, ' ')))()
            return
        end
		local params = {...}
		
		command = (command or 'help'):lower()
		
		if command == 'help' then
            gb_output('GeoBot v' .. _addon.version .. '. Author: Chasmic')
            gb_output('gb help : Shows help message')
            gb_output('gb geo <spell suffix> sets geo spell to keep up i.e. gb geo frailty')
            gb_output('gb indi <spell suffix> sets indi spell to keep up i.e. gb indi fury')
			gb_output('gb assist <player name> sets the player whose target you want to cast offensive geo-spells on')
			gb_output('gb rs <number> sets the percent to resummon the luopon: default 10%')
			gb_output('gb entrust <player> <spells> sets entrust to cast on cooldown with the spell set')
			gb_output('gb on/off enables/disables geobot')
		elseif command == 'indi' then
			if (params[1] and spells:contains(params[1]:lower())) then
				indi = 'indi-' .. params[1]:lower()
				gb_output(indi .. ' set as indi spell')
			end
		elseif command == 'geo' then
			if(params[1] and spells:contains(params[1]:lower())) then
				geo = 'geo-' .. params[1]:lower()
				gb_output(geo .. ' set as geo spell')
			end
		elseif command == 'assist' then
			if(params[1]) then
				player = params[1]:lower()
				gb_output(player .. ' is set as the player to assist')
			end
		elseif command == 'rs' then
			if	params[1]:match('[0-9]') then
				resummon = tonumber(params[1])
				gb_output('luopon set to recast at ' .. resummon .. '%')
			end
		elseif (command == 'entrust') then
			if (params[1] and params [2] and spells:contains(params[2]:lower())) then
				entrustTarg = params[1]:lower()
				entrustSpell = 'indi-' .. params[2]:lower() 
				gb_output('entrust target set as: ' .. entrustTarg)
				gb_output('entrust spell set as: ' .. entrustSpell)
			end
		elseif (command == 'on') then
			geobotActive = true
			gb_output('GeoBot turned on')
		elseif (command == 'off') then
			geobotActive = false
			gb_output('GeoBot turned off')
		elseif (command == 'fc') then
			windower.send_command('input /ja "full circle" <me>')
		end
	end
end())
-- end())























