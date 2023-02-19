function processCommand(command,...)
	command = command and command:lower() or 'help'
	local args = {...}
	
	if command == 'reload' then
		windower.send_command('lua reload healBot')
	elseif command == 'unload' then
		windower.send_command('lua unload healBot')
	elseif command == 'refresh' then
		load_configs()
	elseif S{'start','on'}:contains(command) then
		activate()
	elseif S{'stop','end','off'}:contains(command) then
		active = false
		printStatus()
	elseif S{'disable'}:contains(command) then
		if not validate(args, 1, 'Error: No argument specified for Disable') then return end
		disableCommand(args[1]:lower(), true)
	elseif S{'enable'}:contains(command) then
		if not validate(args, 1, 'Error: No argument specified for Enable') then return end	
		disableCommand(args[1]:lower(), false)
	elseif S{'assist','as'}:contains(command) then
		local cmd = args[1] and args[1]:lower() or (settings.assist.active and 'off' or 'resume')
		if S{'off','end','false','pause'}:contains(cmd) then
			settings.assist.active = false
			atc('Assist is now off.')
		elseif S{'resume'}:contains(cmd) then
			if (settings.assist.name ~= nil) then
				settings.assist.active = true
				atc('Now assisting '..settings.assist.name..'.')
			else
				atc(123,'Error: Unable to resume assist - no target set')
			end
		elseif S{'attack','engage'}:contains(cmd) then
			local cmd2 = args[2] and args[2]:lower() or (settings.assist.engage and 'off' or 'resume')
			if S{'off','end','false','pause'}:contains(cmd2) then
				settings.assist.engage = false
				atc('Will no longer enagage when assisting.')
			else
				settings.assist.engage = true
				atc('Will now enagage when assisting.')
			end
		else	--args[1] is guaranteed to have a value if this is reached
			local pname = getPlayerName(args[1])
			if (pname ~= nil) then
				settings.assist.name = pname
				settings.assist.active = true
				atc('Now assisting '..settings.assist.name..'.')
			else
				atc(123,'Error: Invalid name provided as an assist target: '..tostring(args[1]))
			end
		end
	elseif S{'ws','weaponskill'}:contains(command) then
		local lte,gte = string.char(0x81, 0x85),string.char(0x81, 0x86)
		local cmd = args[1] and args[1] or ''
		settings.ws = settings.ws or {}
		if S{'use','set'}:contains(cmd) then	-- ws name
			table.remove(args, 1)
			local argstr = table.concat(args,' ')
			local wsname = formatSpellName(argstr)
			local ws = getActionFor(wsname)
			if (ws ~= nil) then
				settings.ws.name = wsname
				atc('Will now use '..wsname)
			else
				atc(123,'Error: Invalid weaponskill name: '..wsname)
			end
		elseif (cmd == 'waitfor') then		--another player's TP
			local partner = getPlayerName(args[2])
			if (partner ~= nil) then
				local partnertp = tonumber(args[3]) or 1000
				settings.ws.partner = {name=partner,tp=partnertp}
				atc("Will weaponskill when "..partner.."'s TP is "..gte.." "..partnertp)
			else
				atc(123,'Error: Invalid argument for ws waitfor: '..tostring(args[2]))
			end
		elseif (cmd == 'nopartner') then
			settings.ws.partner = nil
			atc('Weaponskill partner removed.')
		elseif (cmd == 'hp') then		--Target's HP
			local sign = S{'<','>'}:contains(args[2]) and args[2] or nil
			local hp = tonumber(args[3])
			if (sign ~= nil) and (hp ~= nil) then
				settings.ws.sign = sign
				settings.ws.hp = hp
				atc("Will weaponskill when the target's HP is "..sign.." "..hp.."%")
			else
				atc(123,'Error: Invalid arguments for ws hp: '..tostring(args[2])..', '..tostring(args[3]))
			end
		end
	elseif S{'spam','nuke'}:contains(command) then
		local cmd = args[1] and args[1]:lower() or (settings.nuke.active and 'off' or 'on')
		if S{'on','true'}:contains(cmd) then
			settings.nuke.active = true
			if (settings.nuke.name ~= nil) then
				atc('Spell spamming is now on. Spell: '..settings.nuke.name)
			else
				atc('Spell spamming is now on. To set a spell to use: //hb spam use <spell>')
			end
		elseif S{'off','false'}:contains(cmd) then
			settings.nuke.active = false
			atc('Spell spamming is now off.')
		elseif S{'use','set'}:contains(cmd) then
			table.remove(args, 1)
			local argstr = table.concat(args,' ')
			local spell_name = formatSpellName(argstr)
			local spell = getActionFor(spell_name)
			if (spell ~= nil) then
				if Assert.can_use(spell) then
					settings.nuke.name = spell.en
					atc('Will now spam '..settings.nuke.name)
				else
					atc(123,'Error: Unable to cast '..spell.en)
				end
			else
				atc(123,'Error: Invalid spell name: '..spell_name)
			end
		end
	elseif command == 'mincure' then
		if not validate(args, 1, 'Error: No argument specified for minCure') then return end
		local val = tonumber(args[1])
		if (val ~= nil) and (1 <= val) and (val <= 6) then
			minCureTier = val
			atc('Minimum cure tier set to '..minCureTier)
		else
			atc('Error: Invalid argument specified for minCure')
		end
	elseif command == 'reset' then
		if not validate(args, 1, 'Error: No argument specified for reset') then return end
		local rcmd = args[1]:lower()
		local b,d = false,false
		if S{'all','both'}:contains(rcmd) then
			b,d = true,true
		elseif (rcmd == 'buffs') then
			b = true
		elseif (rcmd == 'debuffs') then
			d = true
		else
			atc('Error: Invalid argument specified for reset: '..arg[1])
			return
		end
		
		local resetTarget
		if (args[2] ~= nil) and (args[3] ~= nil) and (args[2]:lower() == 'on') then
			local pname = getPlayerName(args[3])
			if (pname ~= nil) then
				resetTarget = pname
			else
				atc(123,'Error: Invalid name provided as a reset target: '..tostring(args[3]))
				return
			end
		end
		
		if b then
			if (resetTarget ~= nil) then
				resetBuffTimers(resetTarget)
				atc('Buffs registered for '..resetTarget..' were reset.')
			else
				for player,_ in pairs(buffList) do
					resetBuffTimers(player)
				end
				atc('Buffs registered for all monitored players were reset.')
			end
		end
		if d then
			if (resetTarget ~= nil) then
				debuffList[resetTarget]= {}
				atc('Debuffs registered for '..resetTarget..' were reset.')
			else
				debuffList = {}
				atc('Debuffs registered for all monitored players were reset.')
			end
		end
	elseif command == 'buff' then
		registerNewBuff(args, true)
	elseif command == 'cancelbuff' then
		registerNewBuff(args, false)
	elseif command == 'bufflist' then
		if not validate(args, 1, 'Error: No argument specified for BuffList') then return end
		local blist = defaultBuffs[args[1]]
		if blist ~= nil then
			for _,buff in pairs(blist) do
				registerNewBuff({args[2], buff}, true)
			end
		else
			atc('Error: Invalid argument specified for BuffList: '..args[1])
		end
	elseif command == 'ignore_debuff' then
		registerIgnoreDebuff(args, true)
	elseif command == 'unignore_debuff' then
		registerIgnoreDebuff(args, false)
	elseif S{'follow','f'}:contains(command) then
		local cmd = args[1] and args[1]:lower() or (settings.follow.active and 'off' or 'resume')
		if S{'off','end','false','pause'}:contains(cmd) then
			settings.follow.active = false
		elseif S{'distance', 'dist', 'd'}:contains(cmd) then
			local dist = tonumber(args[2])
			if (dist ~= nil) and (0 < dist) and (dist < 45) then
				settings.follow.distance = dist
				atc('Follow distance set to '..settings.follow.distance)
			else
				atc('Error: Invalid argument specified for follow distance')
			end
		elseif S{'resume'}:contains(cmd) then
			if (settings.follow.target ~= nil) then
				settings.follow.active = true
				atc('Now following '..settings.follow.target..'.')
			else
				atc(123,'Error: Unable to resume follow - no target set')
			end
		else	--args[1] is guaranteed to have a value if this is reached
			local pname = getPlayerName(args[1])
			if (pname ~= nil) then
				settings.follow.target = pname
				settings.follow.active = true
				atc('Now following '..settings.follow.target..'.')
			else
				atc(123,'Error: Invalid name provided as a follow target: '..tostring(args[1]))
			end
		end
	elseif S{'ignore', 'unignore', 'watch', 'unwatch'}:contains(command) then
		monitorCommand(command, args[1])
	elseif command == 'ignoretrusts' then
		toggleMode('ignoreTrusts', args[1], 'Ignoring of Trust NPCs', 'IgnoreTrusts')
	elseif command == 'packetinfo' then
		toggleMode('showPacketInfo', args[1], 'Packet info display', 'PacketInfo')
	elseif command == 'moveinfo' then
		if posCommand('moveInfo', args) then
			refresh_textBoxes()
		else
			toggleVisible('moveInfo', args[1])
		end
	elseif command == 'actioninfo' then
		if posCommand('actionInfo', args) then
			refresh_textBoxes()
		else
			toggleVisible('actionInfo', args[1])
		end
	elseif S{'showq','showqueue','queue'}:contains(command) then
		if posCommand('actionQueue', args) then
			refresh_textBoxes()
		else
			toggleVisible('actionQueue', args[1])
		end
	elseif S{'monitored','showmonitored'}:contains(command) then
		if posCommand('montoredBox', args) then
			refresh_textBoxes()
		else
			toggleVisible('montoredBox', args[1])
		end
	elseif S{'help','--help'}:contains(command) then
		help_text()
	elseif command == 'settings' then
		for k,v in pairs(settings) do
			local kstr = tostring(k)
			local vstr = (type(v) == 'table') and tostring(T(v)) or tostring(v)
			atc(kstr:rpad(' ',15)..': '..vstr)
		end
	elseif command == 'status' then
		printStatus()
	elseif command == 'info' then
		if info == nil then
			atc(3,'Unable to parse info.  Windower/addons/info/info_shared.lua was unable to be loaded.')
			atc(3,'If you would like to use this function, please visit https://github.com/lorand-ffxi/addons to download it.')
			return
		end
		local cmd = args[1]	--Take the first element as the command
		table.remove(args, 1)	--Remove the first from the list of args
		info.process_input(cmd, args)
	else
		atc('Error: Unknown command')
	end
