<script>
import "../../../common/web/styles/tsrp-theme.css";
import Impound from './components/impound.vue'
//import TestData from './test/vehicles'

export default {
    components: { Impound },
    data() {
        return {
            impoundVehicles: [], // TestData.impounded,
            isActive: false
        }
    },
    methods: {
        exit() {
            this.isActive = false;

            fetch("https://vehicles/vehicles:DeleteImpoundSession", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=UTF-8" }
            });
        },

        updateImpoundedVehicles(data) {
            this.impoundVehicles = data;
            this.isActive = true;
        }
    }
}
</script>

<template>
    <main v-show="isActive" class="tsrp-bg-semi-90 text-light">
        <Impound
            @on-close="exit"
            :vehicles="impoundVehicles"
        />
    </main>
</template>

<style>
main {
    margin: 50vh auto 0 auto;
    transform: translateY(-50%);
    width: 50vw;
}
</style>
