const InputHandler = (function() {
    const startRotation = function(direction) {
        fetch("https://wardrobe/wardrobe:CreateRotation", {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=UTF-8" },
            body: JSON.stringify({ direction: direction })
        });
    };

    const stopRotation = function() {
        fetch("https://wardrobe/wardrobe:DeleteRotation", {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=UTF-8" }
        });
    };

    const _initialize = function() {
        document.addEventListener("keydown", (event) => {
            switch (event.key) {
                case "a":
                    startRotation(-1);
                    break;
                case "d":
                    startRotation(1);
                    break;
            }
        });

        document.addEventListener("keyup", (event) => {
            switch (event.key) {
                case "a":
                case "d":
                    stopRotation();
                    break;
            }
        });
    };

    _initialize();
})();
