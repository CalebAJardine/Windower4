_addon.author   = 'Chasmic'
_addon.version  = '1.0'
_addon.commands = {'MT'}

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
tp = windower.ffxi.get_mob_by_id(17186827)
function move_for_1_second()
    windower.ffxi.run()
    coroutine.sleep(1)
    windower.ffxi.run(false)
end

function acquire_target()
    local me = windower.ffxi.get_mob_by_target('me')
    -- local tp = windower.ffxi.get_mob_by_id(17186830)
    
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
    -- local tp = windower.ffxi.get_mob_by_id(17186830)
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
                log(tp.x)
                log(tp.y)
            end
        end
    end
end

windower.register_event('addon command', function(command, ...)
    local cmd = string.lower(command)
    local args = {...}
    
    if cmd == 'at' then
        acquire_target()
    elseif cmd == 'm' then
        move_for_1_second()
    end
end)


windower.register_event('incoming chunk', on_incoming_chunk_death_info)