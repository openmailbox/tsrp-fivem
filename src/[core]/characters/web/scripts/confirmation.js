window.Confirmation = (function() {
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

    document.querySelector("#modal-confirmation .btn-primary").addEventListener("click", function() {
        toggle(false);
    });

    return {
        setMessage: setMessage,
        setTitle: setTitle,
        toggle: toggle
    };
})();
