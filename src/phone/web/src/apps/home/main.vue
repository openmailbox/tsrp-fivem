<script>
import App from './installed_app.vue'

export default {
    components: { App },
    props: ["installed-apps"]
}
</script>

<template>
    <div class="container">
        <App v-for="appName in installedApps"
            class="app"
            :name="appName"
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
