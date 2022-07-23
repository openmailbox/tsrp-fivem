import { createApp } from 'vue'

Atm.Deposit = (function() {
    let vm = null;

    const app = createApp({
        data() {
            return {
                cashInPocket:  0,
                depositAmount: 0,
                hasError:      false,
                errorMessage:  '',
                isActive:      false
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

            createDeposit() {
                if (this.depositAmount < 1) {
                    this.errorMessage = 'Deposit must be greater than $0.'
                    this.hasError     = true;
                    return
                }

                if (this.cashInPocket < this.depositAmount) {
                    this.errorMessage = 'Insufficient cash in your wallet.'
                    this.hasError     = true;
                    return
                }
            },

            createSession(cash) {
                this.hasError      = false;
                this.cashInPocket  = cash;
                this.depositAmount = cash;
                this.isActive      = true;
            },
        }
    });

    const createSession = function(cash) {
        vm.createSession(cash);
    }

    vm = app.mount('#atm');

    return {
        createSession: createSession
    }
})();
