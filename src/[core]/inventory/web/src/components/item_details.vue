<script>
export default {
    props: ["name", "description"]
}
</script>

<template>
    <div class="card card-bg">
        <div class="card-header bg-dark">
            <div class="card-title h6">{{ name }}</div>
        </div>
        <div class="card-body">
            <p class="text-italic">{{ description }}</p>
        </div>
    </div>
</template>

<style>
.card {
}

.card-title {
    padding-bottom: 0.7em;
}

.card-body p {
    margin: 0;
}
</style>