local name = "MavL Stat"

-- Create a table with default options
-- Options can be changed by the user from the Widget Settings menu
-- Notice that each line is a table inside { }
local options = {
    { "debugMode", BOOL, 0 },
}


local function create(zone, options)
    local fnc,err = loadScript("/SCRIPTS/LIBS/Mavlink/Mavlink.lua","Td")
    local widget={}
    widget.err = err
    if fnc then 
        fnc()
        fnc = nil
    end
    Mavlink.setDebugMode(options.debugMode == 1)

    widget.zone=zone
    widget.options=options
  return widget
end

local function update(widget, options)
  -- Runs if options are changed from the Widget Settings menu
  widget.options = options
  Mavlink.setDebugMode(options.debugMode == 1)
end

local function background(widget)
    Mavlink.update()
end

local function refresh(widget, event, touchState)
    background(widget)
    if widget.err then
        lcd.drawTextLines(widget.zone.x+10,widget.zone.y,widget.zone.w-10,widget.zone.h,widget.err)
    else
        lcd.drawText(widget.zone.x+10, widget.zone.y,
            string.format("Dropped: %4d/%-6d packets \n Last packet: %0.1fs ago",
                Mavlink.vehicle.dropCount,
                Mavlink.vehicle.packetCount,
                (getTime() - Mavlink.vehicle.lastSeen) / 100
            )
        )
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
