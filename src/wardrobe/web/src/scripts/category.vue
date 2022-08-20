<script>
export default {
    props: ['label']
}
</script>

<template>
    <div class="category col-6">
        <img class="wardrobe-icon d-block" src="https://img.icons8.com/nolan/64/fill-color.png">
        <span class="title h5">{{ label }}</span>
    </div>
</template>

<style>
.category {
    border: 1px solid #2D375B;
    border-right: 5px solid #2D375B;
    height: 7em;
    padding: 10px 0;
    text-align: center;
}

.title {
    font-size: 1em;
}

.wardrobe-icon {
    height: 64px;
    width: 64px;
    margin: auto;
}
</style>
