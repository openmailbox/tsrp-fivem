<script>
export default {
    props: ["name", "description"]
}
</script>

<template>
    <div class="item-details card card-bg">
        <div class="card-header bg-dark">
            <div class="card-title h6">{{ name }}</div>
        </div>
        <div class="card-body">
            <p class="text-italic">{{ description }}</p>
        </div>
    </div>
</template>

<style>
.item-details .card-title {
    padding-bottom: 0.7em;
}

.item-details .card-body p {
    margin: 0;
}
</style>