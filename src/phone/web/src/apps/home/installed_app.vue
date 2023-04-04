<script>
export default {
    props: ["name", "icon"],
    emits: ["openApp"]
}
</script>

<template>
    <div>
        <div @click="$emit('openApp', name)" class="app-icon">
            <img :src="icon" class="img-responsive" />
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