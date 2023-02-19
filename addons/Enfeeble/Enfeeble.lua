_addon.name = 'Enfeeble'
_addon.author = 'Chasmic'
_addon.command = 'en'
_addon.version = '1.0'

require('luau')
require('lor/lor_utils')
require('coroutine')
_libs.lor.req('all', {n='strings',v='2016.10.16'})
_libs.lor.debug = false
local get_action_info = _libs.lor.packets.get_action_info

local me = windower.ffxi.get_player()
local player_to_assist = nil
local last_spell_cast_value = nil

local start_targ = nil
local last_dia_cast = nil
local dia_duration = 180
local landed = 236
local resisted = 85
local worn = 204
local already_active = 75
local finished_casting = 2

local sleep = 2
local silence = 6
local paralyze = 4
local slow = 13
local blind = 5

local active_enfeebles = {
    [25] = {active = false},
    [2] = {active = false},
    [4] = {active = false},
    [5] = {active = false},
    [6] = {active = false},
    [13] = {active = false}
}

local spell_table = {
    [25] = '"Dia III"',
    [2] = '"Sleep"',
    [4] = '"Paralyze II"',
    [5] = '"Blind II"',
    [6] = '"Silence"',
    [13] = '"Slow II"'
}

function enfeebles_to_cast() 
    for i,spell in pairs(active_enfeebles) do
        if spell.active == false then
            return true
        end
    end
    return false
end

function reset_spells()
    log("reset_spells() called")
    for i,spell in pairs(active_enfeebles) do
        spell.active = false
    end
end

function start()
    start_targ = windower.ffxi.get_mob_by_target('bt') or nil
    while enfeebles_to_cast() and start_targ ~= nil do
        get_next_spell_to_cast()
    end
end

-- windower.register_event('prerender', function()
--     start()
-- end)

windower.register_event('target change', function(target)
    local targ = windower.ffxi.get_mob_by_target('t') or me
    if targ.is_npc then
        start()
    end
end)

function get_player_to_assist(player_name)
    local party = windower.ffxi.get_party()
	for _,pmember in pairs(party) do
		if (type(pmember) == 'table') and (pmember.name == player_name) then
          player_to_assist = pmember
          log('assisting '..pmember.name)
		end
    end
end

function last_spell_cast(spell_id)
    last_spell_cast_value = spell_id
end

function get_next_spell_to_cast()
    if player_to_assist then
        -- if active_enfeebles[25].active == false then
        --     cast_spell(25)
        --     last_dia_cast = os.clock()
        --     coroutine.sleep(8)
        if active_enfeebles[6].active == false then
            cast_spell(6)
            last_spell_cast(6)
            coroutine.sleep(8)
        elseif active_enfeebles[4].active == false then
            cast_spell(4)
            last_spell_cast(4)
            coroutine.sleep(8)
        elseif active_enfeebles[13].active == false then
            cast_spell(13)
            last_spell_cast(13)
            coroutine.sleep(8)
        elseif active_enfeebles[5].active == false then
            cast_spell(5)
            last_spell_cast(5)
            coroutine.sleep(8)
        else
            coroutine.sleep(8)
        end
    else
        coroutine.sleep(8)
    end
end

function cast_spell(index_of_spell_to_cast)
    windower.send_command('input /ma '..spell_table[index_of_spell_to_cast]..' <bt>')
end

windower.register_event('logout', function()
	windower.send_command('lua unload '.._addon.name)
end)


windower.register_event('addon command', function(...)
	local args = T{...}
    local cmd = args[1]
	if cmd then 
        if cmd:lower() == 'start' then
			start()
        end
        if cmd:lower() == 'as' then
            get_player_to_assist(args[2])
        end
    end
end)

windower.register_event('incoming chunk', function(id, data)
    if (id == 0x28) then
        windower.send_command('input /ta <bt>')
        
        ai = get_action_info(id, data)
        for _,targ in pairs(ai.targets) do
            for _,tact in pairs(targ.actions) do
                -- log('message id: '..tostring(tact.message_id)..' param id: '..(tact.param))
                if tact.message_id == finished_casting and tact.param == 25 then
                    -- log('got here')
                    --25 for dia because it has a different interaction
                    spell_that_landed = 25
                    active_enfeebles[spell_that_landed].active = true
                elseif tact.message_id  == landed then
                    --236 = landed
                    spell_that_landed = tact.param
                    active_enfeebles[spell_that_landed].active = true
                elseif tact.message_id == already_active and last_spell_cast_value ~= nil then
                    active_enfeebles[last_spell_cast_value].active = true
                elseif tact.message_id == resisted then
                    --85 = resisted
                end
            end
        end
    end
    if (id == 0x29) then
        windower.send_command('input /ta <bt>')
        local mob = windower.ffxi.get_mob_by_target('bt')
        local am = get_action_info(id, data)
        if (am.message_id == worn or am.message_id == 206) then
            --204 = worn
            if(am.param_1 == 134) then
                spell_that_wore = 25
                active_enfeebles[spell_that_wore].active = false
            elseif(am.param_1 == 2 or am.param_1 == 4 or am.param_1 == 5 or am.param_1 == 6 or am.param_1 == 13) then
                spell_that_wore = am.param_1
                active_enfeebles[spell_that_wore].active = false
            end
            start()
        elseif (am.message_id == 6 or am.message_id == 20) and mob.id == am.target_id then
            start_targ = nil
            reset_spells()
        end
    end
end)