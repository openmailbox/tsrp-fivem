<script>
import App from './installed_app.vue'

export default {
    components: { App },
    data() {
        return {
            apps: [ {} ]
        }
    }
}
</script>

<template>
    <div class="container">
        <App v-for="app in apps" class="app" />
    </div>
</template>

<style>
.app {
    display: inline-block;
    margin: 0.5em 0;
    width: 20%;
}
</style>
