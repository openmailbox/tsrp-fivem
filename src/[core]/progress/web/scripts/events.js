window.Progress = {};

Progress.Events = (function() {
    let bars = [];

    const _cleanupProgressBars = function() {
        bars = bars.filter(function(i) {
            return i.timer !== null
        });
    };

    const _handle = function(item) {
        switch (item.type) {
            case "progress:CreateBar":
                _showProgressBar(item.handle, item.duration, item.text);
                break;
            case "progress:DeleteBar":
                _hideProgressBar(item.handle);
                break;
        }
    }

    const _hideProgressBar = function(handle) {
        let found = null;

        for (let i = 0; i < bars.length; i++) {
            if (bars[i].handle == handle) {
                found = bars[i];
                break;
            }
        }

        if (found !== null) {
            found.stop();
        }
    };

    const _initialize = function() {
        window.addEventListener("message", function(event) {
            _handle(event.data);
        });
    };

    const _showProgressBar = function(handle, duration, text) {
        let progress = new Progress.Bar(handle, duration, text);

        document.getElementById("progress-bars").appendChild(progress.element);

        progress.start();
        bars.push(progress);

        _cleanupProgressBars();
    };

    _initialize();

    return {};
})();
