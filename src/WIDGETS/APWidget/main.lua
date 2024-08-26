local name = "AP Widget"

local options = {}

local function create(zone, options)
    local widget = {}
    local fnc,err = loadScript("/SCRIPTS/LIBS/Mavlink/Mavlink.lua","Td")
    local widget={}
    widget.err = err
    if fnc then
        fnc()
        fnc = nil
    end
    widget.zone = zone
    widget.options=options
end

local function update(widget,options)
    widget.options=options
end

local function background(widget)
    Mavlink.update()
end

local function refresh(widget,event,touchState)
    background(widget)
    if widget.zone.x ~=0 or widget.zone.w ~=LCD_W or 
     widget.zone.y ~= 0 or widget.zone.h ~= LCD_H then 
        lcd.clear()
        lcd.drawText(widget.zone.x,widget.zone.y,"Fullscreen required",DBLSZE+TEXT_COLOR)
        return 0
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
  