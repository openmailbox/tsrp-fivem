import { createApp } from 'vue'

Atm.Deposit = (function() {
    let vm = null;

    const app = createApp({
        data() {
            return {
                isActive: false
            }
        },
        methods: {
            cancel() {
                fetch("https://atm/atm:DeleteSession", {
                    method: "POST",
                    headers: { "Content-Type": "application/json; charset=UTF-8" }
                });

                this.isActive = false;
            },

            createSession() {
                this.isActive = true;
            },
        }
    });

    const createSession = function() {
        vm.createSession();
    }

    vm = app.mount('#atm');

    return {
        createSession: createSession
    }
})();
