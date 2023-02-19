_addon.author   = 'Kaotic'
_addon.version  = '1.3'
_addon.commands = {'Quetz'}

require('logger')
require('coroutine')
packets = require('packets')
res = require('resources')

local conditions = {

	quetzPortal = false,
	goblin = false,
	reisenPortal = false,
	running = false,
	quetzAlive = false,
	quetzDead = false,
	
}
quetz_id = 17969868

function stop()
	
	windower.send_command('lua unload quetz')
	
end


function start()
	log('Waiting for pop zZz...')
	local pl = windower.ffxi.get_player()
	if pl.name == "Quasmic" then
		coroutine.sleep(1)
	end
	local quetz = windower.ffxi.get_mob_by_name('Quetzalcoatl')
	quetzDead = true
	while quetzDead do
		if quetz.hpp > 0 then
			quetzDead = false
		end
		coroutine.sleep(.25)
		quetz = windower.ffxi.get_mob_by_name('Quetzalcoatl')
	end
	log('zomg pop quick claim it!')
	fight()
end


function fight()
	coroutine.sleep(1)
	log('Whoooo we got it boizzzz!')
	engage()
	local pl = windower.ffxi.get_player()
	if pl.name == "Quasmic" then
		coroutine.sleep(1)
	end
	local quetz = windower.ffxi.get_mob_by_name('Quetzalcoatl')
	quetzAlive = true
	while quetzAlive do
		if quetz.hpp == 0 then
			quetzAlive = false
		end
		coroutine.sleep(.25)
		quetz = windower.ffxi.get_mob_by_name('Quetzalcoatl')
	end
	exitArena()
end

function exitArena()
	local pl = windower.ffxi.get_player()
	if pl.name == "Quasmic" then
		coroutine.sleep(1)
	end
	
	local player = windower.ffxi.get_player()
	
	if player.vitals.hp == 0 then
		log('You died =( Shutting down.')
		coroutine.sleep(30)
		windower.send_command('setkey enter down')
		coroutine.sleep(.05)
		windower.send_command('setkey enter up')
		coroutine.sleep(.05)
		windower.send_command('quetz stop')
		--log('Raise accepted,')
		--coroutine.sleep(30)
		--windower.send_command('input /equip ring2 "Dim. Ring (Holla)"')
		--coroutine.sleep(10)
		--windower.send_command('input /item "Dim. Ring (Holla)" <me>')
		--coroutine.sleep(45)
		--enterReisen()
	else
		log("Fight's over, teleporting in 5 minutes.")
		coroutine.sleep(300)

		windower.send_command('input /equip ring2 "Dim. Ring (Holla)"')
		coroutine.sleep(.05)
		-- windower.send_command('input //lua unload enternity')
		coroutine.sleep(11)
		windower.send_command('input /item "Dim. Ring (Holla)" <me>')
		coroutine.sleep(45)
		enterReisen()
	end

end


function enterReisen()
	local dimensional_portal = 17195618
	log('Entering Reisenjima in 2 minutes.')
	
	coroutine.sleep(120)
	
	local me = windower.ffxi.get_mob_by_target('me')
	local tp = windower.ffxi.get_mob_by_id(dimensional_portal)
	
	
	windower.ffxi.run(tp.x - me.x, tp.y - me.y, tp.z - me.z)
	coroutine.sleep(1.5)
	windower.ffxi.run(false)
	local pl = windower.ffxi.get_player()
	if pl.name == "Quasmic" then
		coroutine.sleep(1)
	end

    if tp then
        local p = packets.new('outgoing', 0x01A, {
            ['Target'] = tp.id,
            ['Target Index'] = tp.index,
        })
        packets.inject(p)
    end

	-- coroutine.sleep(10)
	-- windower.send_command('setkey enter down')
	-- coroutine.sleep(.05)
	-- windower.send_command('setkey enter up')
	coroutine.sleep(7)
	windower.send_command('setkey up down')
	coroutine.sleep(.05)
	windower.send_command('setkey up up')
	coroutine.sleep(.50)
	windower.send_command('setkey enter down')
	coroutine.sleep(.05)
	windower.send_command('setkey enter up')
	coroutine.sleep(.50)
	
	log('Obtaining Elvorseal in 2 minutes.')
	coroutine.sleep(120)
	
	windower.send_command('setkey n down')
	coroutine.sleep(.05)
	windower.send_command('setkey n up')
	coroutine.sleep(.5)
	windower.send_command('setkey n down')
	coroutine.sleep(.05)
	windower.send_command('setkey n up')
	coroutine.sleep(.5)
	windower.send_command('setkey n down')
	coroutine.sleep(.05)
	windower.send_command('setkey n up')
	coroutine.sleep(.5)

	enterArena()

end


