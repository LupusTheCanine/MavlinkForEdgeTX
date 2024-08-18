local name = "AP Msg"

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
    local fnc, err = loadScript("/SCRIPTS/LIBS/utils.lua")  --load LibPack (provides string.pack and unpack equivalents using array instead of string)
    if fnc then
        fnc()
    elseif err then
        popupWarning(err,30)
    else
        popupWarning("something went horribly wrong",30)
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
    else
        Logger.drawLog(widget.zone.x,widget.zone.y,widget.zone.w,widget.zone.h-10)
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
