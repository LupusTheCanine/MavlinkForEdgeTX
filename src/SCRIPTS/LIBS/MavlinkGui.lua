if MavlinkGui then
    return true
end
MavlinkGui = {}
function MavlinkGui.drawHud(zone,scale,solid)
    solid = solid or false
    local rad2deg = 57.2958
    local step = 15
    scale = math.max(scale,0.1)
    local xmin,ymin,xmax,ymax =zone.x, zone.y,zone.x +zone.w,zone.y + zone.h
    local pitch = getValue(2)/1024*180*scale
    local roll = getValue(1)/1024*180
    local cx = (xmin + xmax)/2 + math.sin(roll/rad2deg) * pitch
    local cy = (ymin + ymax)/2 + math.cos(roll/rad2deg) * pitch * 1.85;
    local ax = math.cos(roll/rad2deg)
    local ay = -math.sin(roll/rad2deg)
    local dx = math.sin(roll/rad2deg)*step*scale
    local dy = math.cos(roll/rad2deg)*step*scale
    if solid then
    lcd.drawFilledRectangle(zone.x,zone.y,zone.w,zone.h,BLUE)
    lcd.drawHudRectangle(pitch,roll,zone.x,zone.x+zone.w,zone.y,zone.y+zone.h,LIGHTBROWN)
    else
      lcd.drawLineWithClipping(cx+ax*500,cy+ay*500,cx-ax*500,cy-ay*500,xmin,xmax,ymin,ymax,SOLID,BLACK)
    end
    for it = 1,12 do
      local len = (it %2 == 0 and 40 or 25)*scale*(1-it/15)
      lcd.drawLineWithClipping(cx+ax*len+dx*it,cy+ay*len+dy*it,cx-ax*len+dx*it,cy-ay*len+dy*it,xmin,xmax,ymin,ymax,DOTTED,BLACK)
      lcd.drawLineWithClipping(cx+ax*len-dx*it,cy+ay*len-dy*it,cx-ax*len-dx*it,cy-ay*len-dy*it,xmin,xmax,ymin,ymax,SOLID,BLACK)
    end
end