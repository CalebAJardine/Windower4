_addon.version = '1.0'
_addon.name = 'Boxer'
_addon.command = 'box'
_addon.author = 'Chasmic'

require('tables')
require('luau')
require('logger')
packets = require('packets')
require('coroutine')

local player_driving = 'Chasmic'

local player = windower.ffxi.get_player()
local mob = false
local Horde_Lullaby_II = 377
local Magic_Finale = 462
local Carnage_Elegy = 422
local Dispel = 260
local Dia_II = 24
local Dia_III = 25
local sleepga = 273
local frazzle_II = 844
local distract_III = 882
local frazzle_III = 883
local blind_II = 276
local slow_II = 79
local stone = 159
local water = 169
local absorbTp = 275
local noctrune = 472
local silence = 59
local flash = 112
local jettatura = 575
local geist_wall = 605
local footkick = 577
local sfollow = false
local qfollow = false
local tfollow = false
local pfollow = false
local zfollow = false

windower.register_event('addon command',function (command, ...)
    if player.name == player_driving then
        windower.send_ipc_message(command)
    end
    
    if player.name == "Chasmic" then
        coroutine.sleep(2)
        if command == "rads" then
            windower.send_command('input //temps buy radialens')
        elseif command == 'temps' then
            windower.send_command('input //temps buy')
        elseif command == 'warp' then
            windower.send_command('input //lua u gearswap; wait 1; input /equip ring2 "warp ring"; wait 12; input /item "warp ring" <me>; wait 1; input //lua l gearswap')
        elseif command == 'reis' then
            windower.send_command('input //lua u gearswap; wait 1; input /equip ring2 "Dim. Ring (holla)"; wait 12; input /item "Dimensional Ring (holla)" <me>; wait 1; input //lua l gearswap')
        elseif command == 'i' then
            interact()
        elseif command == "absorbTp" then
            windower.send_command('input /ma absorb-tp '..mob.id)
        elseif command == 'htmb' then
            coroutine.sleep(.5)
            windower.send_command('input //htmb')
        elseif command == "ws" then
            windower.send_command('input //send @all //gs c toggle autowsmode')
        end
    end
end)

function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

