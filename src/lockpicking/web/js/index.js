"use strict";

var activeTumblers  = new Array();
var currentTumbler  = 0;
var instanceID      = null;
var rendering       = false;
var storedData      = null;
var pickBreakChance = null;

(function (namespace) {
    var pick = null;

    function handleIncomingEvent(data) {
        switch (data.type) {
            case "lockpicking:CreateSession":
                document.body.classList.remove("d-none");
                initialize(data.difficulty);
                storedData = data.passedData;
                instanceID = data.id;
                pickBreakChance = data.pickBreakChance;
                rendering = true;
                break;
            case "lockpicking:DeleteSession":
                closeWindow("fail")
                break;
            default:
                console.warn("Unexpected message: " + data.type)
                break;
        }
    }

    function initialize(difficulty) {
        var tumblers = document.getElementById("tumblers");
        tumblers.innerHTML = "";
        generateTumblers(config[difficulty]);
        setupPick();
    }

    function generateTumblers(data) {
        activeTumblers = []
        for (var i = 0; i < data.tumblerCount; i++) {
            activeTumblers[i] = new Tumbler(i, data);
        }
        currentTumbler = activeTumblers.length - 1;
    }

    function setupPick() {
        pick = new Pick();
        pick.render();
    }

    window.addEventListener("message", function (event) {
        handleIncomingEvent(event.data);
    });

    window.addEventListener("keyup", async function (event) {
        // if (!rendering) return;
        if (event.defaultPrevented) return;

        switch (event.key) {
            case "a":
                pick.move("left");
                break;
            case "d":
                pick.move("right");
                break;
            case " ":
                pick.use();
                await sleep(100);
                activeTumblers[currentTumbler].use();
                break;
            case "Escape":
                closeWindow("fail");
                break;
        }

        event.preventDefault();
    }, true);

    window.addEventListener("mouseup", function (event) {
        if (event.button == 0)
            activeTumblers[currentTumbler].attemptUnlock();
    });
})(window.Lockpick = window.Lockpick || {});

function closeWindow(completionType) {
    document.body.classList.add("d-none");
    document.getElementById("tumblers").innerHTML = "";
    rendering = false;
    fetch(`https://lockpicking/lockpicking:DeleteSession`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: JSON.stringify({
            completionType: completionType,
            id: instanceID,
            passedData: storedData
        })
    });
}
