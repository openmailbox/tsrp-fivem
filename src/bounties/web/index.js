const closeWindow = function(isSuccess) {
    fetch("https://bounties/bounties:DeleteMissionOffer", {
        method: "POST",
        headers: { "Content-Type": "application/json; charset=UTF-8" },
        body: JSON.stringify({
            success: isSuccess
        })
    });

    document.body.classList.add("d-none");
};

const handleMessage = function(item) {
    switch (item.type) {
        case "bounties:CreateMissionOffer":
            document.body.classList.remove("d-none");
            break;
    }
};

window.addEventListener("message", function(event) {
    handleMessage(event.data);
});

document.querySelector(".btn-error").addEventListener("click", function() {
    closeWindow(false);
});

document.querySelector(".btn-success").addEventListener("click", function() {
    closeWindow(true);
});
