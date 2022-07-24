Welcome.Events = (function() {
    const _handle = function(item) {
        switch (item.type) {
            case "welcome:CreateSession":
                document.querySelector(".modal").classList.add("active");
                break;
        }
    }

    const _initialize = function() {
        window.addEventListener("message", function(event) {
            _handle(event.data);
        });

        document.querySelector("button").addEventListener("click", function(_) {
            fetch("https://welcome/welcome:DeleteSession", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=UTF-8" },
                body: JSON.stringify({})
            })

            document.querySelector(".modal").classList.remove("active");
        });
    };

    _initialize();

    return {};
})();
