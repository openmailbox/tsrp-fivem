<script>
export default {
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
                        <th>Fees</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="vehicle in vehicles">
                        <td>{{ vehicle.plate }}</td>
                        <td>{{ vehicle.model }}</td>
                        <td>{{ vehicle.owner }}</td>
                        <td>${{ vehicle.fees || 0 }}</td>
                        <td>
                            <button class="btn btn-primary">Retrieve</button>
                        </td>
                    </tr>
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