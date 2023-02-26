<script>
export default {
    props: ["name"]
}
</script>

<template>
    <div class="p-absolute card card-bg">
        <div class="card-header">
            <div class="card-title h6">{{ name }}</div>
        </div>
        <div class="card-body"></div>
    </div>
</template>

<style>
.card {
    margin-top: -2vh;
    margin-left: -20vw;
    width: 20vw;
    z-index: 1;
}
</style>