local function init()
    -- init is called once when model is loaded
  end
  local time=0
  local counter=0
  local seq=0
local function run(event, touchState)    
    now=getTime()
    if now-time>50 then
        time=now
        local command=0x7e
        local frame={0xC8,0xEA,counter*8,0xFD,0x00,0x00,seq,254,190,0x1,0x2,0x3,0x4,0x5,0x6}
        counter=counter+1
        if counter>=256/8 then
            counter=0
        end
        seq=seq+1
        if seq>255 then
            seq=0
        end
        crossfireTelemetryPush(command,frame)
    end
    return 0
end
  
  return { run=run, init=init }
  