Atm.Events = (function() {
    const _handle = function(item) {
        switch (item.type) {
            case "atm:CreateSession":
                Atm.Deposit.createSession();
                break;
        }
    }

    const _initialize = function() {
        window.addEventListener("message", function(event) {
            _handle(event.data);
        });
    };

    _initialize();

    return {};
})();
