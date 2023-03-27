<script>
import ParkedVehicle from './parked_vehicle.vue'

export default {
    components: { ParkedVehicle },
    props: ["vehicles"]
}
</script>

<template>
    <div class="panel" id="impound">
        <div class="panel-header">
            <div class="h5 panel-title">Impound</div>
        </div>
        <div class="panel-body">
            <table class="table">
                <thead>
                    <tr>
                        <th>Plate</th>
                        <th>Model</th>
                        <th>Owner</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <ParkedVehicle v-for="vehicle in vehicles"
                        @on-close="this.$emit('on-close')"
                        :id="vehicle.id"
                        :plate="vehicle.plate"
                        :model="vehicle.model"
                        :owner="vehicle.owner"
                    />
                </tbody>
            </table>
        </div>
        <div class="panel-footer text-right">
            <button @click="this.$emit('on-close')" class="btn btn-secondary text-dark">Close</button>
        </div>
    </div>
</template>

<style>
</style>