<script>
export default {
    computed: {
        formatMoney() {
            return this.price && new Intl.NumberFormat('en-US', {
                style:               'currency',
                currency:            'USD',
                trailingZeroDisplay: 'stripIfInteger'
            }).format(this.price);
        },

        formatVehicleLabel() {
            return `${this.label[0].toUpperCase()}${this.label.slice(1).toLowerCase()} (${this.name})`
        }
    },
    methods: {
        selectVehicle() {
            this.$emit('selectVehicle', {
                category: this.category,
                label: this.formatVehicleLabel,
                name: this.name,
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
        <td>{{ formatMoney }}</td>
    </tr>
</template>

<style>
</style>
