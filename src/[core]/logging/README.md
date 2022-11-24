# Logging

Things to make logging easier and more useful. Include `@common/shared/logging.lua` in your resource manifest.

Log a uniform message (on client or server):
```lua
TriggerEvent(Events.LOG_MESSAGE, {
    level   = Logging.INFO -- optional
    message = "Hello World!"
})
```

Log levels are defined globally as:
```lua
Logging.FATAL = 0
Logging.ERROR = 1
Logging.WARN  = 2
Logging.INFO  = 3
Logging.DEBUG = 4
Logging.TRACE = 5
```
Set the `LOG_LEVEL` (replicated) configuration variable in `server.cfg` to adjust the application-wide logging level.
