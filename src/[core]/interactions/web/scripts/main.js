Interactions.Main = (function() {
    let element   = document.getElementById("interactive-object");
    let isDrawing = false;
    let height    = window.innerHeight;
    let width     = window.innerWidth;
    let positionX = 0;
    let positionY = 0;
    let targetX   = 0;
    let targetY   = 0;

    /**
     * Start drawing a nearby object that is interactable
     * @param {Object} item - Serialize item details
     */
    const startDrawing = function(item) {
        height    = window.innerHeight;
        width     = window.innerWidth;
        isDrawing = true;

        if (item.name) {
            document.querySelector("#interactive-object .title").innerText = item.name;
        } else {
            document.querySelector("#interactive-object .title").innerText = "";
        }

        element.classList.remove("d-none");

        if (isDrawing) return;
        window.requestAnimationFrame(_draw);
    };

    const stopDrawing = function() {
        element.classList.add("d-none");
        isDrawing = false;
    };

    /**
     * Update the position of the world item we're drawing.
     * @param {Object} data
     * @param {number} data.x - The x-location of the object
     * @param {number} data.y - The y-location of the object
     */
    const updateTarget = function(data) {
        targetX = data.x * width;
        targetY = data.y * height;

        if (data.name) {
            document.querySelector("#interactive-object .title").innerText = data.name;
        }
    };

    /**
     * Draw the next frame.
     * @param {DOMHighResTimeStamp} timestamp
     */
    const _draw = function(_timestamp) {
        positionY = _lerp(positionY, targetY, 0.1);
        positionX = _lerp(positionX, targetX, 0.1);

        element.style.top = (positionY - element.offsetHeight) + "px";
        element.style.left = (positionX - element.offsetWidth) + "px";

        if (isDrawing) {
            window.requestAnimationFrame(_draw);
        }
    }

    const _lerp = function(start, end, t) {
        return start * (1 - t) + end * t;
    };

    return {
        startDrawing: startDrawing,
        stopDrawing: stopDrawing,
        updateTarget: updateTarget
    };
})();