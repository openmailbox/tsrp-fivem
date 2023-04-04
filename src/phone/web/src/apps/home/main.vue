<script>
import App from './installed_app.vue'

export default {
    components: { App },
    props: ["installed-apps"]
}
</script>

<template>
    <div class="container">
        <App v-for="app in installedApps"
            class="app"
            :name="app.name"
            :icon="app.icon"
            @open-app="(name) => $emit('openApp', name)"
        />
    </div>
</template>

<style>
.app {
    display: inline-block;
    margin: 0.5em 0;
    width: 20%;
}
</style>
