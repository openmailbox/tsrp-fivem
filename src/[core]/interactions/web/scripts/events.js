window.Interactions = {};

Interactions.Events = (function() {
    const _handle = function(item) {
        switch (item.type) {
            case "interactions:CreateObject":
                Interactions.Main.startDrawing(item.item);
                break;
            case "interactions:UpdateObject":
                Interactions.Main.updateTarget(item);
                break;
            case "interactions:DeleteObject":
                Interactions.Main.stopDrawing();
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
