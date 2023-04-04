<script>
export default {
    props: ["name"],
    emits: ["openApp"],
    computed: {
        imageUrl() {
            return `/src/assets/icon-${this.name.toLowerCase()}.png`
        }
    }
}
</script>

<template>
    <div>
        <div @click="$emit('openApp', name)" class="app-icon">
            <img :src="imageUrl" class="img-responsive" />
        </div>
        <div class="app-name text-light text-center">
            <p>{{ name }}</p>
        </div>
    </div>
</template>

<style>
.app-icon {
    height: 3.5em;
    margin: auto;
    position: relative;
    width: 3.5em;
}

.app p {
    margin: 0;
}
</style>