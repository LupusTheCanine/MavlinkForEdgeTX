
if Logger then
    return true
else
    Logger = {}
    local log = {}
    local lastMsg = ""
    local logEnd = 0
    local logMaxSize = 15
    local logCount = 0
    local severityMap = {
        [0] = {"EMR", RED},
        [1] = {"ALR", RED},
        [2] = {"CRT", RED},
        [3] = {"ERR", ORANGE},
        [4] = {"WRN", ORANGE},
        [5] = {"NTC", GREEN},
        [6] = {"INF", WHITE},
        [7] = {"DBG", WHITE},

    }
    function Logger.clearLog()
        log = {}
        lastMsg = ""
        logEnd = 0
        logMaxSize = 8
        logCount = 0
    end
    function Logger.pushMsg(msg,severity)
        severity = severity or 7
        if msg == lastMsg then 
            log[logEnd].severity = math.min(log[logEnd].severity,severity)
            log[logEnd].count = log [logEnd].count + 1
            log[logEnd].time = getTime()/100
        else
            logEnd = logEnd % logMaxSize + 1
            logCount = math.min(logCount+1,logMaxSize)
            log[logEnd] = {}
            log[logEnd].severity = severity
            log[logEnd].time = getTime()/100
            log[logEnd].message = msg
            log[logEnd].count = 1
            lastMsg = msg
        end

        
    end
    function Logger.drawLog(x,y,w,h)
        x = x + 2
        w = w - 4
        local currY = y
        local it = 1
        local time3digit = false
        lcd.drawFilledRectangle(x,y,w,h)
        while currY<y+h and it<= logCount do
            local textFlags = SMLSIZE+CUSTOM_COLOR
            local entry = log[(logEnd-it) % logMaxSize +1]
            it = it + 1
            if entry.time>=6000 then
                time3digit = true
            end
            lcd.setColor(CUSTOM_COLOR,severityMap[entry.severity][2])
            local tf
            if time3digit then 
                tf = "%03d:%02d "
            else
                tf = "%02d:%02d "
            end
            local ts = string.format(tf,entry.time/60,entry.time%60)
            local wt,ht = lcd.sizeText(ts,textFlags)
            lcd.drawTextLines(x,currY,wt,h-currY+y,ts,textFlags)
            local msgT
            if entry.count>1 then
                msgT =string.format("%s (%d) %s",severityMap[entry.severity][1], entry.count, entry.message)
            else
                msgT =string.format("%s %s",severityMap[entry.severity][1], entry.message)
            end
            lcd.drawTextLines(x+wt,currY,w-wt,h-currY+y,msgT,textFlags)
            local rows = lcd.sizeText(msgT,textFlags)/ (w-wt)
            if  rows>1 then
                rows = rows*1.05
            end
            currY = currY + ht*math.ceil(rows)
        end

    end
    
    return true
end