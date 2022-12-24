window.NewCharacter = (function() {
    const toggle = function(isShowing) {
        if (isShowing) {
            document.getElementById("modal-new-character").classList.add("active");
        } else {
            document.getElementById("modal-new-character").classList.remove("active");
        }
    };

    const _validate = function(isFirstValid, isLastValid) {
        if (isFirstValid) {
            document.getElementById("first-name").classList.remove("has-error");
            document.querySelector("#first-name .form-input-hint").classList.add("d-none");
        } else {
            document.getElementById("first-name").classList.add("has-error");
            document.querySelector("#first-name .form-input-hint").classList.remove("d-none");
        }

        if (isLastValid) {
            document.getElementById("last-name").classList.remove("has-error");
            document.querySelector("#last-name .form-input-hint").classList.add("d-none");
        } else {
            document.getElementById("last-name").classList.add("has-error");
            document.querySelector("#last-name .form-input-hint").classList.remove("d-none");
        }
    };

    document.querySelector("#modal-new-character .btn-success").addEventListener("click", function(event) {
        event.target.classList.add("loading", "disabled");

        const firstName = document.getElementById("input-first-name").value;
        const lastName  = document.getElementById("input-last-name").value;

        fetch("https://characters/characters:CreateNameValidation", {
            method: "POST",
            headers: { "Content-Type": "application/json; charset=UTF-8" },
            body: JSON.stringify(({ first: firstName, last: lastName }))
        }).then(resp => resp.json()).then((resp) => {
            event.target.classList.remove("loading", "disabled");

            if (resp.success) {
                fetch("https://characters/characters:CreateFinished", HTTP_OPTIONS)
                toggle(false);
            } else {
                _validate(resp.first, resp.last);
            }
        });
    });

    document.querySelector("#modal-new-character .btn-error").addEventListener("click", function() {
        fetch("https://characters/characters:DeleteNewCharacter", HTTP_OPTIONS)
        toggle(false);
    });

    return {
        toggle: toggle
    };
})();