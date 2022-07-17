ProgressBar = {}

local count = 0;

--- Show a progress bar in the UI
-- @tparam number duration the number of milliseconds it takes for the bar to fill
-- @tparam string text the text to display in the bar
-- @treturn number a handle for the progress bar in case it needs to be cancelled
ProgressBar.Show = function(duration, text)
    count = count + 1

    SendNUIMessage({
        type     = Events.CREATE_PROGRESS_BAR,
        handle   = count,
        duration = duration,
        text     = text
    })

    return count
end
exports("ShowProgressBar", ProgressBar.Show)

ProgressBar.Cancel = function(handle)
    SendNUIMessage({
        type   = Events.DELETE_PROGRESS_BAR,
        handle = handle
    })
end
exports("CancelProgressBar", ProgressBar.Cancel)
