local name = "AP Attit"
local rad2deg = 57.2957795131
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
    elseif Mavlink.vehicle.ATT then
        local pitch,roll= Mavlink.vehicle.ATT.pitch*rad2deg,Mavlink.vehicle.ATT.roll*rad2deg
        lcd.drawText(widget.zone.x+10,widget.zone.y,string.format("Pitch: %5.1f\n Roll:  %5.1f",pitch,roll))
        lcd.drawHudRectangle(pitch,roll,widget.zone.x+100,widget.zone.x+widget.zone.w,widget.zone.y,widget.zone.y+widget.zone.h)

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
