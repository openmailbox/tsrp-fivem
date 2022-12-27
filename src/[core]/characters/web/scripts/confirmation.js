window.Confirmation = (function() {
    let nextCallback = null;

    const prompt = function(options) {
        nextCallback = options.callback || null;

        _setTitle(options.title);
        _setMessage(options.message);

        if (options.showCancel) {
            document.querySelector("#modal-confirmation .btn-secondary").classList.remove("d-none");
        } else {
            document.querySelector("#modal-confirmation .btn-secondary").classList.add("d-none");
        }

        _toggle(true);
    };

    const _setTitle = function(newTitle) {
        document.querySelector("#modal-confirmation .modal-title").innerText = newTitle;
    };

    const _setMessage = function(newMessage) {
        document.getElementById("modal-message").innerText = newMessage;
    };

    const _toggle = function(isShowing) {
        if (isShowing) {
            document.getElementById("modal-confirmation").classList.add("active");
        } else {
            document.getElementById("modal-confirmation").classList.remove("active");
        }
    };

    document.querySelectorAll("#modal-confirmation button").forEach(function(elm) {
        elm.addEventListener("click", function(event) {
            _toggle(false);

            if (nextCallback) {
                nextCallback(event.target.innerText);
                nextCallback = null;
            }
        });
    })

    return {
        prompt: prompt,
    };
})();
