_addon.version = '1.0'
_addon.name = 'Attack'
_addon.command = 'at'
_addon.author = 'Chasmic'

require('tables')
require('coroutine')
require('luau')
packets = require('packets')

local mob
local player = windower.ffxi.get_player()

windower.register_event('addon command', function (command, ...) 
    if (command) then
        attack(command)
    end
end)

local u = 0 -- don't delete

local function random(x, y)
    u = u + 1
    if x ~= nil and y ~= nil then
        return math.floor(x +(math.random(math.randomseed(os.time()+u))*999999 %y))
    else
        return math.floor((math.random(math.randomseed(os.time()+u))*100))
    end
end

function attack(name) 
    local allMobs = windower.ffxi.get_mob_array()
    local mobsWithName = {}
    for i, v in pairs(allMobs) do
        mobsWithNameIndex = 1
        if string.find(v.name, name) and math.sqrt(v.distance) < 10 and v.hpp > 90 then
            mobsWithName[mobsWithNameIndex] = v
            mobsWithNameIndex = mobsWithNameIndex + 1
        end
    end


    local length = 0
    for i, v in pairs(mobsWithName) do length = length + 1 end
    local randomNum = random(1, length)
    for i, v in pairs(mobsWithName) do 
        log(v.name .. " " .. math.sqrt(v.distance))
    end
    log("randomNum: ".. randomNum)
    log("length: " .. length)

    mob = mobsWithName[randomNum]
    engage()
end

function engage() 
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