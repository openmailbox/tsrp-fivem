// Handle messages passed from client-side scripts to NUI
const handleMessage = function(item) {
    switch (item.type) {
        case "characters:CreateSelectSession":
            document.body.classList.remove("d-none");
            break;
    }
};

window.addEventListener("message", function(event) {
    handleMessage(event.data);
});
