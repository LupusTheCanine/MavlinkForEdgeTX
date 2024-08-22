local logFile
local err
local packetCount = 0
local function init()
    logFile ,err= io.open("/LOGS/Mavlink/log.mavlink","w+b")
    if err then popupWarning(err,1)end
end

local function update(event,touch_state)
    if err then 
        popupWarning(err,event)
        return 0
    end
    for i = 1,50 do
        local command, packet = crossfireTelemetryPop()
        if command == 0xff and packet then -- 0xff is MAVLINK Tunnel
            io.write(logFile,string.char(table.unpack(packet)))
            packetCount = packetCount +1
        end
    end
    lcd.clear(BLACK)
    lcd.drawText(50,50,string.format("Recorded %d packets", packetCount),DBLSIZE+TEXT_COLOR)
    if event == EVT_EXIT_BREAK then 
        io.close(logFile)
        return 1
    else 
        return 0
    end
end
return {init=init,run=update}