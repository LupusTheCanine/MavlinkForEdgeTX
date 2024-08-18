local APFWModeNames={
    [0] = "MANUAL",
    "CIRCLE",
    "STABILIZE",
    "TRAINING",
    "ACRO",
    "FBWA",  --FLY_BY_WIRE_A
    "FBWB", --FLY_BY_WIRE_
    "CRUISE",
    "AUTOTUNE",
    "AUTO",
    "Unused", -- mode 9 is not used
    "RTL",
    "LOITER",
    "TAKEOFF",
    "AVOID_ADSB",
    "GUIDED",
    "INITIALISING",
    "QSTABILIZE",
    "QHOVER",
    "QLOITER",
    "QLAND",
    "QRTL",
    "QAUTOTUNE",
    "QACRO",
    "THERMAL",
    "LOITER_ALT_QLAND",
}
local APMRHModeNames={
    [0]="STABILIZE", -- =     0,  // manual airframe angle with manual throttle
    "ACRO", -- =          1,  // manual body-frame angular rate with manual throttle
    "ALT_HOLD", -- =      2,  // manual airframe angle with automatic throttle
    "AUTO", -- =          3,  // fully automatic waypoint control using mission commands
    "GUIDED", -- =        4,  // fully automatic fly to coordinate or fly at velocity/direction using GCS immediate commands
    "LOITER", -- =        5,  // automatic horizontal acceleration with automatic throttle
    "RTL", -- =           6,  // automatic return to launching point
    "CIRCLE", -- =        7,  // automatic circular flight with automatic throttle
    "Unused",
    "LAND", -- =          9,  // automatic landing with horizontal position control
    "DRIFT", -- =        11,  // semi-autonomous position, yaw and throttle control
    "Unused",
    "SPORT", -- =        13,  // manual earth-frame angular rate control with manual throttle
    "FLIP", -- =         14,  // automatically flip the vehicle on the roll axis
    "AUTOTUNE", -- =     15,  // automatically tune the vehicle's roll and pitch gains
    "POSHOLD", -- =      16,  // automatic position hold with manual override, with automatic throttle
    "BRAKE", -- =        17,  // full-brake using inertial/GPS system, no pilot input
    "THROW", -- =        18,  // throw to launch mode using inertial/GPS system, no pilot input
    "AVOID_ADSB", -- =   19,  // automatic avoidance of obstacles in the macro scale - e.g. full-sized aircraft
    "GUIDED_NOGPS", -- = 20,  // guided mode but only accepts attitude and altitude
    "SMART_RTL", -- =    21,  // SMART_RTL returns to home by retracing its steps
    "FLOWHOLD", --  =    22,  // FLOWHOLD holds position with optical flow without rangefinder
    "FOLLOW", --    =    23,  // follow attempts to follow another vehicle or ground station
    "ZIGZAG", --    =    24,  // ZIGZAG mode is able to fly in a zigzag manner with predefined point A and point B
    "SYSTEMID", --  =    25,  // System ID mode produces automated system identification signals in the controllers
    "AUTOROTATE", -- =   26,  // Autonomous autorotation
    "AUTO_RTL", -- =     27,  // Auto RTL, this is not a true mode, AUTO will report as this mode if entered to perform a DO_LAND_START Landing sequence
    "TURTLE", -- =       28,  
}

local ModeNameTable = {
    [3]={ --ardupilot
        [1]=APFWModeNames,
        [16]=APFWModeNames,
        [17]=APFWModeNames,
        [19]=APFWModeNames,
        [20]=APFWModeNames,
        [21]=APFWModeNames,
        [22]=APFWModeNames,
        [23]=APFWModeNames,
        [24]=APFWModeNames,
        [25]=APFWModeNames,
        [28]=APFWModeNames,

        [2]=APMRHModeNames,
        [3]=APMRHModeNames,
        [4]=APMRHModeNames,
        [13]=APMRHModeNames,
        [14]=APMRHModeNames,
        [15]=APMRHModeNames,
        [29]=APMRHModeNames,
        [35]=APMRHModeNames,
        [43]=APMRHModeNames,
    }
}
return ModeNameTable