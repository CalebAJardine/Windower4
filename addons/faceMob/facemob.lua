_addon.version = '1.0'
_addon.name = 'AutoBattle'
_addon.command = 'aba'
_addon.author = 'Chasmic'

require('tables')
require('luau')
packets = require('packets')
local counter = 0

windower.register_event('prerender', function(text)
    counter = counter +1
    if counter == 59 then
        face_target()
        if windower.ffxi.get_mob_by_target('t') then
            engage()
        end
    end
    if counter == 59 then counter = 0 end
end)


function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end


function face_target()
	local target = windower.ffxi.get_mob_by_target('t')
	local self_vector = windower.ffxi.get_mob_by_index(windower.ffxi.get_player().index or 0)
    if target and math.sqrt(target.distance) > 5 then
        if windower.ffxi.get_player().name == "Tyniasen" then
            -- windower.send_command('input /carnageelegy')
        elseif windower.ffxi.get_player().name == "Plasmic" then
            windower.send_command('input /ra <t>')
        end
    else
        windower.send_command('input /assist Chasmic')
        -- windower.send_command('input /assist Spaitin')
    end
	if target then  -- Please note if you target yourself you will face Due East
		local angle = (math.atan2((target.y - self_vector.y), (target.x - self_vector.x))*180/math.pi)*-1
		windower.ffxi.turn((angle):radian())
	end
end

function engage(id, index) 
    local mob = windower.ffxi.get_mob_by_target('t')
    local p = packets.new('outgoing', 0x01A, {
        ['Target'] = mob.id,
        ['Target Index'] = mob.index,
        ['Category'] = 2,
        ['Param'] = 0,
        ['_unknown1'] = 0,
        ['X Offset'] = 0,
        ['Y Offset'] = 0,
        ['Z Offset'] = 0,
    })
    packets.inject(p)
end