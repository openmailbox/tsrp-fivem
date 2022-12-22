const HTTP_OPTIONS = {
    method: "POST",
    headers: { "Content-Type": "application/json; charset=UTF-8" }
}

let fetching = false;

// Handle messages passed from client-side scripts to NUI
const handleMessage = function(item) {
    switch (item.type) {
        case "characters:CreateSelectSession":
            document.body.classList.remove("d-none");
            break;
    }
};

const showMessage = function(title, message) {
    document.querySelector(".modal-title").innerText = title;
    document.querySelector(".content").innerText = message;
    document.querySelector(".modal").classList.add("active");
};

document.getElementById("btn-close").addEventListener("click", function() {
    document.querySelector(".modal").classList.remove("active");
});

document.getElementById("btn-create-character").addEventListener("click", function(event) {
    if (fetching) return;
    fetching = true;

    event.target.classList.add("loading");

    fetch("https://characters/characters:CreateAuthRequest", HTTP_OPTIONS).then(resp => resp.json()).then((resp) => {
        fetching = false;
        event.target.classList.remove("loading");

        if (!resp.success) {
            showMessage(resp.subject, resp.message);
            return;
        }

        fetch("https://characters/characters:CreateNewCharacter", HTTP_OPTIONS);
        document.body.classList.add("d-none");
    });
});

window.addEventListener("message", function(event) {
    handleMessage(event.data);
});
