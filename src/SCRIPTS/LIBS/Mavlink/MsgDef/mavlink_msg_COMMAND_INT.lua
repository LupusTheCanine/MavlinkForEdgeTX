local COMMAND_INT = {}
COMMAND_INT.id = 75
COMMAND_INT.fields = {
             { "param1", "<f" },
             { "param2", "<f" },
             { "param3", "<f" },
             { "param4", "<f" },
             { "x", "<i4" },
             { "y", "<i4" },
             { "z", "<f" },
             { "command", "<I2" },
             { "target_system", "<B" },
             { "target_component", "<B" },
             { "frame", "<B" },
             { "current", "<B" },
             { "autocontinue", "<B" },
             }
COMMAND_INT.crcExtra = 158
return COMMAND_INT
