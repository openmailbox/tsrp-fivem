Stashes.Events = (function() {
    const _handle = function(item) {
        switch (item.type) {
            case "stashes:CreateOpening":
                Stashes.StashSelection.open(item.data);
                break;
        }
    }

    const _initialize = function() {
        window.addEventListener("message", function(event) {
            _handle(event.data);
        });
    };

    _initialize();

    return {};
})();
