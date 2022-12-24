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
        case "characters:CreateNamePrompt":
            NewCharacter.toggle(true);
            break;
    }
};

document.getElementById("btn-create-character").addEventListener("click", function(event) {
    event.target.classList.add("loading", "disabled");

    fetch("https://characters/characters:CreateAuthRequest", HTTP_OPTIONS).then(resp => resp.json()).then((resp) => {
        event.target.classList.remove("loading", "disabled");

        if (resp.success) {
            fetch("https://characters/characters:CreateNewCharacter", HTTP_OPTIONS);
            document.getElementById("create-character").classList.add("d-none");
        } else {
            Confirmation.setTitle("New Character");
            Confirmation.setMessage(resp.message);
            Confirmation.toggle(true);
        }
    });
});

window.addEventListener("message", function(event) {
    handleMessage(event.data);
});
