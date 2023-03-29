<script>
export default {
    props: ["name", "description", "details"]
}
</script>

<template>
    <div class="item-details card card-bg">
        <div class="card-header bg-dark">
            <div class="card-title h6">{{ name }}</div>
        </div>
        <div class="card-body">
            <table v-show="details && details.length > 0" class="table">
                <tbody>
                    <tr v-for="row in details" :key="row.label">
                        <td>{{ row.label }}</td>
                        <td v-show="row.text">{{ row.text }}</td>
                    </tr>
                </tbody>
            </table>
            <p class="text-italic">{{ description }}</p>
        </div>
    </div>
</template>

<style>
.item-details {
    z-index: 2
}

.item-details .card-title {
    padding-bottom: 0.7em;
}

.item-details .card-body p {
    margin: 0;
}

.item-details table {
    margin-bottom: 0.5em;
    width: inherit;
}

.item-details td {
    border: none;
    padding: 0.1em;
    padding-right: 0.5em;
}
</style>