end

function update_settings(loaded)
	settings = settings or {}
	for key,vals in pairs(loaded) do
		settings[key] = settings[key] or {}
		for vkey,val in pairs(vals) do
			settings[key][vkey] = val
		end
	end
	settings.actionDelay = settings.actionDelay or 0.08
	settings.assist = settings.assist or {}
	settings.assist.active = settings.assist.active or false
	settings.assist.engage = settings.assist.engage or false
	settings.disable = settings.disable or {}
	settings.follow = settings.follow or {}
	settings.follow.delay = settings.follow.delay or 0.08
	settings.follow.distance = settings.follow.distance or 3
	settings.healing = settings.healing or {}
	settings.healing.minCure = settings.healing.minCure or 3
	settings.healing.minCuraga = settings.healing.minCuraga or 1
	settings.healing.minWaltz = settings.healing.minWaltz or 2
	settings.healing.minWaltzga = settings.healing.minWaltzga or 1
	settings.nuke = settings.nuke or {}
end

function colorFor(col)
	local cstr = ''
	if not ((S{256,257}:contains(col)) or (col<1) or (col>511)) then
		if (col <= 255) then
			cstr = string.char(0x1F)..string.char(col)
		else
			cstr = string.char(0x1E)..string.char(col - 256)
		end
	end
	return cstr
end

function string.colorize(str, new_col, reset_col)
	new_col = new_col or 1
	reset_col = reset_col or 1
	return colorFor(new_col)..str..colorFor(reset_col)
end

function atcc(c,msg)
	if (type(c) == 'string') and (msg == nil) then
		msg = c
		c = 0
	end
	local hbmsg = '[TankBot]'..msg
	windower.add_to_chat(0, hbmsg:colorize(c))
end
