window.Example = {}

Example.Events = (function() {
    const _handle = function(item) {
        switch (item.type) {
            case "someEventName":
                // Handle some event sent from client via SendNUIMessage()
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
