# Progress Bar
Handles the in-game progress bar and provides an API.

```lua
-- Displays a progress bar for three seconds that says "Opening"
local id = exports.progress:CreateProgressBar(3000, "Opening")

-- Cancels the progress bar before it completes. No-op if already completed.
exports.progress:DeleteProgressBar(id)
```
