<script>
export default {
    data() {
        return {
            cashInPocket: 0,
            depositAmount: 0,
            hasError: false,
            errorMessage: '',
            isActive: false,
            isLoading: false
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
                this.hasError = true;
                return
            }

            if (this.cashInPocket < this.depositAmount) {
                this.errorMessage = 'Insufficient cash in your wallet.'
                this.hasError = true;
                return
            }

            this.isLoading = true;

            fetch("https://atm/atm:CreateDeposit", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=UTF-8" },
                body: JSON.stringify({ amount: this.depositAmount })
            }).then(resp => resp.json()).then(function (response) {
                this.hasError = !response.success;
                this.errorMessage = response.error;
                this.isLoading = false;

                if (this.hasError) return;

                this.cancel();
            }.bind(this));
        },

        createSession(cash) {
            this.hasError = false;
            this.cashInPocket = cash;
            this.depositAmount = cash;
            this.isActive = true;
        },
    }
}
</script>

<template>
    <div v-show="isActive" id="deposit" class="bg-dark card">
        <div class="card-header">
            <div class="card-title h5">Deposit Cash</div>
        </div>
        <div class="card-body">
            <div :class="{ 'form-group': true, 'has-error': hasError }">
                <label class="form-label">Amount</label>
                <input class="form-input" type="number" v-model="depositAmount" />
                <p v-show="hasError" class="form-input-hint">{{ errorMessage }}</p>
            </div>
        </div>
        <div class="card-footer p-centered">
            <button @click="createDeposit"
                :class="{ btn: true,  'btn-success': true, loading: isLoading, disabled: isLoading }">Deposit</button>
            <button @click="cancel" class="btn btn-error">Cancel</button>
        </div>
    </div>
</template>

<style>
#deposit {
    border: none;
    margin: 40vh auto;
    width: 20vw;
}

#deposit button {
    margin: auto 1em;
}
</style>
