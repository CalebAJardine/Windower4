_addon.name = 'autoSkillchain'
_addon.author = 'Chasmic'
_addon.version = '1.0.0'
_addon.command = 'asc'
--_addon.commands = {}

require ('table')
require ('chat')
require ('luau')
require ('packets')

local player = windower.ffxi.get_player()

obligatory_wait_period = 3
last_skillchain_attempt = os.clock()
skillchain_timer = os.clock()
skillchain_expire = 11
ws_to_execute=1

rudras = '\"rudra\'s storm\"'
evis = "evisceration"
kasha = '"tachi: kasha"'
shoha = '"tachi: shoha"'
fudo = '"tachi: fudo"'
savage = '"Savage Blade"'
jinpu = '"tachi: jinpu"'
hotShot = '"Hot Shot"'
splitShot= '"Split Shot"'
sniperShot = '"Sniper Shot"'
detonator = '"Detonator"'
numbing = '"Numbing Shot"'
splitShot = '"Split Shot"'
cdc = '"Chant du Cygne"'
lastStand = '"Last Stand"'
leaden ='"Leaden Salute"'
groundStrike = '"Ground Strike"'
skillchain = {}
skillchain['windowOpen'] = false
skillchain['windowClosed'] = true
skillchain['canMB'] = false

plasReady = false
chasReady = false
ChasTp = 0
PlasTp = 0
step = 0
needToSendIpc = false
ws = tonumber(os.clock())
counter = 0
currentTime = 0
wsReady = true

player = windower.ffxi.get_player()

function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

windower.register_event('ipc message', function(message)
    args = split(message, ' ')
    if args[1] == "Chasmic" then
        log(chasReady)
        ChasTp = tonumber(args[2])
        if ChasTp > 1000 then 
            chasReady = true
        end
    end

    if args[1] == "ws" then 
        ws = tonumber(args[2])
        log(args[2])
    end

    if args[1] == "step" then
        step = tonumber(args[2])
    end

    if args[1] == "Plasmic" then
        PlasTp = tonumber(args[2])
        if PlasTp > 1000 then 
            plasReady = true
        end
    end

    if args[1] == "1" and player.name == "Plasmic" and ChasTp > 1000 then
        execute_ws(lastStand)
        step = 1
        sleep(2)
        windower.send_ipc_message("2")
    end
    if args[1] == "2" and player.name == "Chasmic" and PlasTp > 1000 then
        execute_ws(savage)
        sleep(2)
        windower.send_ipc_message("3")
    end
    if args[1] == "3" and player.name == "Plasmic" then
        execute_ws(lastStand)
        windower.send_ipc_message("1")
    end

end)

windower.register_event('prerender', function()
    mob = windower.ffxi.get_mob_by_target('t')
    if mob and mob.hpp < 1 then
        send_ipc("step "..step)
    end

    if mob and mob.hpp > 98 then
        step = 0
        send_ipc("step "..step)
    end

    counter = counter +1
    if counter > 58 then
        counter = 0
        log(step)
        currentTime = tonumber(os.time())
        wsReady = currentTime - ws > 3
        if wsReady then
            log("wsReady")
        else
            log("wsNotReady")
        end
    end

    if mob and plasReady and player.name == "Plasmic" and (step == 0) and wsReady then
        if counter == 30 then
            if step == 0 then 
                execute_ws(lastStand)
                step = 1
                send_ipc("step "..step) 
            end
            
        end
    end
    
    if mob and chasReady and player.name == "Chasmic" and step == 1 and wsReady then 
        if counter == 1 then
            if step == 1 then 
                execute_ws(savage)
                step = 0 
                send_ipc("step "..step)
            end
            
        end
    end


end)

windower.register_event('tp change', function(new, old)
    log("new: "..new)
    log("old: "..old)
    if player.name == "Chasmic" then 
        if tonumber(new) > 1000 then 
            chasReady = true
        else
            chasReady = false
        end
        windower.send_ipc_message("Chasmic "..new)
    end
    if player.name == "Plasmic" then 
        if tonumber(new) > 1000 then 
            plasReady = true
        else
            plasReady = false
        end
        windower.send_ipc_message("Plasmic "..new)
    end
end)


function send_ipc(command) 
    windower.send_ipc_message(command)
end

function execute_ws(command)
    windower.send_command('input /'..command)
    lastWs = os.time()
    send_ipc("ws ".. os.time())

end

local clock = os.clock
function sleep(n)
    local t0 = clock()
    while clock() - t0 <= n do end
end

