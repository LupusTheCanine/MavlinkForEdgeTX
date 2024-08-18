local err, fun
local ID=0
function init()
    fun, err = loadScript("/SCRIPTS/LIBS/TestLib.lua")
    ID = fun()
end

function run(event, touchState)
    lcd.clear(lcd.RGB(0))
    lcd.drawText(10,10,"Ready",TEXT_COLOR)
    TestLib.update()
    if err then
        lcd.drawTextLines(10,40,LCD_W-20,LCD_H-50,err,TEXT_COLOR)
    else
        lcd.drawText(10,40,string.format("W: %d/%d\nT: %f0.2",ID,TestLib.getInstnaceCount(),TestLib.getCounter()),TEXT_COLOR)
    end
    return 0
end

return {init=init,run=run}