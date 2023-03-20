window.Welcome = {};

Welcome.Events = (function() {
    const _handle = function(item) {
        switch (item.type) {
            case "welcome:CreateSession":
                document.body.classList.remove("d-none");
                break;
        }
    };

    const _initialize = function() {
        window.addEventListener("message", function(event) {
            _handle(event.data);
        });

        document.querySelector("#modal-support button").addEventListener("click", function() {
            document.querySelector(".modal").classList.remove("active");
        });
    };

    document.getElementById("link-play").addEventListener("click", function() {
        const name = GetParentResourceName();

        fetch(`https://${name}/${name}:DeleteSession`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
        });

        document.body.classList.add("d-none");
    });

    document.getElementById("link-support").addEventListener("click", function() {
        document.querySelector(".modal").classList.add("active");
    });

    document.getElementById("link-settings").addEventListener("click", function() {
        const name = GetParentResourceName();

        fetch(`https://${name}/${name}:UpdateSession`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify({ settings: true })
        });

        document.body.classList.add("d-none");
    });

    document.getElementById("link-quit").addEventListener("click", function() {
        const name = GetParentResourceName();

        fetch(`https://${name}/${name}:DeleteSession`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify({
                quit: true
            })
        });

        document.body.classList.add("d-none");
    });

    _initialize();
})();
