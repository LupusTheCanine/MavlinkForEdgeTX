if Mavlink then
    return true
else
    local fnc, err = loadScript("/SCRIPTS/LIBS/LibPack.lua")  --load LibPack (provides string.pack and unpack equivalents using array instead of string)
    if fnc then
        fnc()
    elseif err then
        popupWarning(err,30)
    else
        popupWarning("something went horribly wrong",30)
    end
    local fnc, err = loadScript("/SCRIPTS/LIBS/utils.lua")  --load LibPack (provides string.pack and unpack equivalents using array instead of string)
    if fnc then
        fnc()
    elseif err then
        popupWarning(err,30)
    else
        popupWarning("something went horribly wrong",30)
    end
    local msgDir = "/SCRIPTS/LIBS/Mavlink/MsgDef"
    local timeStep = 1 --run every 50ms
    local formatList = {}
    local nameMap = {}
    local lastRunTime = 0
    local bytesToSkip = 0
    local rcvMsg = {}
    local parseState = 1
    local parseCount = 0
    local tgtSysId = 1
    local skipFrame = false
    
    Mavlink =  {}
    Mavlink.vehicle = {}
    Mavlink.vehicle.dropCount = 0
    Mavlink.vehicle.packetCount = 0
    Mavlink.vehicle.lastSeen = 0
    Mavlink.vehicle.Messages = {}

    if dir(msgDir) then               --load message definitions
        for file in dir(msgDir) do
            local _,_,fname,msgName=string.find(file,"(mavlink_msg_([%u_]+))%.lua")
            if msgName then
                local f,error=loadScript(msgDir.."/"..fname)
                if f then
                    local msg=f()
                        formatList[msg.id]={fields={}}
                    for k,v in ipairs(msg.fields) do
                        formatList[msg.id].fields[k]=v
                    end
                    formatList[msg.id].name=msgName
                    formatList[msg.id].crcExtra=msg.crcExtra
                    nameMap[msgName]=msg.id
                end
            end
        end
    else
        popupWarning("No mavlink MSG directory",30)
    end
    local function checksumHandler() -- returns checksum handler object
        local checksum=0xffff
        local function update(byte)
            local tmp=bit32.bxor(byte,checksum%256)
            tmp=bit32.bxor(tmp,tmp*16)%256
            checksum=bit32.bxor(bit32.rshift(checksum,8),tmp*256,tmp*8,bit32.rshift(tmp,4))
        end    
        local function reset()
            checksum=0xffff
        end
        local function getChecksum()
            return checksum
        end
        return {update=update, reset=reset, get=getChecksum}
    end
    local sendChk = checksumHandler()
    local recvChk = checksumHandler()
    
    local ModeNameTable = loadScript("/SCRIPTS/LIBS/Mavlink/ModeNames")()
    local parseStates = loadScript("/SCRIPTS/LIBS/Mavlink/ModeNames")()
    local function decode_msg(msg)
        local format=formatList[msg.msgId]
        local result={}
        local offset = 1
        if format then
            for _,v in ipairs(format.fields) do
                if v[3] then
                    result[v[1]] = {}
                    for j=1,v[3] do
                        result[v[1]][j], offset = LibPack.unpack(v[2], msg.payload, offset)
                    end
                else
                    result[v[1]], offset = LibPack.unpack(v[2], msg.payload, offset)
                end
            end
        end
        return result
    end

    local function modeName(hb)
        if not ModeNameTable[hb.autopilot] then return "Unknown AP" end
        if not ModeNameTable[hb.autopilot][hb.type] then return "Unknown Type" end
        return ModeNameTable[hb.autopilot][hb.type][hb.custom_mode] or "Unknown Mode"
    end
    local function emptyFunc(...) end
    local msgProcessors = {}
    local function processRcvMsg()
        if rcvMsg.sysId == tgtSysId then
            Mavlink.vehicle.lastSeen = getTime()
            if rcvMsg.compId == 1 then --use all components to detect vehicle but only process frames from autopilot.
                local lastSeq = Mavlink.vehicle.lastSeq or rcvMsg.seq - 1
                Mavlink.vehicle.dropCount = Mavlink.vehicle.dropCount + (rcvMsg.seq - lastSeq - 1)%256
                Mavlink.vehicle.packetCount = Mavlink.vehicle.packetCount + (rcvMsg.seq - lastSeq)%256
                Mavlink.vehicle.lastSeq = rcvMsg.seq

                if rcvMsg.msgId == 0 then -- HERTBEAT
                    local result = decode_msg(rcvMsg)
                    Mavlink.vehicle.HEARTBEAT = result
                    Mavlink.vehicle.HEARTBEAT.ModeName = modeName(result)
                    Mavlink.vehicle.HEARTBEAT.isArmed = result.base_mode>=128
                elseif rcvMsg.msgId == 74 then -- VFR_HUD
                    Mavlink.vehicle.HUD = decode_msg(rcvMsg)
                    Mavlink.vehicle.HUD.lastUpdate = getTime()
                elseif rcvMsg.msgId == 30 then -- ATTITUDE
                    Mavlink.vehicle.ATT = decode_msg(rcvMsg)
                    Mavlink.vehicle.ATT.lastUpdate = getTime()
                elseif rcvMsg.msgId == 33 then
                    Mavlink.vehicle.POS = decode_msg(rcvMsg)
                    Mavlink.vehicle.POS.lastUpdate = getTime()
                elseif rcvMsg.msgId == 253 then --STATUSTEXT
                    --TODO: add message reassembly logic
                    local result=decode_msg(rcvMsg)
                    Logger.pushMsg(result.text,result.severity)
                else (msgProcessors[rcvMsg.msgId] or emptyFunc) (rcvMsg)
                end
        
            end
        end
    end -- processRcvMsg
    function Mavlink.update()
        local now = getTime()
        if now - lastRunTime < timeStep then
            return
        end
        lastRunTime = now
        for i = 1,10 do
            local command, packet = crossfireTelemetryPop()
            if command == 0xff and packet then -- 0xff is MAVLINK Tunnel
                local len = packet[1]
                for it = 2,math.min(len+1,#packet) do
                    local byte = packet[it]
                    if parseState == 1 then -- waiting for STX
                        if byte == 0xFD then 
                            parseState = 2
                            rcvMsg={}
                            recvChk.reset()
                            rcvMsg.checksum = 0
                        end
                    elseif parseState == 2 then -- get len
                        rcvMsg.len = byte
                        parseState = 3
                    elseif parseState == 3 then
                        rcvMsg.incomp = byte
                        parseState = 4
                    elseif parseState == 4 then
                        rcvMsg.comp = byte
                        parseState = 5
                    elseif parseState == 5 then
                        rcvMsg.seq = byte
                        parseState = 6
                        -- TODO: add drop counter
                    elseif parseState == 6 then
                        rcvMsg.sysId = byte
                        if byte == tgtSysId then                
                            parseState = 7
                        else
                            parseState = 11
                            parseCount = 0
                            bytesToSkip = rcvMsg.len + 6
                        end
                    elseif parseState == 7 then
                        rcvMsg.compId = byte
                        parseState = 8
                        parseCount = 0
                        rcvMsg.msgId = 0 --prep for next state
                    elseif parseState == 8 then
                        rcvMsg.msgId = rcvMsg.msgId + byte * 256^parseCount
                        parseCount = parseCount + 1
                        if parseCount>2 then -- TODO: add byte skipping
                            if rcvMsg.len>0 then
                                parseState = 9
                                rcvMsg.payload = {}
                            else
                                parseState = 10
                                local crcE = (formatList[rcvMsg.msgId] or {}).crcExtra
                                if crcE then recvChk.update(crcE) end
                            end
                            parseCount = 0
                        end
                    elseif parseState == 9 then
                        parseCount = parseCount + 1
                        rcvMsg.payload[parseCount] = byte
                        if parseCount >= rcvMsg.len then
                            parseState = 10
                            parseCount = 0
                            local crcE = (formatList[rcvMsg.msgId] or {}).crcExtra
                            if crcE then recvChk.update(crcE) end
                        end
                    elseif parseState == 10 then
                        rcvMsg.checksum=rcvMsg.checksum+byte*(256^parseCount)
                        parseCount = parseCount + 1
                        if parseCount > 1 then
                            parseState = 1
                            parseCount = 0
                            rcvMsg.checksumAcc=recvChk.get()
                            processRcvMsg()
                        end
                elseif parseState == 11 then
                    parseCount = parseCount + 1
                        if parseCount>bytesToSkip then
                            parseState = 1
                            bytesToSkip = 0
                        end
                    end
                end
            elseif not command then --no more commands to process, breakout
                break
            end
        end
        -- TODO handle outgoing traffic
    end -- update


    return true
end