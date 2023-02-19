_addon.version = '1.0'
_addon.name = 'AutoBattle'
_addon.command = 'aba'
_addon.author = 'Chasmic'

require('tables')
require('luau')
packets = require('packets')

local player = windower.ffxi.get_player()
local killer = 'Chasmic'
local killer2 = 'Plasmic'
local playerName = player.name
local pullerName = 'Spasmic'
local puller2Name = 'Chasmic'
local killerEngaged = false
local closestNamedMob
local mob1 = 'Locus Fiddler Crab'
local mob2 = 'Locus Ghost Crab'
local mob3 = 'Locus Fiddler Crab'
local Dia_II = 24
local pulledMob
local idle = 0
local idle = true
local on = false;
local mobName = "Apex Idle Drifter"
local mobToAttack = windower.ffxi.get_mob_by_target('t')
local distractOnPulled = false
local counter = 0;


windower.register_event('addon command',function (command, ...)
    if(command == 'send') then 
        windower.send_ipc_message('engage');
    end
    if(command == 'target') then
        windower.send_ipc_message('pulled')
    end
    if command == 'on' then
        on = true
    end
    if command == 'off' then
        on = false
    end
end)

windower.register_event('prerender', function()
    counter = counter + 1
    if counter > 59 then counter = 0 end
    if on and counter == 59 then
        checkState()
    end
end)

windower.register_event('ipc message', function(message)
    args = split(message, ' ')
    if args[1] == 'pulled' then
        pulledMob = windower.ffxi.get_mob_by_id(args[2])
    end
end)



windower.register_event('status change', function(new, old)
    -- engaged = 1 idle = 0
    if new == 1 then
        idle = false
        log(new)
    else
        idle = false
        log(old)
    end
end)


function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function checkState()
    if pulledMob then
        pulledMob = windower.ffxi.get_mob_by_id(pulledMob.id)
    end
    if not pulledMob or pulledMob.hpp < 50 then
        coroutine.sleep(1)
        pull()
        distractOnPulled = false
    end

    if  pulledMob and player.name == killer then 
        if pulledMob.hpp > 98 and not distractOnPulled then
            windower.send_command('input /distract3 '.. pulledMob.id)
            distractOnPulled = true
        end
        if math.sqrt(pulledMob.distance) > 5 then
            windower.send_command('input //box dia')
        end
        engage()
        approachTarget()
    end
end

function approachTarget() 
    face_target() 
end

function pull()
    if playerName == pullerName or pullerName == puller2Name then
        coroutine.sleep(2)
        target()
        if pulledMob and pulledMob.hpp > 98 then
            windower.send_command('input /ma "dia ii " '..pulledMob.id )
        end
    end
end

function target()
    local allMobs = windower.ffxi.get_mob_array()
    local closestNamedMobs = {}
    local nearest
        

    for i, v in pairs(allMobs) do

        if (v.name == mob1 or v.name == mob2 or v.name == mob3) and v.hpp > 98 and math.sqrt(v.distance) < 18 then
            if not nearest or v.distance < nearest.distance then 
                nearest = v
            end
        end
    end

    pulledMob = nearest
    if pulledMob and math.sqrt(pulledMob.distance) > 20 then
        target()
    end
    if pulledMob then
        windower.send_ipc_message('pulled '..tostring(pulledMob.id))
    end
    return nearest

end

function engage(id, index) 
    if on then
        local p = packets.new('outgoing', 0x01A, {
            ['Target'] = pulledMob.id,
            ['Target Index'] = pulledMob.index,
            ['Category'] = 2,
            ['Param'] = 0,
            ['_unknown1'] = 0,
            ['X Offset'] = 0,
            ['Y Offset'] = 0,
            ['Z Offset'] = 0,
        })
        packets.inject(p)
    end
end

function pullMob(mob_id, mob_index, param)
    local p = packets.new('outgoing', 0x01A, {
        ['Target'] = mob.id,
        ['Target Index'] = mob.index,
        ['Category'] = 3,
        ['Param'] = param,
        ['_unknown1'] = 0,
        ['X Offset'] = 0,
        ['Y Offset'] = 0,
        ['Z Offset'] = 0,
    })
    packets.inject(p)
end

local tagged = false

function face_target()
	local target = windower.ffxi.get_mob_by_target('t')
	local self_vector = windower.ffxi.get_mob_by_index(windower.ffxi.get_player().index or 0)
	if target then  -- Please note if you target yourself you will face Due East
		local angle = (math.atan2((target.y - self_vector.y), (target.x - self_vector.x))*180/math.pi)*-1
		windower.ffxi.turn((angle):radian())
	end
    -- if target and math.sqrt(target.distance) > 3 then
    --     windower.send_command('input /ra <t>' ..tostring(target.id))
    -- end

    if target and target.hpp > 95 then
        tagged = false
    end

    -- if target and target.hpp > 90 and player.name == "Chasmic" and tagged == false then
    --     windower.send_command('input /dia2')
    --     tagged = true
    -- end
end


