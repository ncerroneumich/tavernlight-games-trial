local DASH_TEXT = "dash"
local DASH_LENGTH_MS = 300

local dash_event = nil

function init()
    connect(g_game, {
        onTalk = onTalk
    })
end

function terminate()
    disconnect(g_game, {
        onTalk = onTalk
    })
end

function onTalk(name, level, mode, text, channelId, pos)
    print("onTalk: " .. text)
    if text == DASH_TEXT then
        local player = g_game.getLocalPlayer()
        if player ~= nil then
            -- print("dashing")
            player:setDashing(true)
            dash_event = scheduleEvent(stopDash, DASH_LENGTH_MS)
        end
    end
end

function stopDash() 
    local player = g_game.getLocalPlayer()
    if player ~= nil then
        print("in stopDash()")
        player:setDashing(false)  
        removeEvent(dash_event)
        dash_event = nil  
    end
end