function enterArena()
	local Shiftrix = 17969973
	log('Obtaining Elvorseal')
	
	windower.send_command('setkey n down')
	coroutine.sleep(.05)
	windower.send_command('setkey n up')
	coroutine.sleep(.5)

	windower.send_command('setkey n down')
	coroutine.sleep(.05)
	windower.send_command('setkey n up')
	coroutine.sleep(.5)

	windower.send_command('setkey n down')
	coroutine.sleep(.05)
	windower.send_command('setkey n up')
	coroutine.sleep(.5)
	
	local pl = windower.ffxi.get_player()
	if pl.name == "Quasmic" then
		coroutine.sleep(1)
	end
	local gob = windower.ffxi.get_mob_by_id(Shiftrix)
    if gob then
        local p = packets.new('outgoing', 0x01A, {
            ['Target'] = gob.id,
            ['Target Index'] = gob.index,
        })
        packets.inject(p)
    end
	
	coroutine.sleep(10)
	
	-- windower.send_command('setkey enter down')
	-- coroutine.sleep(.05)
	-- windower.send_command('setkey enter up')
	-- coroutine.sleep(7)
	
	windower.send_command('setkey down down')
	coroutine.sleep(.05)
	windower.send_command('setkey down up')
	coroutine.sleep(.5)
	
	windower.send_command('setkey enter down')
	coroutine.sleep(.05)
	windower.send_command('setkey enter up')
	coroutine.sleep(5)
	
	-- windower.send_command('setkey enter down')
	-- coroutine.sleep(.05)
	-- windower.send_command('setkey enter up')
	-- coroutine.sleep(5)

	-- windower.send_command('setkey enter down')
	-- coroutine.sleep(.05)
	-- windower.send_command('setkey enter up')
	-- coroutine.sleep(5)

	-- windower.send_command('setkey enter down')
	-- coroutine.sleep(.05)
	-- windower.send_command('setkey enter up')
	-- coroutine.sleep(5)
	
	-- windower.send_command('setkey enter down')
	-- coroutine.sleep(.05)
	-- windower.send_command('setkey enter up')
	-- coroutine.sleep(5)
	
	windower.send_command('setkey up down')
	coroutine.sleep(.05)
	windower.send_command('setkey up up')
	coroutine.sleep(5)
	
	windower.send_command('setkey enter down')
	coroutine.sleep(.05)
	windower.send_command('setkey enter up')
	coroutine.sleep(5)
	
	-- windower.send_command('setkey enter down')
	-- coroutine.sleep(.05)
	-- windower.send_command('setkey enter up')
	-- coroutine.sleep(5)
	
	
	log('Elvorseal obtained, moving to fighting location in 1 minute.')
	coroutine.sleep(60)
	
	moveToLocation()

end


function moveToLocation()

	coroutine.sleep(1)
	windower.ffxi.turn(-3.65)
	coroutine.sleep(.5)
	log('Moving to pull location.')
	windower.ffxi.run(true)
	coroutine.sleep(4)
	windower.ffxi.run(false)
	log('Arrived at pull location.')
	coroutine.sleep(.5)
	log('Summoning Trusts')
	coroutine.sleep(.5)
	
	--Here is where you can edit the trust list that you wish to summon
	--Remove the -- infront of the lines if you want to use additional trusts, I use 4 of the same ones for each character and use easyfarm to summon the other character specific one.
	--If you use easyfarm for trusts, put -- in front of each line 246-254, but I recommend putting them in the Battle tab.
	
	windower.send_command('input /ma "Yoran-Oran (UC)" <me>')
	coroutine.sleep(8)
	windower.send_command('input /ma "Joachim" <me>')
	coroutine.sleep(8)
	windower.send_command('input /ma "qultada" <me>')
	coroutine.sleep(8)
	windower.send_command('input /ma "lilisette II" <me>')
	coroutine.sleep(8)
	windower.send_command('input /ma "apururu (uc)" <me>')
	coroutine.sleep(5)
	
	coroutine.sleep(10)
	start()

end


function test()


	local zone = windower.ffxi.get_info()
		log(zone.zone)

end

function engage()
	local pl = windower.ffxi.get_player()
	if pl.name == "Quasmic" then
		coroutine.sleep(1)
	end
    local me = windower.ffxi.get_mob_by_target('me')
    local tp = windower.ffxi.get_mob_by_id(quetz_id)
    
    if tp then
        local p = packets.new('outgoing', 0x01A, {
            ['Target'] = tp.id,
            ['Target Index'] = tp.index,
            ['Category'] = 2,
            ['Param'] = 0,
            ['_unknown1'] = 0,
            ['X Offset'] = 0,
            ['Y Offset'] = 0,
            ['Z Offset'] = 0,
        })
        packets.inject(p)
        windower.ffxi.run()
    end
    
	
    
    -- windower.register_event('target change', function(...)
    --     windower.ffxi.run(false)
    -- end)
end

function on_incoming_chunk_death_info(id, data, modified, injected, blocked)
    local me = windower.ffxi.get_mob_by_target('me')
    local tp = windower.ffxi.get_mob_by_id(quetz_id)
    if id == 0x29 then
        local target_id = data:unpack('I',0x09)
        local message_id = data:unpack('H',0x19)%32768

        -- Remove mobs that die from our tagged mobs list.
        if target_id then
            -- 6 == actor defeats target
            -- 20 == target falls to the ground
            if message_id == 6 or message_id == 20 then
                windower.ffxi.run(false)
            elseif message_id == 78 then
                windower.ffxi.run(tp.x - me.x, tp.y - me.y, tp.z - me.z)
                coroutine.sleep(1)
                windower.ffxi.run(false)
            end
        end
    end
end



windower.register_event('addon command', function(input, ...)
    local cmd = string.lower(input)
	local args = {...}
	
	if cmd == 'stop' then
		stop()
    elseif cmd == 'start' then
		start()
	elseif cmd == 'exit' then
		exitArena()
	elseif cmd == 'enter' then
		enterArena()
	elseif cmd == 'move' then
		moveToLocation()
	elseif cmd == 'test' then
		test()
	elseif cmd == 'fight' then
		fight()
	elseif cmd == 'reisen' then
		enterReisen()
    end
end)

windower.register_event('incoming chunk', on_incoming_chunk_death_info)