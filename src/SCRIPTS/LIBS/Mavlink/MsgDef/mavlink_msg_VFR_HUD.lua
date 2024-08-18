local VFR_HUD = {}
VFR_HUD.id = 74
VFR_HUD.fields = {
             { "airspeed", "<f" },
             { "groundspeed", "<f" },
             { "alt", "<f" },
             { "climb", "<f" },
             { "heading", "<i2" },
             { "throttle", "<I2" },
             }
VFR_HUD.crcExtra = 20
return VFR_HUD
