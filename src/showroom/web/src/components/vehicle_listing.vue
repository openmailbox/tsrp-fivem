<script>
export default {
    methods: {
        selectVehicle() {
            this.$emit('selectVehicle', {
                category: this.category,
                name: this.name,
                price: this.price,
                owned: 0
            })
        }
    },
    props: ["category", "name", "price"]
}
</script>

<template>
    <tr class="vehicle-listing" @click="selectVehicle()">
        <td>{{ name }}</td>
        <td>{{ price }}</td>
    </tr>
</template>

<style>
</style>
