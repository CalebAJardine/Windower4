_addon.name = 'TankBot'
_addon.author = 'Chasmic'
_addon.command = 'tb'
_addon.version = '1.0.0'
_addon.lastUpdate = '2020-1-20'

_libs = _libs or {}
_libs.luau = _libs.luau or require('luau')
_libs.queues = _libs.queues or require('queues')

res = require('resources')
config = require('config')
texts = require('texts')
packets = require('packets')
files = require('files')

require 'Tankbot_queues'
require 'Tankbot_utils'
local Pos = require('position')
Assert = require 'TB_Assertion'
actionStartTime = 0
actionEndTime = 0
zone_enter = 0 

windower.register_event('load', function()
    atcc(262, 'Welcome to Tankbot hopefully this works!')
    local lastAction = os.clock()
    local lastMoveCheck = os.clock()
    actionStartTime= os.clock()
    actionEndTime= actionStartTime + 0.1

    zone_enter = os.clock()-25

    local player = windower.ffxi.get_player()
    myName = player and player.name or 'Player'
    active = false
    lastActingState = false
end)

windower.register_event('logout', function()
    windower.send_command('lua unload healbot')
end)

windower.register_event('zone change', function(new_id, old_id)
	zone_enter = os.clock()
end)

windower.register_event('job change', function()
    active = false
end)

windower.register_event ('addon command', processCommand)


-- TODO implement
function get_assist_target()

end

windower.register_event('prerender', function()
    local now = os.clock()
    local moving = isMoving()
    local acting = isPerformingAction(moving)
    local player = windower.ffxi.get_player()
    
    atcc(265, actionStartTime)



    local busy = moving or acting

    
    if(player ~= nil) and S{0,1}:contains(player.status) then
        
    end
end)

function isMoving()
	if (getPosition() == nil) then
		txts.moveInfo:hide()
		return true
	end
	lastPos = lastPos and lastPos or getPosition()
	posArrival = posArrival and posArrival or os.clock()
	local currentPos = getPosition()
	local now = os.clock()
	local moving = true
	local timeAtPos = math.floor((now - posArrival)*10)/10
	if (lastPos:equals(currentPos)) then
        moving = (timeAtPos < 0.5)
	else
		lastPos = currentPos
        posArrival = now
	end
	if math.floor(timeAtPos) == timeAtPos then
		timeAtPos = timeAtPos..'.0'
    end
	return moving
end

function isPerformingAction(moving)
	if (os.clock() - actionStartTime) > 8 then
		--Precaution in case an action completion isn't registered for a long time
		actionEndTime = os.clock()
	end
	
    local acting = (actionEndTime < actionStartTime)
	local status = acting and 'performing an action' or (moving and 'moving' or 'idle')
	status = ' is '..status
	
    if (lastActingState ~= acting) then	--If the current acting state is different from the last one
        atcc(262, "got here")
		if lastActingState then			--If an action was being performed
			settings.actionDelay = 2.75			--Set a longer delay
            lastAction = os.clock()			--The delay will be from this time
		end
		lastActingState = acting		--Refresh the last acting state
	end
	
	if (os.clock() - zone_enter) < 25 then
		acting = true
		status = ' zoned recently'
		zone_wait = true
	elseif zone_wait then
		zone_wait = false
		resetBuffTimers('ALL', S{'Protect V','Shell V'})
	elseif Assert.buff_active('Sleep','Petrification','Charm','Terror','Lullaby','Stun','Silence','Mute') then
		acting = true
		status = ' is disabled'
	end
	
	local player = windower.ffxi.get_player()
	if (player ~= nil) then
		local mpp = player.vitals.mpp
		if (mpp <= 10) then
			status = status..' | \\cs(255,0,0)LOW MP\\cr'
		end
    end
    if not moving then
        acting = false
    end
	return acting
end

function getPosition(targ)
	local mob = getTarget(targ and targ or 'me')
	if (mob ~= nil) then
		return Pos.new(mob.x, mob.y, mob.z)
	end
	return nil
end

function getTarget(targ)
	local target = nil
	if targ and tonumber(targ) and (tonumber(targ) > 255) then
		target = windower.ffxi.get_mob_by_id(tonumber(targ))
	elseif targ and S{'<me>','me'}:contains(targ) then
		target = windower.ffxi.get_mob_by_target('me')
	elseif targ and (targ == '<t>') then
		target = windower.ffxi.get_mob_by_target()
	elseif targ and (type(targ) == 'string') then
		target = windower.ffxi.get_mob_by_name(targ)
	elseif targ and (type(targ) == 'table') then
		target = targ
	end
	return target
end