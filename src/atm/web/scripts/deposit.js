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
                isActive:      false,
                isLoading:     false
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
                if (this.isLoading) return;
                this.hasError = false;

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

                this.isLoading = true;

                fetch("https://atm/atm:CreateDeposit", {
                    method: "POST",
                    headers: { "Content-Type": "application/json; charset=UTF-8" },
                    body: JSON.stringify({ amount: this.depositAmount })
                }).then(resp => resp.json()).then(function(response) {
                    this.hasError     = !response.success;
                    this.errorMessage = response.error;
                    this.isLoading    = false;

                    if (this.hasError) return;

                    this.cancel();
                }.bind(this));
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
