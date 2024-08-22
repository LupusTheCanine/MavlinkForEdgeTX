local logFile
local function init()
    logFile = io.open(string.format("/LOGS/Mavlink/log.mavlink"),"w+b")
end

local function update(event,touch_state)
    for i = 1,10 do
        local command, packet = crossfireTelemetryPop()
        if command == 0xff and packet then -- 0xff is MAVLINK Tunnel
            logFile:write(packet)
        end
        if event == EVT_EXIT_BREAK then 
           io.close(logFile)
            return 1
        else 
            return 0
        end
    end
end
return {init=init,run=update}