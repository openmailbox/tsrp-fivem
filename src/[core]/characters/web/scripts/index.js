const HTTP_OPTIONS = {
    method: "POST",
    headers: { "Content-Type": "application/json; charset=UTF-8" }
}

// Handle messages passed from client-side scripts to NUI
const handleMessage = function(item) {
    switch (item.type) {
        case "characters:CreateSelectSession":
            document.getElementById("create-character").classList.remove("d-none");
            break;
        case "characters:DeleteSelectSession":
            document.getElementById("create-character").classList.add("d-none");
            break;
        case "characters:CreateNamePrompt":
            NewCharacter.toggle(true);
            break;
    }
};

const selectCharacter = function() {
    fetch("https://characters/characters:CreateSelection", HTTP_OPTIONS).then(resp => resp.json()).then((resp) => {
        if (!resp.success) return;

        Confirmation.prompt({
            title:      "Select Character",
            message:    `Enter the game as ${resp.name}?`,
            showCancel: true,
            callback:   function(buttonText) {
                if (buttonText === "Cancel") return;

                const options = {
                    ...HTTP_OPTIONS,
                    body: JSON.stringify({ id: resp.id })
                }

                fetch("https://characters/characters:UpdateSelection", options);
            }
        })
    })
};

document.getElementById("btn-create-character").addEventListener("click", function(event) {
    event.target.classList.add("loading", "disabled");

    fetch("https://characters/characters:CreateAuthRequest", HTTP_OPTIONS).then(resp => resp.json()).then((resp) => {
        event.target.classList.remove("loading", "disabled");

        if (resp.success) {
            fetch("https://characters/characters:CreateNewCharacter", HTTP_OPTIONS);
            document.getElementById("create-character").classList.add("d-none");
        } else {
            Confirmation.prompt({
                title: "New Character",
                message: resp.message
            })
        }
    });
});

window.addEventListener("message", function(event) {
    handleMessage(event.data);
});

window.addEventListener("click", function() {
    selectCharacter();
});
