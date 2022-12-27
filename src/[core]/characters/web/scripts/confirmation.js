window.Confirmation = (function() {
    let nextCallback = null;

    const prompt = function(options) {
        nextCallback = options.callback || null;

        setTitle(options.title);
        setMessage(options.message);

        if (options.buttons) {
            document.querySelector("#modal-confirmation .btn-primary").innerText = options.buttons[0];

            if (options.buttons[1]) {
                document.querySelector("#modal-confirmation .btn-secondary").innerText = options.buttons[1];
            }
        }

        toggle(true);
    };

    const setTitle = function(newTitle) {
        document.querySelector("#modal-confirmation .modal-title").innerText = newTitle;
    };

    const setMessage = function(newMessage) {
        document.getElementById("modal-message").innerText = newMessage;
    };

    const toggle = function(isShowing) {
        if (isShowing) {
            document.getElementById("modal-confirmation").classList.add("active");
        } else {
            document.getElementById("modal-confirmation").classList.remove("active");
        }
    };

    document.querySelector("#modal-confirmation .btn-primary").addEventListener("click", function(event) {
        toggle(false);

        if (nextCallback) {
            nextCallback(event.target.innerText);
            nextCallback = null;
        }
    });

    return {
        prompt: prompt,
        setMessage: setMessage,
        setTitle: setTitle,
        toggle: toggle
    };
})();
