---@meta

---@return integer time time since boot in 10ms units
function getTime() end


---@param path string path to script
---@param mode? string mode to laoad
---@param env? array
---@return function|nil fnc contains body of loaded script
---@return nil|string err error
function loadScript(path,mode,env) end

---
---@param error string error text to display
---@param event integer event
function popupWarning(error, event) end

---@param path string path to directory
---@return table # list of files 
function dir(path) end

---@return integer command
---@return integer[] packet
function crossfireTelemetryPop() end

---@class
lcd={}
function lcd.drawText(x,y,text,flags) end
function lcd.drawTextLines(x,y,w,h,text,flags) end

SMLSIZE=1