windower.register_event('ipc message', function(message)
    args = split(message, ' ')
    log("message: " .. message)

    if args[1] == 'target' then
        mob = windower.ffxi.get_mob_by_id(args[2])
    end

    --TYNIASEN HOOKS
    if player.name == "Tyniasen" then
        if args[1] == "lullaby" then 
            windower.send_command('input /ma "horde lullaby II" '.. mob.id)
        elseif args[1] == "sleepga" then
            cast_debuff(mob.id, mob.index, sleepga)
        elseif args[1] == "frazzle3" then
            cast_debuff(mob.id, mob.index, frazzle_III)
        elseif args[1] == "waterBurst" then
            water_burst()
        elseif args[1] == 'tlock' then
            windower.send_command('input /lockon')
        elseif args[1] == "blind2" then
            cast_debuff(mob.id, mob.index, blind_II)
        elseif args[1] == "distract3" then
            cast_debuff(mob.id, mob.index, distract_III)
        elseif args[1] == "slow2" then
            cast_debuff(mob.id, mob.index, slow_II)
        elseif args[1] == "finale" then
            windower.send_command('input /ma "Magic Finale" '.. mob.id)
        elseif args[1] == "sing" then
            windower.send_command('input //sing')
        elseif args[1] == "elegy" then
            windower.send_command('input /ma "Carnage Elegy" '.. mob.id)
        elseif args[1] == "wind" then
            windower.send_command('input /ma "Wind Threnody II" '.. mob.id)
        elseif args[1] == "savage" then
            windower.send_command('input /Savage Blade')
        elseif args[1] == "dispel" then
            windower.send_command('input /ma dispel ' .. mob.id)
        elseif args[1] == "dia" then
            cast_debuff(mob.id, mob.index, Dia_II)
        elseif args[1] == "dia3" then
            cast_debuff(mob.id, mob.index, Dia_III)
        elseif args[1] == "slow" then
            cast_debuff(mob.id, mob.index, Carnage_Elegy)
        elseif args[1] == "absorbTp" then
            windower.send_command('input /ma absorb-tp '..mob.id)
        elseif args[1] == 'speed' then
            windower.send_command('input /ma "Chocobo Mazurka" <me>')
        elseif args[1] == 'nocturne' then
            cast_debuff(mob.id, mob.index, noctrune)
        elseif args[1] == 'silence' then
            cast_debuff(mob.id, mob.index, silence)
        elseif args[1] == 'buff' then
            windower.send_command('input //lua r singer')
        elseif args[1] == 'engage' or args[1] == 'tengage' then
            engage()
        elseif args[1] == 'rads' then
            windower.send_command('input //temps buy radialens')
        elseif args[1] == 'temps' then
            windower.send_command('input //temps buy')
        elseif args[1] == 'i' then
            interact()
        elseif args[1] == "dia" then
            cast_debuff(mob.id, mob.index, Dia_II)
        elseif args[1] == 'warp' then
            windower.send_command('input //lua u gearswap; wait 1; input /equip ring2 "warp ring"; wait 12; input /item "warp ring" <me>; input //lua l gearswap')
        elseif args[1] == 'reis' then
            windower.send_command('input //lua u gearswap; wait 1; input /equip ring2 "Dim. Ring (holla)"; wait 12; input /item "Dimensional Ring (holla)" <me>; wait 1; input //lua l gearswap')
        elseif args[1] == 'htmb' then
            coroutine.sleep(.5)
            windower.send_command('input //htmb')
        elseif args[1] == 'follow' then
                windower.send_command('input //hb f Chasmic')
        elseif args[1] == 'unfollow' then
                windower.send_command('input //hb f off')
        end
    end
    --PLASMIC HOOKS
    if player.name == "Plasmic" then
        if args[1] == "engage"  or args[1] == 'pengage' then
            engage()
        elseif args[1] == "savage" then
            windower.send_command('input /Savage Blade')
        end
        coroutine.sleep(.5)
        if args[1] == 'buff' then
            -- windower.send_command('input //roll on; wait 1; input //hb on; wait 1; input //hb disable cure')
        elseif args[1] == 'i' then
            interact()
        elseif args[1] == 'plock' then
            windower.send_command('input /lockon')
        elseif args[1] == "absorbTp" then
            windower.send_command('input /ma absorb-tp '..mob.id)
        elseif args[1] == 'speed' then
            windower.send_command('input /ja "bolter\'s roll" <me>')
        elseif args[1] == 'rads' then
            windower.send_command('input //temps buy radialens')
        elseif args[1] == 'ra' then
            windower.send_command('input /ra <t>')
        elseif args[1] == 'melee' then
            windower.send_command('input //roll roll1 Chaos; wait 1; input //roll roll2 sam; wait 1; input //roll on;')
        elseif args[1] == 'cp' then
            windower.send_command('input //roll roll1 Chaos; wait 1; input //roll roll2 sam; wait 1; input //roll on;')
        elseif args[1] == 'magic' then
            windower.send_command('input //roll roll1 blm; wait 1; input //roll roll2 rdm; wait 1; input //roll on;')
        elseif args[1] == 'mixed' then
            windower.send_command('input //roll roll1 blm; wait 1; input //roll roll2 sam; wait 1; input //roll on;')
        elseif args[1] == 'temps' then
            windower.send_command('input //temps buy')
        elseif args[1] == 'warp' then
            windower.send_command('input //lua u gearswap; wait 1; input /equip ring2 "warp ring"; wait 12; input /item "warp ring" <me>; input //lua l gearswap')
        elseif args[1] == 'reis' then
            windower.send_command('input //lua u gearswap; wait 1; input /equip ring2 "Dim. Ring (holla)"; wait 12; input /item "Dimensional Ring (holla)" <me>; wait 1; input //lua l gearswap')
        elseif args[1] == 'ws' then
            windower.send_command('input /ws "Numbing Shot" <t>')
        elseif args[1] == 'htmb' then
            coroutine.sleep(.5)
            windower.send_command('input //htmb')
        elseif args[1] == 'follow' then
            windower.send_command('input //hb f Chasmic')
        elseif args[1] == 'unfollow' then
            windower.send_command('input //hb f off')
        end
    end
    --SPASMIC HOOKS
    if player.name == "Spasmic" then
        if args[1] == "sleepga" then
            windower.send_command('input /ma "Sleepga" '.. mob.id)
        end
        coroutine.sleep(1)
        if args[1] == 'sengage' then
            engage()
        elseif args[1] == 'i' then
            interact()
        elseif args[1] == "absorbTp" then
            windower.send_command('input /ma absorb-tp '..mob.id)
        elseif args[1] == 'silence' then
            cast_debuff(mob.id, mob.index, silence)
        elseif args[1] == 'rads' then
            windower.send_command('input //temps buy radialens')
        elseif args[1] == 'temps' then
            windower.send_command('input //temps buy')
        -- elseif args[1] == 'buff' then
        --     windower.send_command('input //gb indi fury; wait 1; input //gb geo frailty; wait 1; input //gb on; wait 1; input //hb on; wait 1; input //hb disable cure')
        elseif args[1] == 'warp' then
            windower.send_command('input //lua u gearswap; wait 1; input /equip ring2 "warp ring"; wait 12; input /item "warp ring" <me>; input //lua l gearswap')
        elseif args[1] == 'reis' then
            windower.send_command('input //lua u gearswap; wait 1; input /equip ring2 "Dim. Ring (holla)"; wait 12; input /item "Dimensional Ring (holla)" <me>; wait 1; input //lua l gearswap')
        elseif args[1] == 'bigBubble' then
            windower.send_command('input /ja "blaze of glory" <me>; wait 1; input /ja "full circle" <me>; wait 6; input /ja "Ecliptic Attrition" <me>; wait 1; input /ja "Life Cycle" <me>')
        elseif args[1] == 'fc' then
            windower.send_command('input /ja "full circle" <me>')
        elseif args[1] == 'melee' then
            windower.send_command('input //gb indi fury; wait 1; input //gb geo frailty; wait 1; input //gb on; wait 1; input /indifury')
        elseif args[1] == 'magic' or args[1] == 'mixed' then
            windower.send_command('input //gb indi acumen; wait 1; input //gb geo malaise; wait 1; input //gb on; input /indiacumen')
        elseif args[1] == 'cp' then
            windower.send_command('input //gb indi frailty; wait 1; input //gb geo fury; wait 1; input //gb on; input /indifrailty')
        elseif args[1] == 'dem' then
            windower.send_command('input /ja dematerialize <me>')
        elseif args[1] == "dia" then
            cast_debuff(mob.id, mob.index, Dia_II)
        elseif args[1] == 'htmb' then
            coroutine.sleep(.5)
            windower.send_command('input //htmb')
        elseif args[1] == 'follow' then
            windower.send_command('input //hb f Chasmic')
        elseif args[1] == 'unfollow' then
            windower.send_command('input //hb f off')
        end
    end
    --QUASMIC HOOKS
    if player.name == "Quasmic" then
        coroutine.sleep(1.5)
        if args[1] == "str" then
            windower.send_command('input /ma boost-str <me>')
        -- elseif args[1] == 'buff' then
        --     windower.send_command('input //hb off; wait 1; input //hb buff Chasmic Haste; wait 1; input //hb buff Spaitin Haste; wait 1; input //hb buff Quasmic Aurorastorm; wait 1; input /ja "Light Arts" <me>; wait 1.2; input /ja "Addendum: White" <me>; wait 1.2; input /ja sublimation <me>; wait 1.2;  input /ma "reraise iv" <me>; wait 8; input /ma "protectra V" <me>; wait 8; input /ma "Shellra V" <me>; wait 8; input /ma "auspice" <me>; wait 8; input /ma "boost-str" <me>; wait 8; input /ja "afflatus solace" <me>; wait 2; input //hb on')
        elseif args[1] == 'i' then
            interact()
        elseif args[1] == "absorbTp" then
            windower.send_command('input /ma absorb-tp '..mob.id)
        elseif args[1] == 'rads' then
            windower.send_command('input //temps buy radialens')
        elseif args[1] == 'temps' then
            windower.send_command('input //temps buy')
        elseif args[1] == 'warp' then
            windower.send_command('input //lua u gearswap; wait 1; input /equip ring2 "warp ring"; wait 12; input /item "warp ring" <me>; input //lua l gearswap')
        elseif args[1] == 'reis' then
            windower.send_command('input //lua u gearswap; wait 1; input /equip ring2 "Dim. Ring (holla)"; wait 12; input /item "Dimensional Ring (holla)" <me>; wait 1; input //lua l gearswap')
        elseif args[1] == 'htmb' then
            coroutine.sleep(.5)
            windower.send_command('input //htmb')
        elseif args[1] == 'engage' then
        elseif args[1] == 'follow' then
            windower.send_command('input //hb f Chasmic')
        elseif args[1] == 'unfollow' then
            windower.send_command('input //hb f off')
        end
    end
    --CHASMIC HOOKS
    if args[1] == "teek" then
        windower.send_command('input //tradenpc 1 "Teekesselchen Fragment" 1 "Darkflame Arm"')
    end
    if player.name == "Chasmic" then
        coroutine.sleep(2)
        if args[1] == "rads" then
            windower.send_command('input //temps buy radialens')
        elseif args[1] == 'temps' then
            windower.send_command('input //temps buy')
        elseif args[1] == 'warp' then
            windower.send_command('input //lua u gearswap; wait 1; input /equip ring2 "warp ring"; wait 12; input /item "warp ring" <me>; wait 1; input //lua l gearswap')
        elseif args[1] == 'reis' then
            windower.send_command('input //lua u gearswap; wait 1; input /equip ring2 "Dim. Ring (holla)"; wait 12; input /item "Dimensional Ring (holla)" <me>; wait 1; input //lua l gearswap')
        elseif args[1] == 'i' then
            interact()
        elseif args[1] == "absorbTp" then
            windower.send_command('input /ma absorb-tp '..mob.id)
        elseif args[1] == 'htmb' then
            coroutine.sleep(.5)
            windower.send_command('input //htmb')
        end
    end

    --ZHASMIC HOOKS
    if player.name == "Zhasmic" then
        coroutine.sleep(2.5)
        if args[1] == "rads" then
            windower.send_command('input //temps buy radialens')
        elseif args[1] == 'temps' then
            windower.send_command('input //temps buy')
        elseif args[1] == 'flash' then
            cast_debuff(mob.id, mob.index, flash)
        elseif args[1] == 'foil' then
            windower.send_command('input /ma foil <me>')
        elseif args[1] == 'jet' then
            cast_debuff(mob.id, mob.index, jettatura)
        elseif args[1] == 'geist' then
            cast_debuff(mob.id, mob.index, geist_wall)
        elseif args[1] == 'warp' then
            windower.send_command('input //lua u gearswap; wait 1; input /equip ring2 "warp ring"; wait 12; input /item "warp ring" <me>; wait 1; input //lua l gearswap')
        elseif args[1] == 'reis' then
            windower.send_command('input //lua u gearswap; wait 1; input /equip ring2 "Dim. Ring (holla)"; wait 12; input /item "Dimensional Ring (holla)" <me>; wait 1; input //lua l gearswap')
        elseif args[1] == 'i' then
            interact()
        elseif args[1] == "absorbTp" then
            windower.send_command('input /ma absorb-tp '..mob.id)
        elseif args[1] == 'htmb' then
            coroutine.sleep(.5)
            windower.send_command('input //htmb')
        elseif args[1] == 'unfollow' then
            windower.send_command('input //hb f off')
        end 
    end

end)

windower.register_event('target change', function(...)
    if windower.ffxi.get_mob_by_target('t') ~= nil then 
        if windower.ffxi.get_player().name ==  player_driving then
            mob = windower.ffxi.get_mob_by_target('t')
            windower.send_ipc_message("target " .. mob.id)
        end
    end
end)

function interact()
    local p = packets.new('outgoing', 0x01A, {
        ['Target'] = mob.id,
        ['Target Index'] = mob.index,
    })
    packets.inject(p)
end

function water_burst()
    windower.send_command('input /ja immanence <me>')
    coroutine.sleep(1)
    cast_debuff(mob.id, mob.index, stone)
    coroutine.sleep(4)
    windower.send_command('input /ja immanence <me>')
    coroutine.sleep(1)
    cast_debuff(mob.id, mob.index, water)
end

function cast_debuff(mob_id, mob_index, param)
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

function engage()
    if mob then
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
    windower.ffxi.run()
end