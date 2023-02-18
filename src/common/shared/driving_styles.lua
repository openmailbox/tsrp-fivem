DrivingStyles = {
    STOP_BEFORE_VEHICLES   = 1,
    STOP_BEFORE_PEDS       = 2,
    AVOID_VEHICLES         = 4,
    AVOID_EMPTY_VEHICLES   = 8,
    AVOID_PEDS             = 16,
    AVOID_OBJECTS          = 32,
    STOP_AT_TRAFFIC_LIGHTS = 128,
    USE_BLINKERS           = 256,
    ALLOW_WRONG_WAY        = 512,     -- only if correct lane is full
    GO_IN_REVERSE          = 1024,
    SHORTEST_PATH          = 262144,
    AVOID_OFFROAD          = 524288,
    IGNORE_ROADS           = 4194304, -- only works within ~200 meters of player
    IGNORE_ALL_PATHING     = 16777216,
    AVOID_HIGHWAYS         = 536870912,
}

DrivingStyles.NORMAL = DrivingStyles.STOP_BEFORE_VEHICLES +
                       DrivingStyles.STOP_BEFORE_PEDS +
                       DrivingStyles.STOP_AT_TRAFFIC_LIGHTS +
                       DrivingStyles.USE_BLINKERS

DrivingStyles.RUSHED = DrivingStyles.STOP_BEFORE_VEHICLES +
                       DrivingStyles.STOP_BEFORE_PEDS +
                       DrivingStyles.AVOID_VEHICLES +
                       DrivingStyles.AVOID_PEDS +
                       DrivingStyles.AVOID_OBJECTS +
                       DrivingStyles.ALLOW_WRONG_WAY
