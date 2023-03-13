<script>
export default {
    computed: {
        formatVehicleLabel() {
            return `${this.label[0].toUpperCase()}${this.label.slice(1).toLowerCase()} (${this.name})`
        }
    },
    methods: {
        selectVehicle() {
            this.$emit('selectVehicle', {
                category: this.category,
                name: this.formatVehicleLabel,
                price: this.price,
                owned: 0
            })

            fetch("https://showroom/showroom:CreateVehiclePreview", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=UTF-8" },
                body: JSON.stringify({ name: this.name })
            });
        }
    },
    props: ["category", "name", "price", "label"]
}
</script>

<template>
    <tr class="vehicle-listing" @click="selectVehicle()">
        <td>{{ formatVehicleLabel }}</td>
        <td>{{ price }}</td>
    </tr>
</template>

<style>
</style>
