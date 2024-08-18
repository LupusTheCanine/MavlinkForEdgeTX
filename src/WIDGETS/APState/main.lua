local name = "AP State"

-- Create a table with default options
-- Options can be changed by the user from the Widget Settings menu
-- Notice that each line is a table inside { }
local options = {
}


local function create(zone, options)
    local fnc,err = loadScript("/SCRIPTS/LIBS/Mavlink/Mavlink.lua","Td")
    local widget={}
    widget.err = err
    if fnc then 
        fnc()
        fnc = nil
    end
    widget.zone=zone
    widget.options=options
  return widget
end

local function update(widget, options)
  -- Runs if options are changed from the Widget Settings menu
  widget.options = options
end

local function background(widget)
    Mavlink.update()
end

local function refresh(widget, event, touchState)
    background(widget)
    if widget.err then
        lcd.drawTextLines(widget.zone.x+10,widget.zone.y,widget.zone.w-10,widget.zone.h,widget.err)
    elseif Mavlink.vehicle.HEARTBEAT then
        if Mavlink.vehicle.HEARTBEAT.isArmed then
            lcd.drawText(widget.zone.x+10,widget.zone.y,"ARMED")
        else
            lcd.drawText(widget.zone.x+10,widget.zone.y,"DISARMED")
        end
        lcd.drawText(widget.zone.x+10,widget.zone.y+20, Mavlink.vehicle.HEARTBEAT.ModeName)
    else
        lcd.drawText(widget.zone.x+10,widget.zone.y+10, "Not connected")
    end
end 
return {
  name = name,
  options = options,
  create = create,
  update = update,
  refresh = refresh,
  background = background
}
