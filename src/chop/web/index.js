const handleMessage = function(item) {
    switch (item.type) {
        case "chop:CreateMissionOffer":
            document.body.classList.remove("d-none");
            break;
    }
};

window.addEventListener("message", function(event) {
    handleMessage(event.data);
});

document.querySelector(".btn-error").addEventListener("click", function() {
    fetch("https://chop/chop:DeleteMissionOffer", {
        method: "POST",
        headers: { "Content-Type": "application/json; charset=UTF-8" },
    });

    document.body.classList.add("d-none");
});
