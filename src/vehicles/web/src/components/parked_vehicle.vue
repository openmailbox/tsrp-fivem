<script>
export default {
    data() {
        return {
            isLoading: false
        }
    },
    methods: {
        retrieveVehicle() {
            if (this.isLoading) return;
            this.isLoading = true;

            fetch("https://vehicles/vehicles:CreateParkedRetrieval", {
                method: "POST",
                headers: { "Content-Type": "application/json; charset=UTF-8" },
                body: JSON.stringify({ id: this.id })
            }).then((resp) => resp.json()).then(function(resp) {
                this.isLoading = false;

                if (resp.success) {
                    this.$emit('on-close');
                }
            }.bind(this));
        }
    },
    props: ["id", "plate", "model", "owner"]
}
</script>

<template>
    <tr>
        <td>{{ plate }}</td>
        <td>{{ model }}</td>
        <td>{{ owner }}</td>
        <td>
            <button
                @click="retrieveVehicle"
                :class="{ loading: isLoading }"
                class="btn btn-primary">Retrieve
            </button>
        </td>
    </tr>
</template>
