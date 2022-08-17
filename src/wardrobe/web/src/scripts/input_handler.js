const InputHandler = (function() {
    const fetch = function(event, params) {
        fetch(`https://wardrobe/wardrobe:${event}`, {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=UTF-8" },
            body: JSON.stringify(params || {})
        });
    };

    const _initialize = function() {
        document.addEventListener("keydown", (event) => {
            switch (event.key) {
                case "a":
                    fetch("CreateRotation", { direction: -1 });
                    break;
                case "d":
                    fetch("CreateRotation", { direction: 1 });
                    break;
                case "w":
                    fetch("CreateCameraPan", { direction: 1 });
                    break;
                case "s":
                    fetch("CreateCameraPan", { direction: -1 });
                    break;
            }
        });

        document.addEventListener("keyup", (event) => {
            switch (event.key) {
                case "a":
                case "d":
                    fetch("DeleteRotation");
                    break;
                case "w":
                case "s":
                    fetch("DeleteCameraPan");
                    break;
            }
        });
    };

    _initialize();
})();
